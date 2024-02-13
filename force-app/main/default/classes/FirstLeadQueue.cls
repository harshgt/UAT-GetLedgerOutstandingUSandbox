public class FirstLeadQueue implements Queueable, Database.AllowsCallouts{
    public  List<Lead> MainLeadList;
    String SAPId;
    String CustomerId;
    String SAPAddressId;
    String CustomerAddressId;
    
    public FirstLeadQueue(List<Lead> MainLeadList){
        this.MainLeadList = MainLeadList;
    }
    
    public void execute(QueueableContext qc){
        
        
        
        for(Lead leads : this.MainLeadList){
            
            Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;
            
            String BPCreationURL = customSetting.BPCreationURL__c ;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(BPCreationURL);
            req.setMethod('POST');
            
            
            Blob headerValue = Blob.valueOf(Username + ':' + Password);        
            String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('authorization', authorizationHeader);
            //req.setHeader('Content-Type', 'application/xml');
            //req.setHeader('Accept','application/xml');
            
            Dom.Document doc = new Dom.Document();
            
            Dom.XmlNode root = doc.createRootElement('ID', null, null);
            
            // Create A_BusinessPartnerType element
            Dom.XmlNode IDroot = root.addChildElement('IDchild', null, null);
            IDroot.addChildElement('Id', null, null).addTextnode(leads.Id);
            
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            //Adding Body to request
            req.setBody(XmlBody);
            System.debug(XmlBody);
            
            try{
                
                HttpResponse res = http.send(req);
                System.debug(res.getBody());
                System.debug(res.getStatus());
                System.debug(res.getStatusCode());
                
                if(res.getStatusCode() == 201){
                    
                    
                    Dom.Document doc2 = res.getBodyDocument();
                    
                    for(Dom.XmlNode node : doc2.getRootElement().getChildElements()){
                        
                        for(Dom.XmlNode node2 : node.getChildElements()){
                            if(node2.getName() == 'BPAddressid'){
                                CustomerAddressId = node2.getText();
                            }
                            else if(node2.getName() == 'CPAddressId'){
                                SAPAddressId = node2.getText();
                            }
                            
                            for(Dom.XmlNode node3 : node2.getChildElements()){
                                System.debug(node2.getName());
                                if(node3.getName() == 'BPCustomerNumber'){
                                    SAPId = node3.getText();
                                    System.debug(SAPId);
                                    
                                }
                                else if(node3.getName() == 'Customer'){
                                    CustomerId = node3.getText();
                                    System.debug(CustomerId);
                                    
                                }else {
                                    
                                    for(Dom.XmlNode node4 : node3.getChildElements()){
                                        System.debug(node4.getText());
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    System.debug(CustomerId);
                    System.debug(SAPId);
                    System.debug(leads.Id);
                    System.debug(SAPAddressId);
                    System.debug(CustomerAddressId);
                    
                    //errorResponseNull(leads.Id);
                    if(CustomerId !=null && SAPId !=null){
                        convertLead(leads.Id);
                        updateRecords(SAPAddressId, CustomerAddressId, CustomerId, SapId, leads.Id);
                        System.EnqueueJob(new SecondLeadQueue(CustomerId));
                        
                    }
                    else {
                        RevertStatus(leads.Id, null);
                    }
                    
                    
                } else {              // if status code not 201
                    
                    List<String> errorMessage = new List<String>();
                    if (res.getBody() != null){
                        
                        Dom.Document doc1 = new Dom.Document();
                        
                        
                        doc1.load(res.getBody());
                        
                        Dom.XmlNode rootNode = doc1.getRootElement();
                        
                        for (Dom.XmlNode childNode : rootNode.getChildElements()) {
                            if (childNode.getName() == 'message') {
                                errorMessage.add(childNode.getText());
                                //system.debug('Error Message: '+ errorMessage);
                                
                            } 
                            else if(childNode.getName() == 'innererror'){
                                
                                //System.debug('innererror');
                                for(Dom.XmlNode errorDetailsNode : childNode.getChildElements()){
                                    if(errorDetailsNode.getName() == 'errordetails'){
                                    	
                                        //System.debug('errordetails');
                                        for(Dom.XmlNode errordetailNode : errorDetailsNode.getChildElements()){
                                            if(errordetailNode.getName() == 'errordetail'){
                                                
                                                //System.debug('errordetail');
                                                for(Dom.XmlNode messageNode : errordetailNode.getChildElements()){
                                                    if(messageNode.getName() == 'message'){
                                                        errorMessage.add(messageNode.getText());
                                                        //System.debug('Error Message: '+errorMessage);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        /*for (Dom.XmlNode childNode : rootNode.getChildElements()) {

if (childNode.getName() == 'message') {
errorMessage1 = childNode.getText();
//  errorMessage.add(childNode.getText());
system.debug('Error Message1: '+ errorMessage1);

} else if(childNode.getName() == 'innererror'){
Dom.XmlNode errorDetailsNode = childNode.getChildElements();
if (errorDetailsNode.getName() == 'errordetail' ) {
System.debug('errorDetailsNode is not null');
Dom.XmlNode errorDetailNode = errorDetailsNode.getChildElements();
if (errorDetailNode.getName() == 'message') {
System.debug('errorDetailNode is not null');
errorMessage2 = errorDetailNode.getText();
System.debug('Error Message2: '+ errorMessage2);
}
} 
}

}*/
                        
                        //errorMessage = errorMessage1 + ';' + errorMessage2;
                        System.debug(String.join(ErrorMessage, '; '));
                        RevertStatus(leads.Id, errorMessage);
                        
                    } else {
                        System.debug('Response is null');
                        errorMessage = null;
                        RevertStatus(leads.Id, errorMessage);
                    }
                    
                    
                    
                    
                }
                
            } catch (Exception e) {
                throw e;
                
            }
        }
        
        
        
    }
    public static void updateRecords(String SapAddressId, String CustomerAddressId, String CustomerId, String SapId, Id recordId){
        //list<Opportunity> newOpp = new List<opportunity>();
        Lead LeadList = [SELECT Id, Name, Company, ConvertedAccountId, ConvertedContactId FROM Lead WHERE IsConverted = TRUE AND Id =: recordId];
        
        Account acc = [SELECT Id, Name FROM Account WHERE Id =: LeadList.ConvertedAccountId];
        acc.SAP_Code__c = CustomerId;
        acc.BPAddressId__c = CustomerAddressId;
        update acc;
        
        Contact con = [SELECT Id, Name FROM Contact WHERE Id =: LeadList.ConvertedContactId];
        con.SAPId__c = SapId;
        con.CPAddressId__c = SapAddressId;
        update con;
        
        System.debug('Going to sleep');
        System.debug('Waking up now');
        System.debug(acc.Id);
        //navigateToAccountPage(acc.Id);
        
        
    }
    
    public static String RevertStatus(Id recordId, List<String> ErrorMessage){
        
        //List<Lead> leadsToUpdate = new List<Lead>();
        
        Lead LeadList = [SELECT Id, Name FROM Lead WHERE Id =: recordId];
        
        
        LeadList.Status = 'Check Customer Details';
        if(ErrorMessage != null){
            LeadList.Error_Response__c = String.join(ErrorMessage, '; '); 
            //leadsToUpdate.add(leads);
        } else {
            LeadList.Error_Response__c = 'no response from error or record is created in SAP but error during transaction';
        }      
        
        
        
        update LeadList;
        //ApexPages.addMessage(ApexPages.message(ApexPages.Severity.ERROR, 'Failed!'));
        return null;
    }
    
    public static void convertLead(Id recordId){
        List<Lead> LeadList = [SELECT Id, Name, OwnerId FROM Lead WHERE Id =: recordId];
        
        for(Lead lead : LeadList){
            lead.Error_Response__c = null;
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(lead.Id);
            lc.convertedstatus = 'Closed – Converted';
            lc.ownerid = lead.OwnerId;
            lc.donotcreateopportunity = true;
            
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
        }
    }
    
}