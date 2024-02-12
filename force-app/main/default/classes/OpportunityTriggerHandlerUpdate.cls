public class OpportunityTriggerHandlerUpdate 
{ 						
    public static Boolean triggerHasRun = false;
    
    public static void setDescription (List<Opportunity> opportunities)
    { 
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        
        for (Opportunity opp: opportunities)
        { 
            if (!triggerHasRun && opp.SAP_Quotation_Order_No__c == null && opp.Sales_Organization_Code__c != '1002' && opp.StageName == 'Test Initiated')
            {
                opportunitiesToUpdate.add(opp);
                
            }     
        }
        
        if (!opportunitiesToUpdate.isEmpty())
        { 
            //getDescription(opportunitiesToUpdate);
            System.EnqueueJob(new OpportQueueable (opportunities));
        }
        
    }
    
    
    
   /* private static void getDescription(List<Opportunity> opportunities)
    {
        System.EnqueueJob(new OpportQueueable (opportunities));
    }*/
    
}