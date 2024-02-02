public class AccountUpdateClass3 implements Queueable, Database.AllowsCallouts {
    String SAPCode;
    
    public AccountUpdateClass3(String SAPCode) {
        this.SAPCode = SAPCode;
        
    }
    
    public void execute(QueueableContext qc) {
        String errorMessage;
        
        try {
            
            Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.username__c;
            String Password = customSetting.Password__c;

			String BPUpdateURL2 = customSetting.BPUpdateURL2__c ; 
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(BPUpdateURL2);
            req.setMethod('POST');
            
                      
            Blob headerValue = Blob.valueOf(Username + ':' + Password);        
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('authorization', authorizationHeader);
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('Account', null, null);
            
            // SAPCode Node
            Dom.XmlNode SAPCodeRoot = root.addChildElement('SAPCode', null, null);
            SAPCodeRoot.addChildElement('SAPcode', null, null).addTextNode(this.SAPCode);
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            req.setBody(XmlBody);
            System.debug(XmlBody);
            
            
            HttpResponse res = http.send(req);
            System.debug(res.getBody());
            System.debug(res.getStatus());
            System.debug(res.getStatusCode());
            
            /*if (res.getStatusCode() != 202) {
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
                    
                } else {
                    errorMessage = '';
                    System.debug(errorMessage);
                    
                }
            } else {
                errorMessage = 'Success';
                System.debug(errorMessage);
                
                
            }*/
        } catch (Exception e) {
            throw e;
        }        
    }    
}