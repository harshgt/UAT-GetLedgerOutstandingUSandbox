trigger AccountUpdateTrigger2 on Account (before update) {

	List<Account> AllAccountList = new List<Account>(Trigger.new);
    Map<Id, Account> AllAccountOldMap = new Map<Id, Account>(Trigger.oldMap);
    

    
    for(Account acc: Trigger.new){
        
        System.debug(acc.SAP_Code__c);
        System.debug(Trigger.oldMap.get(acc.Id).SAP_Code__c);
        if(Trigger.oldMap.get(acc.Id).SAP_Code__c != null){
            
            /*if(acc.Sales_Organization__c != Trigger.oldMap.get(acc.Id).Sales_Organization__c || acc.Division__c != Trigger.oldMap.get(acc.Id).Division__c || acc.Distribution_Channel__c != Trigger.oldMap.get(acc.Id).Distribution_Channel__c || acc.Sales_Office__c != Trigger.oldMap.get(acc.Id).Sales_Office__c){

            AccountUpdateClass.ATHClass(AllAccountList, 1);
            
            } else {
               
            AccountUpdateClass.ATHClass(AllAccountList, 0);    
            
            }

*/
            //AccountUpdateClass.ATHClass(AllAccountList, AllAccountOldMap);
            
        }
    }
}
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            /*if(acc.Sales_Organization__c != Trigger.oldMap.get(acc.Id).Sales_Organization__c || acc.Division__c != Trigger.oldMap.get(acc.Id).Division__c || acc.Distribution_Channel__c != Trigger.oldMap.get(acc.Id).Distribution_Channel__c || acc.Sales_Office__c != Trigger.oldMap.get(acc.Id).Sales_Office__c){
                
                Flag = 1;
                System.debug(acc.Name);
                System.debug(Flag);
                System.enqueueJob(new AccountTriggerHandlerUpdate(acc.Id, acc.SAP_Code__c, Flag, hasRun));
                
                
            } else {
                
                System.debug(acc.Name);
                System.debug(Flag);
                System.enqueueJob(new AccountTriggerHandlerUpdate(acc.Id, acc.SAP_Code__c, Flag, hasRun));
                
            }*/

    
    /*static Boolean hasRun = false;

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {

            if (!hasRun) {
                hasRun = true;
                AccountTriggerHandlerUpdate.setDescription(Trigger.new, Trigger.oldMap);
            }
        }
    }*/