trigger OpportunityIntegrationTrigger on Opportunity (before update) {
    static Boolean hasRun = false;

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            if (!hasRun) {
                hasRun = true;
            
                OpportunityTriggerHandlerUpdate.setDescription(Trigger.new);
             }
        }
    }
    
    
    
}