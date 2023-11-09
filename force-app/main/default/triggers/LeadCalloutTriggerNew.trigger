trigger LeadCalloutTriggerNew on Lead (after update) {
        if (Trigger.isUpdate) {
            LeadCalloutTriggerHandlerClass.LeadStatusCallout(Trigger.new);
        }
}