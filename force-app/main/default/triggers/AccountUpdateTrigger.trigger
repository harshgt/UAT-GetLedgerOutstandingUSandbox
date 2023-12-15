trigger AccountUpdateTrigger on Account (after update) {
    
    Id IdAccount;
    Boolean FlagMain;
    Boolean flag1 = false;
    Boolean flag2 = false;
    Boolean flag3 = false;
    
    
    for(Account acc : Trigger.new){
        IdAccount = acc.Id;
    }
    System.debug(IdAccount);
    List<AccountHistory> AccHistDivList = [SELECT Field, NewValue, OldValue FROM AccountHistory WHERE Field = 'Division__c' AND AccountId =: IdAccount];
    List<AccountHistory> AccHistSalesList = [SELECT Field, NewValue, OldValue FROM AccountHistory WHERE Field = 'Sales_Organization__c' AND AccountId =: IdAccount];
    List<AccountHistory> AccHistDistList = [SELECT Field, NewValue, OldValue FROM AccountHistory WHERE Field = 'Distribution_Channel__c' AND AccountId =: IdAccount];
    
    
    System.debug(AccHistDivList);
    System.debug(AccHistSalesList);
    System.debug(AccHistDistList);
    
    
    List<Object> NewValueDivList = new list<Object>();
    List<Object> OldValueDivList = new list<Object>();
    
    List<Object> NewValueSalesList = new list<Object>();
    List<Object> OldValueSalesList = new list<Object>();
    
    List<Object> NewValueDistList = new list<Object>();
    List<Object> OldValueDistList = new list<Object>();
    
    if(!AccHistDivList.isEmpty()){
        System.debug('AccHistDivList is not null');
        for(AccountHistory AccHistDivList2 : AccHistDivList){
            NewValueDivList.add(AccHistDivList2.NewValue);
            OldValueDivList.add(AccHistDivList2.OldValue);
            
            System.debug(NewValueDivList);
            System.debug(OldValueDivList);
            
            for(Object oldValue : OldValueDivList){
                if (NewValueDivList.contains(oldValue)) {
                    flag1 = true;
                    break;
                }
            }
        }}
    
    if(!AccHistSalesList.isEmpty()){
        System.debug('AccHistSalesList is not null');
        for(AccountHistory AccHistSalesList2 : AccHistSalesList){
            NewValueSalesList.add(AccHistSalesList2.NewValue);
            OldValueSalesList.add(AccHistSalesList2.OldValue);
            
            
            
            System.debug(NewValueSalesList);
            System.debug(OldValueSalesList);
            
            for(Object oldValue : OldValueSalesList){
                if (NewValueSalesList.contains(oldValue)) {
                    flag2 = true;
                    break;
                }
            }
        }}
    
    if(!AccHistDistList.isEmpty()){
        System.debug('AccHistDistList is not null');
        for(AccountHistory AccHistDistList2 : AccHistDistList){
            NewValueDistList.add(AccHistDistList2.NewValue);
            OldValueDistList.add(AccHistDistList2.OldValue);
            
            System.debug(NewValueDistList);
            System.debug(OldValueDistList);
            
            for(Object oldValue : OldValueDistList){
                if (NewValueDistList.contains(oldValue)) {
                    flag3 = true;
                    break;
                }
            }
        }}
    
    
    System.debug(flag1);
    System.debug(flag2);
    System.debug(flag3);
    
    
}