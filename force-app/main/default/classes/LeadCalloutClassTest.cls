@isTest
private class LeadCalloutClassTest {

    @isTest
    static void testLeadCallout() {
        // Create test data, e.g., a Lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open - Not Contacted',
            Email = 'Test@test.com',
            Account_Assessment_Group__c	 = '01',
            Bill_To_City__c = 'Pune',
            Bill_To_Country__c = 'IN',
            Bill_To_Email__c = 'Test@test.com',
            Bill_To_GST_No__c = '22AAAAA0000A1Z5',
            Bill_To_Mobile__c = '1234567890',
            Bill_To_Name__c = 'Test Test',
            Bill_To_Name2__c = 'Test Test',
            Bill_To_PAN_Number__c = 'EGGPR9887T',
            Bill_To_Phone__c = '1234567890',
            Bill_To_State__c = 'Maharashtra',
            Bill_To_State_Code_as_Per_GST__c = '27',
            Bill_To_Street__c = 'Baner',
            Bill_To_Street2__c = 'Pashan Link',
            Bill_To_Street3__c = 'PAN card club road',
            Bill_To_Zip_Postal_Code__c = '411017',
            Contact_City__c = 'Mumbai',
            Contact_State__c = '27',
            Create_Finance_Role__c = true,
            Create_Sales_Role__c = true,
            CreatedFromLeadConversion__c = true,
            Customer_Group__c = '10',
            Customer_Pricing_Procedure__c = '10',
            Customer_Statistic_Group__c = '1',
            Customer_Type__c = 'ZDMC',
            Department__c = 'Z3',
            Designation__c = 'Test Designation',
            Distribution_Channel__c = 'a011y000003j1mbAAA',
            Division__c = 'a021y000007r7Y7AAI',
			Fax = '123456',
            Incoterms__c = 'CFR',
            LeadSource = 'Other',
            Payment_Term__c = 'C001',
            Phone = '1234567890',
            Price_Group__c = '01',
            Pricing__c = true,
            Rating = 'Warm',
            Reconciliation_Account__c = '21000000',
            Region__c = 'North Region',
            Sales_District__c = '000004',
            Sales_Group__c = '036',
            Sales_Office__c = 'a051y0000045tUlAAI',
            Sales_Organization__c = 'a061y000007ujs6AAA',
            Same_as_Bill_To__c = true,
            Search_Term__c = 'test',
            TAN_No__c = 'PDES03028F',
            Type__c = 'Customer',
            Website = 'www.test.com');
            
            
            
            // Add other required fields here
        
        insert testLead;

        // Start Test context
        Test.startTest();
        LeadCalloutTriggerHandlerClass.LeadStatusCallout(new List<Lead>{testLead});
        Test.stopTest();
        
        
        // Verify that the lead has been enqueued for processing
        System.assertEquals(1, Limits.getQueueableJobs(), 'Lead should be enqueued for processing');
    }
}