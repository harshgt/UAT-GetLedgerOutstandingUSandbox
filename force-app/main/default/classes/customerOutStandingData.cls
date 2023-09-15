public with sharing class customerOutStandingData {
    @AuraEnabled
    public static map<String,Object> customerOutStandingData(String endPointUrl) {
        Map<String, Object> mapJsonData = new Map<String, Object>();
        System.debug('endPointUrl ==> ' +endPointUrl);
        String strResponse=null;
        if (String.isNotBlank(endPointUrl)) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPointUrl);
            req.setMethod('POST'); // Change the method to POST for sending data
        
            String username = 'harshal.thakare@sapours.net.in';
            String password = '@Shyam004';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            System.debug(authorizationHeader);
            
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');

            req.setHeader('Accept', 'application/json');
            req.setHeader('User-Agent', 'MySalesforceIntegration');
            req.setHeader('X-CSRF-Token', 'uVkdu9B6J4TRY2VhrDDTxQ==');
            //req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
            //req.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());
            
            // Construct the JSON payload
            String requestBody = '{"FirstName": "AkhilTest2121","MiddleName": "P22121","LastName": "Gaikwad221212","OrganizationBPName1": "AkhilTestmailmobile21212","BusinessPartnerCategory": "2"}';
            req.setBody(requestBody);

            // Adding cookies
            String cookieValue = UserInfo.getSessionId();
            req.setHeader('Cookie', cookieValue);

            
            try {
                Http hp = new Http();
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
        }
 
        return mapJsonData;
    }
    
}