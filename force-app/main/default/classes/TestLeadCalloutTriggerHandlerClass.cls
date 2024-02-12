@isTest
private class TestLeadCalloutTriggerHandlerClass {
    
    @isTest
    static void testLeadStatusCallout() {
        // Create a test lead with the status 'Create Customer' and a specific Customer_Type__c
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
        
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
        
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
        
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
        
        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Create Customer',
            Email = 'Test@test.com',
            Account_Assessment_Group__c	 = '01',
            Bill_To_City__c = 'Pune',
            Bill_To_Country__c = 'IN',
            Bill_To_Email__c = 'Test@test.com',
            Bill_To_GST_No__c = '22AAAAA0000A1Z5',
            Bill_To_Mobile__c = '1234567890',
            Bill_To_Name__c = 'TestTest',
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
            Fax = '123456',
            Incoterms__c = 'CFR',
            LeadSource = 'Other',
            MobilePhone = '1234567890',
            Payment_Term__c = 'C001',
            Phone = '1234567890',
            Price_Group__c = '01',
            Pricing__c = true,
            Rating = 'Warm',
            Reconciliation_Account__c = '21000000',
            Region__c = 'North Region',
            Sales_District__c = '000004',
            Sales_Group__c = '036',
            Same_as_Bill_To__c = true,
            Search_Term__c = 'test',
            TAN_No__c = 'PDES03028F',
            Type__c = 'Customer',
            Website = 'www.test.com',
            Delivery_Priority__c = '02',
            Currency__c = 'INR',
            Shipping_Condition__c = '01',
            Company_Code__c = '1000',
            Sales_Organization__c = salesOrg.Id,
			Distribution_Channel__c =  dis.Id,
			Division__c = div.Id,
			Sales_Office__c = salesOff.Id
            // Set other lead fields as needed
        );
        insert testLead;
        Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(201));
        
        
        
        Test.startTest();
        
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;
        
        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'testuser@sapours.net.in',
            Password__c = 'testuser123',
            BPCreationURL__c  = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/create/account1'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }  
        
        
        
        
        
        LeadCalloutTriggerHandlerClass.LeadStatusCallout(new List<Lead>{testLead});
        Test.stopTest();
        
        
        
        // Call the trigger handler method
        //Test.startTest();
        //system.debug(testLead);
        
        // Test.stopTest();
        
        // Add assertions based on the expected behavior
        
        // For example, you might check if a job was enqueued for processing
        System.assertEquals(1, Limits.getQueueableJobs(), 'Lead should be enqueued for processing');
    }
    
    
    /* @isTest
static void testLeadStatusQueueCallout() {
// Create a test lead with the status 'Create Customer' and a specific Customer_Type__c
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
MobilePhone = '1234567890',
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
Website = 'www.test.com',
Delivery_Priority__c = '02',
Currency__c = 'INR',
Shipping_Condition__c = '01',
Company_Code__c = '1000'
// Set other lead fields as needed
);
insert testLead;

Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(201));

// Call the LeadStatusQueueCallout method directly
Test.startTest();
LeadCalloutTriggerHandlerClass.LeadStatusQueueCallout(new List<Lead>{testLead});
Test.stopTest();

// Add assertions based on the expected behavior
// For example, check if a job was enqueued for processing
System.assertEquals(0, Limits.getQueueableJobs(), 'Lead should be enqueued for processing');
}*/
    
    
}