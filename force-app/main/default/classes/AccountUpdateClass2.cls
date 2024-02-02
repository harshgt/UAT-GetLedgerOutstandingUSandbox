public class AccountUpdateClass2 implements Queueable, Database.AllowsCallouts {
    Id AccountId;
    String SAPCode;
    String Flag;
    
    public AccountUpdateClass2(Id AccountId, String SAPCode, Integer Flag){
        this.AccountId = AccountId;
        this.SAPCode = SAPCode;
        this.Flag = String.ValueOf(Flag);
    }
    
    public void execute(QueueableContext qc) {
        try {
            
            Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;

			String BPUpdateURL1 = customSetting.BPUpdateURL1__c; 
            
            String errorMessage;
            String FlagValue = String.ValueOf(Flag);
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(BPUpdateURL1);
            req.setMethod('POST');
            
            Blob headerValue = Blob.valueOf(Username + ':' + Password);        
            String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('authorization', authorizationHeader);
            
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('Account', null, null);
            
            //Flag Node
            Dom.XmlNode FlagRoot = root.addChildElement('Flag',null,null);
            FlagRoot.addChildElement('flag',null, null).addTextnode(this.Flag);
            
            //SAPCode Node
            Dom.XmlNode SAPCodeRoot = root.addChildElement('SAPCode',null,null);
            SAPCodeRoot.addChildElement('SAPcode',null, null).addTextnode(this.SAPCode);
            
            //Account Id Node
            Dom.XmlNode IDroot = root.addChildElement('ID', null, null);
            IDroot.addChildElement('Id', null, null).addTextnode(this.AccountId);
            
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            req.setBody(XmlBody);
            System.debug(XmlBody);
            
            
            
            HttpResponse res = http.send(req);
            System.debug(res.getBody());
            System.debug(res.getStatus());
            System.debug(res.getStatusCode());
            
            /*if(res.getStatusCode() != 202){
                if (res.getBody() != null){
                    Dom.Document doc1 = new Dom.Document();
                    
                    doc1.load(res.getBody());
                    Dom.XmlNode rootNode = doc1.getRootElement();
                    for (Dom.XmlNode childNode : rootNode.getChildElements()) {
                        if (childNode.getName() == 'message') {
                            errorMessage = childNode.getText();
                            system.debug('Error Message: '+ errorMessage);
                            
                        }
                    }
                    
                } 
            } */
            
            
        }
        catch (Exception e) {
            throw e;
        }
        
    }
}