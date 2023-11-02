public with sharing class customerOutStandingData {
    @AuraEnabled
    public static map<String,Object> customerOutStandingData(String AccountSapId, String CompanyCode, String SelectedValueForType) {
        Map<String, Object> mapJsonData = new Map<String, Object>();
        String strResponse=null;
        System.debug('AccountSapId ==> ' +AccountSapId);
        System.debug('CompanyCode ==> ' +CompanyCode);
        System.debug('SelectedValueForType ==> ' +SelectedValueForType);
        
        strResponse = getCustomerOutstandingSAP(AccountSapId, CompanyCode, SelectedValueForType);
        System.debug('strResponse => '+strResponse);
          if(String.isNotBlank(strResponse))
        {
            //System.debug('strResponse => '+strResponse);
            mapJsonData = (map<String,Object>)JSON.deserializeUntyped(strResponse);
            System.debug('mapJsonData => '+mapJsonData);
            return mapJsonData;
        } 
        
        
        
        return null;
        
        
    }
    
    public static String getCustomerOutstandingSAP(String AccountSapId, String CompanyCode, String SelectedValueForType){
        
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMEROUTSTANDING');
            req.setMethod('GET');
            String username = 'harshal.thakare@sapours.net.in';
            String password = '@Shyam004';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('authorization', authorizationHeader);
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('CustomerLedger', null, null);
            // Create A_BusinessPartnerType element
            Dom.XmlNode IDroot = root.addChildElement('Company_Code__c', null, null).addTextnode(CompanyCode);
            Dom.XmlNode IDroot1 = root.addChildElement('Customer', null, null).addTextnode(AccountSapId);
            
            if(SelectedValueForType == 'Overdue'){ 
                Dom.XmlNode IDroot2 = root.addChildElement('Notdue', null, null).addTextnode('');
                Dom.XmlNode IDroot3 = root.addChildElement('Overdue', null, null).addTextnode('X');
            }
            else if(SelectedValueForType == 'No Due') {
                Dom.XmlNode IDroot2 = root.addChildElement('Notdue', null, null).addTextnode('X');
                Dom.XmlNode IDroot3 = root.addChildElement('Overdue', null, null).addTextnode('');
            }
            else{
                Dom.XmlNode IDroot2 = root.addChildElement('Notdue', null, null).addTextnode('');
                Dom.XmlNode IDroot3 = root.addChildElement('Overdue', null, null).addTextnode('');
            }
            
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            //Adding Body to request
            req.setBody(XmlBody);
            
            HttpResponse res = http.send(req);
            //System.debug('Response Body '+res);
            //System.debug('Response Body '+res.getBody());
            //System.debug('Response Code '+res.getStatusCode());
            if(res.getStatusCode() == 200){
                //System.debug('Response Code '+res.getStatusCode());
                //System.debug('Response Body '+res.getBody()); //res.getBody()
                return res.getBody();
            }
                
           
                
            return res.getBody();
           
            
            
            
        } catch (Exception e) {
            system.debug(e.getMessage());
            return e.getMessage();
        }
        
        
    }
    
}