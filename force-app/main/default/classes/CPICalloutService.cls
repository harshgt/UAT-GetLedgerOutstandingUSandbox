public class CPICalloutService 

{
    @future(callout=true)
    public static void sendToCPI(List<Id> contactIds) {
      
        String errormessage;
        list<contact> conlist = new list<contact>();
        for(contact con:[select Id, SAPId__c from Contact where Id =: contactIds ]){
           
			Http http = new Http();            
            // Make the HTTP callout to the CPI endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/update/Cp'); // Replace 'CPI_Endpoint' with your Named Credential's endpoint URL
            req.setMethod('POST');
            
            String username = 'harshal.thakare@sapours.net.in';        
            String password = '@Shyam004';            
            Blob headerValue = Blob.valueOf(username + ':' + password);        
            String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('authorization', authorizationHeader);
            //req.setHeader('Content-Type', 'application/xml');
            //req.setHeader('Accept','application/xml');
            
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('Contact', null, null);
            
            
            //SAPCode Node
            Dom.XmlNode SAPCodeRoot = root.addChildElement('SAPCode',null,null);
            SAPCodeRoot.addChildElement('SAPcode',null, null).addTextnode(con.SAPId__c);
            
            //Account Id Node
           // Dom.XmlNode IDroot = root.addChildElement('ID', null, null);
           // IDroot.addChildElement('Id', null, null).addTextnode(Con.Id);
            
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            req.setBody(XmlBody);
            System.debug(XmlBody);
            
        
          try {
            
            HttpResponse res = http.send(req);
            System.debug(res.getBody());
            System.debug(res.getStatus());
            System.debug(res.getStatusCode());
            
            if(res.getStatusCode() != 202){
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
                    
                } else {
                    errorMessage = 'No Body Found';
                    System.debug(errorMessage);
                    
                    
                }
            } else {
                errorMessage = 'Successful transaction';
            }
            
            
        }
        catch (Exception e) {
            throw e;
        }
        
    }
}
}