public with sharing class customerLedgerData {
    @AuraEnabled
    public static map<String,Object> customerLedgerData(Date startDate, Date endDate, String AccountSapId, String CompanyCode) {
        Map<String, Object> mapJsonData = new Map<String, Object>();
        String strResponse=null;
        //System.debug('startDate ==> ' +startDate);
        //System.debug('endDate ==> ' +endDate);
        
        //convert date to string 
        String formattedStartDate = String.valueOf(startDate.year()) + '-' + (startDate.month() < 10 ? '0' : '') + String.valueOf(startDate.month()) + '-' + String.valueOf(startDate.day());
        String formattedEndDate = String.valueOf(endDate.year()) + '-' + (endDate.month() < 10 ? '0' : '') + String.valueOf(endDate.month()) + '-' + String.valueOf(endDate.day());
        /* System.debug('StartDate => ' +formattedStartDate);
        System.debug('EndDate => ' +formattedEndDate);
        System.debug('AccountSapId ==> ' +AccountSapId);
        System.debug('CompanyCode ==> ' +CompanyCode); */   
        strResponse = getCustomerLedgerSAP(formattedStartDate, formattedEndDate, AccountSapId, CompanyCode);
        //System.debug('strResponse => '+strResponse);
        if(String.isNotBlank(strResponse))
        {
            mapJsonData = (map<String,Object>)JSON.deserializeUntyped(strResponse);
            return mapJsonData;
        }
        return null;     
    }
    
    public static String getCustomerLedgerSAP(String formattedStartDate, String formattedEndDate, String AccountSapId, String CompanyCode){        
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            Authorization__c customSetting  = Authorization__c.getInstance();
             //Authorization__c customSetting = Authorization__c.getOrgDefaults();
            
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;
            String CustomerLedgerURL = customSetting.CustomerLedgerURL__c;
            String Endpoints =CustomerLedgerURL;
            req.setEndpoint(Endpoints);
            req.setMethod('GET');
            
            
            //String Username = 'harshal.thakare@sapours.net.in';
            //String Password = '@Shyam004';
            Blob headerValue = Blob.valueOf(Username + ':' + Password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('authorization', authorizationHeader);
            
            Dom.Document doc = new Dom.Document();
            Dom.XmlNode root = doc.createRootElement('CustomerLedger', null, null);
            
            Dom.XmlNode IDroot = root.addChildElement('Company_Code__c', null, null).addTextnode(CompanyCode);
            Dom.XmlNode IDroot1 = root.addChildElement('Customer', null, null).addTextnode(AccountSapId);
            Dom.XmlNode IDroot2 = root.addChildElement('FromDate', null, null).addTextnode(formattedStartDate);
            Dom.XmlNode IDroot3 = root.addChildElement('ToDate', null, null).addTextnode(formattedEndDate);
            
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
            //system.debug(e.getMessage());
            return e.getMessage();
        }    
    }   
}