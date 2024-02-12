public class AccountUpdateClass {
    public static Boolean hasRun = false;
    public static Integer Flag = 0;
    
    public static void ATHClass(List<Account> AccList, Map<Id, Account> AccMap){

        List<Account> AccListToBeUpdated = new List<Account>();
        
        for(Account acc : AccList){
            if(!hasRun && (acc.Sales_Organization__c != AccMap.get(acc.Id).Sales_Organization__c || acc.Division__c != AccMap.get(acc.Id).Division__c || acc.Distribution_Channel__c != AccMap.get(acc.Id).Distribution_Channel__c || acc.Sales_Office__c != AccMap.get(acc.Id).Sales_Office__c)){
                Flag = 1;
                System.debug('Flag is set to 1');
                AccListToBeUpdated.add(acc);
                getDescription(AccListToBeUpdated, Flag);
            } else if(!hasRun){ 
                System.debug('Flag is set to 0');
                AccListToBeUpdated.add(acc);
                getDescription(AccListToBeUpdated, Flag);
            }
            
        }
                
    } 
    
    
    public static void getDescription(List<Account> Accountss, Integer flag){
  //      System.EnqueueJob(new AccountTriggerHandlerUpdate(Accountss, flag));
    }
}
/*@future(callout = true)
public static void AccountUpdateCallout(Id AccountId, String SAPCode, Integer Flag){

String errorMessage;
String FlagValue = String.ValueOf(Flag);
Http http = new Http();
HttpRequest req = new HttpRequest();
req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/update/Bp');
req.setMethod('POST');

String username = 'harshal.thakare@sapours.net.in';        
String password = '@Shyam004';            
Blob headerValue = Blob.valueOf(username + ':' + password);        
String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);

req.setHeader('authorization', authorizationHeader);
//req.setHeader('Content-Type', 'application/xml');
//req.setHeader('Accept','application/xml');

Dom.Document doc = new Dom.Document();
Dom.XmlNode root = doc.createRootElement('Account', null, null);

//Flag Node
Dom.XmlNode FlagRoot = root.addChildElement('Flag',null,null);
FlagRoot.addChildElement('flag',null, null).addTextnode(FlagValue);

//SAPCode Node
Dom.XmlNode SAPCodeRoot = root.addChildElement('SAPCode',null,null);
SAPCodeRoot.addChildElement('SAPcode',null, null).addTextnode(SAPCode);

//Account Id Node
Dom.XmlNode IDroot = root.addChildElement('ID', null, null);
IDroot.addChildElement('Id', null, null).addTextnode(AccountId);


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
UpdateError(errorMessage, AccountId);
//System.debug(errorMessage);


} else {
errorMessage = 'No Body Found';
System.debug(errorMessage);
UpdateError(errorMessage, AccountId);

}
}


}
catch (Exception e) {
throw e;
}

}

public static void UpdateError(String errorMessage, Id AccountId){

Account acc = [SELECT Id, Name, Error_message__c FROM Account WHERE Id =: AccountId];

acc.Error_message__c = errorMessage;
update acc;
}
*/