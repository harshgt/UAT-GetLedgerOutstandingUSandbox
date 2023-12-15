public class CPIIntegration {
    public static void integrateOpportunityWithCPI() {
       // Opportunity opp = [SELECT Id, Name, Amount, CloseDate FROM Opportunity WHERE Id = :opportunityId];
        
        // Construct the HTTP request
      String strResponse = NULL;
        
         HttpRequest req = new HttpRequest();
            req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/TEST/ODATA');
            req.setMethod('POST'); // Change the method to POST for sending data
        
        
        
            String username = 'harshal.thakare@sapours.net.in';
            String password = '@Shyam004';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            System.debug(authorizationHeader);
            
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
       
            String requestBody = '{"FirstName": "Harshal","MiddleName": "Ggt","LastName": "Thakare","OrganizationBPName1": "HarshalGt10","BusinessPartnerCategory": "2"}';
            req.setBody(requestBody);
            try {
                Http hp = new Http();
                //req.setTimeout(60000);
                HttpResponse res = hp.send(req);
                System.debug('run1'+res);
                    
                if (res.getStatusCode() == 201) {
                    System.debug('getStatusCode => ' + res.getStatusCode());
                    System.debug('res.getBody => ' + res.getBody());	
                    strResponse = res.getBody();
                } else {
                    throw new CalloutException(res.getBody());
                }
            } catch (Exception e) {
                throw e;
            }
        
        
     

Dom.Document xmlDoc = new Dom.Document();
xmlDoc.load(strResponse);

// Navigate through the XML structure to access data
Dom.XMLNode rootNode = xmlDoc.getRootElement();

String BusinessPartner= '';

// Assuming businessPartnerId is a child element of the root node
for (Dom.XMLNode childNode : rootNode.getChildElements()) {
    if (childNode.getName() == 'BusinessPartner') {
        BusinessPartner = childNode.getText();
        break; // Exit the loop once the ID is found
    }
}

// Print the ID to the debug logs
System.debug('Business Partner ID: ' + BusinessPartner);

          
    }
    

}