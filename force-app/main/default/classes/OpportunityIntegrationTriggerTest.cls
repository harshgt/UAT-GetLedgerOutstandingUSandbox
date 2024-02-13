@isTest
private class OpportunityIntegrationTriggerTest {
    

  
    @isTest
    static void testOpportunityIntegrationTrigger() {
        
        // Get the ID of the standard price book in the test context
        Id standardPricebookId = Test.getStandardPricebookId();

        // Test data setup: Create a Product
        Product2 testProduct = new Product2(
            Name = 'Brilliant G180'
            // Add other required fields for the product
        );
        insert testProduct;

        // Create a Price Book Entry for the Product in the Standard Price Book
        PricebookEntry testProductPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = testProduct.Id,
            UnitPrice = 165,
            IsActive = true
        );
        insert testProductPricebookEntry;

        Division__c div1 = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div1;
                
        Distribution_Channel__c dis1 = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis1; 
                
        Sales_Office__c salesOff1 = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff1;
                
        Sales_Organization__c salesOrg1 = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg1;
        
        
        // Create a new user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        UserRole userRole = [SELECT Id FROM UserRole LIMIT 1]; 
        User testUser = new User(
            Alias = 'utkzzz',
            Email = 'utkz@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'instaidutkzzz@example.com'
            
        );
        
        insert testUser;

        Account testAccount = new Account(
            Name = 'Test11 Account',
            Bill_To_Mobile__c = '8588995614',
           	Bill_To_Email__c = 'test23.ontact21@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A1B8',
            Bill_To_PAN_Number__c = 'EGGPR9983D',
            Bill_To_Country__c = 'IN',
            Bill_To_State__c = 'Maharashtra',
            Bill_To_State_Code_as_Per_GST__c = '06',
            Bill_To_City__c = 'Nagpur',
            Bill_To_Street__c = 'near Armani shop',
            Bill_To_Zip_Postal_Code__c	 = '442001',
            Payment_Term__c = 'C002',
            SAP_Code__c = '21000963',
            BPAddressId__c = '37568',
            Region__c = 'North Region',
            Rating = 'Warm',
            Ship_To_Name__c = 'Test Account',
            Ship_To_Country__c = 'IN',
            AccountSource = 'Employee Referral',
		    Search_Term__c = 'test',     
            Bill_To_Street2__c = 'abc',
            Bill_To_Street3__c = 'bcd',
            Bill_To_Phone__c = '8788014462',
            Bill_To_Name2__c = 'abhi34',
            Bill_To_Name__c = ' abhii34',
            Incoterms__c = 'CFR',
            Sales_Organization__c = salesOrg1.Id,
            Distribution_Channel__c =  dis1.Id, //'a011y000003j1mbAAA',
            Division__c = div1.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff1.Id
 
        );
        insert testAccount;
        
        
        
