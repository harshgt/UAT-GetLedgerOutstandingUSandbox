public class AccountTriggerHandlerUpdate implements Queueable, Database.AllowsCallouts {
    private List<Account> NewAccList;
    private Integer flag;
    
    
    public AccountTriggerHandlerUpdate(List<Account> NewAccList, Integer flag) {
        this.NewAccList = NewAccList;
        this.flag = flag;
        
    }
    
    public void execute(QueueableContext context) {
        
        System.debug('execute method is processing');
        String errorMessage;
        String FlagValue = String.ValueOf(flag);
        for(Account acc : NewAccList){
            
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/update/Bp');
            req.setMethod('POST');
            
            String username = 'harshal.thakare@sapours.net.in';        
            String password = '@Shyam004';            
            Blob headerValue = Blob.valueOf(username + ':' + password);        
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('authorization', authorizationHeader);
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('Account', null, null);
            
            // Flag Node
            Dom.XmlNode FlagRoot = root.addChildElement('Flag', null, null);
            FlagRoot.addChildElement('flag', null, null).addTextNode(FlagValue);
            
            // SAPCode Node
            Dom.XmlNode SAPCodeRoot = root.addChildElement('SAPCode', null, null);
            SAPCodeRoot.addChildElement('SAPcode', null, null).addTextNode(acc.SAP_Code__c);
            
            // Account Id Node
            Dom.XmlNode IDroot = root.addChildElement('ID', null, null);
            IDroot.addChildElement('Id', null, null).addTextNode(acc.Id);
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            req.setBody(XmlBody);
            System.debug(XmlBody);
            
            try {
                HttpResponse res = http.send(req);
                System.debug(res.getBody());
                System.debug(res.getStatus());
                System.debug(res.getStatusCode());
                
                if (res.getStatusCode() != 202) {
                    if (res.getBody() != null) {
                        Dom.Document doc1 = new Dom.Document();
                        doc1.load(res.getBody());
                        Dom.XmlNode rootNode = doc1.getRootElement();
                        for (Dom.XmlNode childNode : rootNode.getChildElements()) {
                            if (childNode.getName() == 'message') {
                                errorMessage = childNode.getText();
                                System.debug('Error Message: ' + errorMessage);
                            }
                        }
                        
                       // UpdateError(errorMessage, acc.Id);
                        AccountUpdateClass.hasRun = true;
                    } else {
                        errorMessage = '';
                        System.debug(errorMessage);
                        
                       // UpdateError(errorMessage, acc.Id);
                        AccountUpdateClass.hasRun = true;
                    }
                } else {
                    errorMessage = 'Success';
                    System.debug(errorMessage);
                    
                    //UpdateError(errorMessage, acc.Id);
                    AccountUpdateClass.hasRun = true;
                }
            } catch (Exception e) {
                throw e;
            }
        }
        
    }
    
    /*public static void UpdateError(String errorMessage, Id accountId) {
        Account acc = [SELECT Id, Name, Error_message__c FROM Account WHERE Id = :accountId];
        acc.Error_message__c = errorMessage;
        update acc;
        
    }*/
    
}