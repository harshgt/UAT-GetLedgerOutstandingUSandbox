trigger ContactTrigger on Contact (after update, after insert) {
    
    if(Trigger.isUpdate){
        List<Id> contactIds = new List<Id>();    
        String ConSAPId;
        for (Contact newContact : trigger.new) {
            contactIds.add(newContact.Id);
            ConSapId = Trigger.oldMap.get(newContact.Id).SAPId__c;
        }
        if(ConSAPId != null){
            // Call the CPI endpoint with the list of Contact Ids
            CPICalloutService.sendToCPI(contactIds);
        }
    }
    
    
    if(Trigger.isInsert)
    {
        
        List<Id> contact1Ids = new List<Id>();
        
        for (Contact newContact : Trigger.new) {
            if (newContact.CreatedFromLeadConversion__c == false) { 
                contact1Ids.add(newContact.Id);    
            }
        }
        
        // Call the future method to update Contacts for those not created by lead conversion
        if (!contact1Ids.isEmpty()) {
            //ContactUpdater.updateContacts(contact1Ids);
            System.enqueueJob(new ContactUpdater(contact1Ids));
            
        }
        
    }
    
}