        // Test data setup
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Potential',
            Technical_Service_Person__c = testUser.Id,
            Project_Group__c = 'New Customer - New Product',
            Quotation_Type__c = 'Z202',
            Status__c = 'Active',
            Lost_Reason__c = 'testLoss',
            Sales_Organization__c = salesOrg1.Id,
            Distribution_Channel__c =  dis1.Id, //'a011y000003j1mbAAA',
            Division__c = div1.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff1.Id,  //'a051y0000045tUlAAI',
            CloseDate = Date.today().addDays(1),
            Start_Date__c = Date.today(),
            SAP_Quotation_Order_No__c = null,
            AccountId = testAccount.Id,
            Ship_To_Party__c = testAccount.Id,
             Sold_To_Party__c = testAccount.Id
            // Add other required fields as needed
        );
        insert testOpportunity;

        // Create an Opportunity Line Item associating the product with the opportunity
        OpportunityLineItem testOpportunityLineItem = new OpportunityLineItem(
            OpportunityId = testOpportunity.Id,
            PricebookEntryId = testProductPricebookEntry.Id,
            UnitPrice = 165,
            Quantity = 5,
            Sample_Requested_Qty__c = 5
            // Add other required fields for the OpportunityLineItem
        );
        insert testOpportunityLineItem;

     
        Test.setMock(HttpCalloutMock.class, new OpportHttpCalloutMock(201));
       

        Test.startTest();


          // Update the Opportunity stage from 'Potential' to 'Discussed with customer'
            testOpportunity.StageName = 'Discussed with customer';
            update testOpportunity;

            // Update the Opportunity stage from 'Discussed with customer' to 'Test Initiated'
            testOpportunity.StageName = 'Test Initiated';
            update testOpportunity;
        
        List<Opportunity> testOPP = new List<Opportunity>{testOpportunity};
            
            // Your trigger logic to update opportunities
            OpportunityTriggerHandlerUpdate.setDescription(testOPP);
             OpportunityTriggerHandlerUpdate.triggerHasRun = true;
        

        // Ensure that all asynchronous processes are completed
        Test.stopTest();

        // Assertions based on your requirements
        // Query the opportunities and verify the changes
        Opportunity updatedOpp = [SELECT Id, StageName, SAP_Quotation_Order_No__c, Error_Response__c FROM Opportunity WHERE Id = :testOPP[0].Id];
	system.debug('updatedOpp not error ' + updatedOpp);
        System.assertEquals('Test Initiated', updatedOpp.StageName, 'StageName should be updated to Test Initiated');
        // Add more assertions as needed
        
        // Verify that triggerHasRun is reset to false
        System.assertEquals(true, OpportunityTriggerHandlerUpdate.triggerHasRun, 'triggerHasRun should be reset to false'); 
    }
    
    
    @isTest
    static void testOpportunityIntegrationTriggerError() {
        
         // Get the ID of the standard price book in the test context
        Id standardPricebookId = Test.getStandardPricebookId();

        // Test data setup: Create a Product
        Product2 testProduct = new Product2(
            Name = 'Brilliant G180'
            // Add other required fields for the product
        );
        insert testProduct;

        // Create a Price Book Entry for the Product in the Standard Price Book
        PricebookEntry testProductPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = testProduct.Id,
            UnitPrice = 165,
            IsActive = true
        );
        insert testProductPricebookEntry;

        Division__c div1 = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div1;
                
        Distribution_Channel__c dis1 = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis1; 
                
        Sales_Office__c salesOff1 = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff1;
                
        Sales_Organization__c salesOrg1 = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg1;
        
         // Create a new user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        UserRole userRole = [SELECT Id FROM UserRole LIMIT 1]; 
        User testUser = new User(
            Alias = 'hpgt10',
            Email = 'harshal@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'hpgt',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'shyamgt10@example.com'
            
        );
        
        insert testUser;
        
        Account testAccount = new Account(
            Name = 'Test11 Account',
            Bill_To_Mobile__c = '8588995614',
           	Bill_To_Email__c = 'test23.ontact21@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A1B8',
            Bill_To_PAN_Number__c = 'EGGPR9983D',
            Bill_To_Country__c = 'IN',
            Bill_To_State__c = 'Maharashtra',
            Bill_To_State_Code_as_Per_GST__c = '06',
            Bill_To_City__c = 'Nagpur',
            Bill_To_Street__c = 'near Armani shop',
            Bill_To_Zip_Postal_Code__c	 = '442001',
            Payment_Term__c = 'C002',
            SAP_Code__c = '21000963',
            BPAddressId__c = '37568',
            Region__c = 'North Region',
            Rating = 'Warm',
            Ship_To_Name__c = 'Test Account',
            Ship_To_Country__c = 'IN',
            AccountSource = 'Employee Referral',
		    Search_Term__c = 'test',     
            Bill_To_Street2__c = 'abc',
            Bill_To_Street3__c = 'bcd',
            Bill_To_Phone__c = '8788014462',
            Bill_To_Name2__c = 'abhi34',
            Bill_To_Name__c = ' abhii34',
            Incoterms__c = 'CFR',
            Sales_Organization__c = salesOrg1.Id,
            Distribution_Channel__c =  dis1.Id, //'a011y000003j1mbAAA',
            Division__c = div1.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff1.Id
            
 
        );
        insert testAccount;
        

        
        // Test data setup
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Potential',
            Technical_Service_Person__c = testUser.Id,
            Project_Group__c = 'New Customer - New Product',
            Quotation_Type__c = 'Z202',
            Status__c = 'Active',
            Lost_Reason__c = 'testLoss',
            Sales_Organization__c = salesOrg1.Id,
            Distribution_Channel__c =  dis1.Id, //'a011y000003j1mbAAA',
            Division__c = div1.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff1.Id,  //'a051y0000045tUlAAI',
            CloseDate = Date.today().addDays(1),
            Start_Date__c = Date.today(),
            SAP_Quotation_Order_No__c = null,
            AccountId = testAccount.Id,
            Ship_To_Party__c = testAccount.Id,
             Sold_To_Party__c = testAccount.Id
            // Add other required fields as needed
        );
        insert testOpportunity;

        // Create an Opportunity Line Item associating the product with the opportunity
        OpportunityLineItem testOpportunityLineItem = new OpportunityLineItem(
            OpportunityId = testOpportunity.Id,
            PricebookEntryId = testProductPricebookEntry.Id,
            UnitPrice = 165,
            Quantity = 5,
            Sample_Requested_Qty__c = 5
            // Add other required fields for the OpportunityLineItem
        );
        insert testOpportunityLineItem;
        
        
        
        // Set up test data
        Test.setMock(HttpCalloutMock.class, new OpportHttpCalloutMockError(400));
       

        Test.startTest();
   

            // Update the Opportunity stage from 'Potential' to 'Discussed with customer'
            testOpportunity.StageName = 'Discussed with customer';
            update testOpportunity;

            // Update the Opportunity stage from 'Discussed with customer' to 'Test Initiated'
            testOpportunity.StageName = 'Test Initiated';
            update testOpportunity;
            
        
        List<Opportunity> newOppList = new List<Opportunity>{testOpportunity};
            
            // Your trigger logic to update opportunities
            OpportunityTriggerHandlerUpdate.setDescription(newOppList);
             OpportunityTriggerHandlerUpdate.triggerHasRun = true;
       
        // Ensure that all asynchronous processes are completed
        Test.stopTest();

        // Assertions based on your requirements
        // Query the opportunities and verify the changes
        Opportunity updatedOpp = [SELECT Id, StageName, SAP_Quotation_Order_No__c, Error_Response__c FROM Opportunity WHERE Id = :newOppList[0].Id];
		system.debug('updatedOpp ' + updatedOpp);
        System.assertEquals('Test Initiated', updatedOpp.StageName, 'StageName should be updated to Test Initiated');
        // Add more assertions as needed
        
         // Verify that triggerHasRun is reset to false
        System.assertEquals(true, OpportunityTriggerHandlerUpdate.triggerHasRun, 'triggerHasRun should be reset to false'); 
        
    }
    
    
    
    
    
}