trigger LeadCalloutTrigger on Lead (after update) {

    Id convertedLeadIds;
    for(Lead leads : Trigger.new){
        //if (leads.Status == 'Create Customer') {
            
            convertedLeadIds =leads.Id; 
            LeadCalloutClass.AccountContactIdFromCPI(convertedLeadIds); 
        }
    }