public class SecondLeadQueue implements Queueable, Database.AllowsCallouts{
    
    String CustomerId;
    
    public SecondLeadQueue(String CustomerId){
        this.CustomerId = CustomerId;
    }
    
    public void execute(QueueableContext qc){
        
        	Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;

			String BPUpdateURL2 = customSetting.BPUpdateURL2__c ;
            
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BPUpdateURL2);
        req.setMethod('POST');
        
              
        Blob headerValue = Blob.valueOf(Username + ':' + Password);        
        String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
        
        req.setHeader('authorization', authorizationHeader);
        //req.setHeader('Content-Type', 'application/xml');
        //req.setHeader('Accept','application/xml');
        
        Dom.Document doc = new Dom.Document();
        
        Dom.XmlNode root = doc.createRootElement('Account', null, null);
        
        // Create A_BusinessPartnerType element
        Dom.XmlNode IDroot = root.addChildElement('SAPCode', null, null);
        IDroot.addChildElement('SAPcode', null, null).addTextnode(this.CustomerId);
        
        
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
        } catch (Exception e) {
                throw e;
                
            }
        
    }

}