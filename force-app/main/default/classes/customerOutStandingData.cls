public with sharing class customerOutStandingData {
    @AuraEnabled
    public static map<String,Object> customerOutStandingData(String AccountSapId, String CompanyCode, String SelectedValueForType) {
        Map<String, Object> mapJsonData = new Map<String, Object>();
        String strResponse=null;
        /* System.debug('AccountSapId ==> ' +AccountSapId);
        System.debug('CompanyCode ==> ' +CompanyCode);
        System.debug('SelectedValueForType ==> ' +SelectedValueForType); */
        
        strResponse = getCustomerOutstandingSAP(AccountSapId, CompanyCode, SelectedValueForType);
        //System.debug('strResponse => '+strResponse);
        if(String.isNotBlank(strResponse))
        {
            mapJsonData = (map<String,Object>)JSON.deserializeUntyped(strResponse);
            return mapJsonData;
        } 
        return null;    
    }
    
    public static String getCustomerOutstandingSAP(String AccountSapId, String CompanyCode, String SelectedValueForType){  
        try {
            
            Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;
            String CustomerOutstandingURL = customSetting.CustomerOutstandingURL__c;
            
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CustomerOutstandingURL);
            req.setMethod('GET');
            
            Blob headerValue = Blob.valueOf(Username + ':' + Password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('authorization', authorizationHeader);
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('CustomerLedger', null, null);
            
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
            //System.debug(XmlBody);
            
            //Adding Body to request
            req.setBody(XmlBody);
            
            HttpResponse res = http.send(req);
            //System.debug('Response Body '+res);
            //System.debug('Response Body '+res.getBody());
            //System.debug('Response Code '+res.getStatusCode());
            if(res.getStatusCode() == 200){
                
                return res.getBody();
            }
            
            return res.getBody();
            
        } catch (Exception e) {
            system.debug(e.getMessage());
            return e.getMessage();
        }       
    } 
    
    

}