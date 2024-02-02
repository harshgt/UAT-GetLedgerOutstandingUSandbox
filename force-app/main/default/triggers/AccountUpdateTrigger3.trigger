trigger AccountUpdateTrigger3 on Account (before update) {
    Boolean SalesAreaChanged;
    Boolean TANPANChanged;
    Boolean Otherfieldschanged;
    Integer Flag;
    
    for(Account AccList : Trigger.new){
        if(Trigger.oldMap.get(AccList.Id).SAP_Code__c != null){
            System.debug(AccList.SAP_Code__c);
            Account oldRecord = Trigger.oldMap.get(AccList.Id);
            System.debug(Trigger.oldMap.get(AccList.Id).SAP_Code__c);
            SalesAreaChanged = (AccList.Sales_Organization__c != Trigger.oldMap.get(AccList.Id).Sales_Organization__c || AccList.Division__c != Trigger.oldMap.get(AccList.Id).Division__c || AccList.Distribution_Channel__c != Trigger.oldMap.get(AccList.Id).Distribution_Channel__c);
            TANPANChanged = (AccList.Bill_To_PAN_Number__c != Trigger.oldMap.get(AccList.Id).Bill_To_PAN_Number__c || AccList.TAN_No__c != Trigger.oldMap.get(AccList.Id).TAN_No__c || AccList.Customer_Statistic_Group__c != Trigger.oldMap.get(AccList.Id).Customer_Statistic_Group__c || Acclist.Pricing__c != Trigger.oldMap.get(AccList.Id).Pricing__c); 
            Otherfieldschanged = (AccList.Bill_To_City__c != Trigger.oldMap.get(AccList.Id).Bill_To_City__c ||
                                          AccList.Bill_To_Country__c     != Trigger.oldMap.get(AccList.Id).Bill_To_Country__c    ||
                                          AccList.Bill_To_Email__c != Trigger.oldMap.get(AccList.Id).Bill_To_Email__c ||
                                          AccList.Bill_To_GST_No__c != Trigger.oldMap.get(AccList.Id).Bill_To_GST_No__c ||
                                          AccList.Bill_To_Mobile__c != Trigger.oldMap.get(AccList.Id).Bill_To_Mobile__c ||
                                          AccList.Bill_To_Name__c != Trigger.oldMap.get(AccList.Id).Bill_To_Name__c ||
                                          AccList.Bill_To_Name2__c != Trigger.oldMap.get(AccList.Id).Bill_To_Name2__c ||
                                          AccList.Bill_To_Phone__c != Trigger.oldMap.get(AccList.Id).Bill_To_Phone__c ||
                                          AccList.Bill_To_State__c != Trigger.oldMap.get(AccList.Id).Bill_To_State__c ||
                                          AccList.Bill_To_State_Code_as_Per_GST__c != Trigger.oldMap.get(AccList.Id).Bill_To_State_Code_as_Per_GST__c ||
                                          AccList.Bill_To_Street__c != Trigger.oldMap.get(AccList.Id).Bill_To_Street__c ||
                                          AccList.Bill_To_Street2__c != Trigger.oldMap.get(AccList.Id).Bill_To_Street2__c ||
                                          AccList.Bill_To_Street3__c != Trigger.oldMap.get(AccList.Id).Bill_To_Street3__c ||
                                          AccList.Bill_To_Zip_Postal_Code__c != Trigger.oldMap.get(AccList.Id).Bill_To_Zip_Postal_Code__c ||
                                          AccList.BillingAddress != Trigger.oldMap.get(AccList.Id).BillingAddress ||
                                          AccList.Search_Term__c != Trigger.oldMap.get(AccList.Id).Search_Term__c ||
                                          AccList.Incoterms__c != Trigger.oldMap.get(AccList.Id).Incoterms__c ||
                                          AccList.Payment_Term__c != Trigger.oldMap.get(AccList.Id).Payment_Term__c);
            
            if(SalesAreaChanged){
                
                Flag = 1;
                System.debug(SalesAreaChanged);
                System.debug('Sales area is changed');
                
                System.enqueueJob(new AccountUpdateClass2(AccList.Id, AccList.SAP_Code__c, Flag));
                
            } 
            if(TANPANChanged){
                
                Flag = 0;
                System.debug(TANPANChanged);
                System.debug('TAN PAN is changed');
                System.debug(AccList.SAP_Code__c);
                
                System.enqueueJob(new AccountUpdateClass3(AccList.SAP_Code__c));
                
                
            }
            if(Otherfieldschanged) {
                
                Flag = 0;
                System.debug(Flag);
                System.debug(!SalesAreaChanged && TANPANChanged && Otherfieldschanged);
                System.debug('other fields are changed');
                
                System.enqueueJob(new AccountUpdateClass2(AccList.Id, AccList.SAP_Code__c, Flag));
                
            }
        }
    }

}