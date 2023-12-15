trigger OpportunityIntegrationTrigger on Opportunity (before update) {
    static Boolean hasRun = false;

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            // Check if the trigger has already run in this context
            if (!hasRun) {
                hasRun = true;
                OpportunityTriggerHandlerUpdate.setDescription(Trigger.new);
            }
        }
    }
}