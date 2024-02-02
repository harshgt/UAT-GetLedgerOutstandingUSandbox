public class LeadCalloutTriggerHandlerClass {
    
    
    public static void LeadStatusCallout(List<Lead> NewleadList){
        
        List<Lead> ToBeQueueLeadList = new List<Lead>();
        
        for(Lead leads : NewleadList){
            if(leads.Status == 'Create Customer'){		// && leads.Customer_Type__c != 'Domestic Vendor'
                ToBeQueueLeadList.add(leads);
            }
        }
        
        if(ToBeQueueLeadList.size()>0){
            LeadStatusQueueCallout(ToBeQueueLeadList);
        }
    }
    
    public static void LeadStatusQueueCallout(List<Lead> MainLeadStatus){
        System.EnqueueJob(new FirstLeadQueue(MainLeadStatus));
    }
}