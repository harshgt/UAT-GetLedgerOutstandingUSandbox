@isTest
private class OpportQueueableTest {
         
    
    @isTest
	static void testOpportQueueableSuccess() {
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
    
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
                
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
                
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
                
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
        
        // Create a new user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        UserRole userRole = [SELECT Id FROM UserRole LIMIT 1]; 
        User testUser = new User(
            Alias = 'hpg10',
            Email = 'harshal8@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'hpgt',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'shyamgt10@examples.com'
            
        );
        
        insert testUser;
        
        Account testAccount = new Account(
            Name = 'Test191 Account',
            Bill_To_Mobile__c = '8589995614',
           	Bill_To_Email__c = 'test239@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A1B8',
            Bill_To_PAN_Number__c = 'EGGPR9983P',
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
            Bill_To_Phone__c = '8788114462',
            Bill_To_Name2__c = 'abhi34',
            Bill_To_Name__c = ' abhii34',
            Incoterms__c = 'CFR',
            Sales_Organization__c = salesOrg.Id,
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id
            
 
        );
        insert testAccount;
        
        
        // Test data setup
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test1 Opportunity',
            StageName = 'Potential',
            Technical_Service_Person__c = testUser.Id,
            Project_Group__c = 'New Customer - New Product',
            Quotation_Type__c = 'Z202',
            Status__c = 'Active',
            Lost_Reason__c = 'testLoss',
           
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id,  //'a051y0000045tUlAAI',
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
        
        
  
           
            // Update the Opportunity stage from 'Potential' to 'Discussed with customer'
            testOpportunity.StageName = 'Discussed with customer';
            update testOpportunity;
    
            // Update the Opportunity stage from 'Discussed with customer' to 'Test Initiated'
            testOpportunity.StageName = 'Test Initiated';
            update testOpportunity;
           
     	List<Opportunity> testOPP = new List<Opportunity>{testOpportunity};
            // Enqueue the queueable job
            Test.startTest(); 
           
        //OpportQueueableTest.setupTestData();
        Test.setMock(HttpCalloutMock.class, new OpportHttpCalloutMock(201));
            
         // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'testuser@sapours.net.in',
            Password__c = 'testuser123',
            OpportunityCreationURL__c  = 'https://brilliant-polymdfgdfgers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/create/salesquote/S4hana'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }   
            
            
        OpportQueueable opportQueueable = new OpportQueueable(testOPP);
         System.enqueueJob(opportQueueable);    
            
        OpportunityTriggerHandlerUpdate.triggerHasRun = true;
        System.debug('After enqueuing queueable job'+ testOpportunity.SAP_Quotation_Order_No__c);
        Test.stopTest();

        // Verify the results
        
        List<Opportunity> updatedOpportunities = [SELECT Id, SAP_Quotation_Order_No__c, Error_Response__c FROM Opportunity WHERE Id = :testOPP[0].Id]; 
         System.assertNotEquals(null, updatedOpportunities[0].SAP_Quotation_Order_No__c, 'SAP_Quotation_Order_No__c should not be null');    
      	 System.assertEquals(null, updatedOpportunities[0].Error_Response__c, 'Error_Response__c should be updated as expected');    
            
        
        
	}

    
    @isTest
    static void testOpportQueueableError() {
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
    
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
                
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
                
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
                
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
        
        // Create a new user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        UserRole userRole = [SELECT Id FROM UserRole LIMIT 1]; 
        User testUser = new User(
            Alias = 'hpgt10',
            Email = 'harshal13@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'hpgtgh',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'shyamgt10@examplert.com'
            
        );
        
        insert testUser;
        
        Account testAccount = new Account(
            Name = 'Test11 Account',
            Bill_To_Mobile__c = '8588895614',
           	Bill_To_Email__c = 'test23.ontact56@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A1B9',
            Bill_To_PAN_Number__c = 'EGGPR9983O',
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
            Bill_To_Phone__c = '8789014462',
            Bill_To_Name2__c = 'abhi34',
            Bill_To_Name__c = ' abhii34',
            Incoterms__c = 'CFR',
            Sales_Organization__c = salesOrg.Id,
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id
            
 
        );
        insert testAccount;
        
        
        // Test data setup
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test7 Opportunity',
            StageName = 'Potential',
            Technical_Service_Person__c = testUser.Id,
            Project_Group__c = 'New Customer - New Product',
            Quotation_Type__c = 'Z202',
            Status__c = 'Active',
            Lost_Reason__c = 'testLoss',
          
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id,  //'a051y0000045tUlAAI',
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

        // Set up mock HTTP response for error scenario
        Test.setMock(HttpCalloutMock.class, new OpportHttpCalloutMockError(400));

        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            OpportunityCreationURL__c  = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/create/salesquote/S4hana'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }   
        
        List<Opportunity> testOPP = new List<Opportunity>{testOpportunity};
        // Enqueue the queueable job
        Test.startTest();
        System.enqueueJob(new OpportQueueable(testOPP));   
         OpportunityTriggerHandlerUpdate.triggerHasRun = true;
        Test.stopTest();

        // Verify the results
        Opportunity updatedOpp = [SELECT Id, SAP_Quotation_Order_No__c, Error_Response__c FROM Opportunity WHERE Id = :testOPP[0].Id];
        system.debug('updatedOpp1 ' + updatedOpp);
         system.debug('SAP_Quotation_Order_No__c1 ' + updatedOpp.SAP_Quotation_Order_No__c);
        system.debug('Error_Response__c ' + updatedOpp.Error_Response__c);
        System.assertEquals(null, updatedOpp.SAP_Quotation_Order_No__c);
        System.assertNotEquals(null, updatedOpp.Error_Response__c);
    }
    
    
     @isTest
    static void testOpportQueueableError500() {
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
    
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
                
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
                
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
                
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
        // Create a new user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        UserRole userRole = [SELECT Id FROM UserRole LIMIT 1]; 
        User testUser = new User(
            Alias = 'hpgt10',
            Email = 'harshal@example4.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'hpgt',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'shyamgt10i@example.com'
            
        );
        
        insert testUser;
        
        Account testAccount = new Account(
            Name = 'Test11 Account',
            Bill_To_Mobile__c = '8588995624',
           	Bill_To_Email__c = 'test23.ontact21@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A7B8',
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
            Bill_To_Phone__c = '8788894462',
            Bill_To_Name2__c = 'abhi34',
            Bill_To_Name__c = ' abhii34',
            Incoterms__c = 'CFR',
            Sales_Organization__c = salesOrg.Id,
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id
            
 
        );
        insert testAccount;
        
        
        // Test data setup
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test8 Opportunity',
            StageName = 'Potential',
            Technical_Service_Person__c = testUser.Id,
            Project_Group__c = 'New Customer - New Product',
            Quotation_Type__c = 'Z202',
            Status__c = 'Active',
            Lost_Reason__c = 'testLoss',
            
            
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id,  //'a051y0000045tUlAAI',
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


        // Set up mock HTTP response for error scenario
        Test.setMock(HttpCalloutMock.class, new OpportHttpCalloutMockError(500));

        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            OpportunityCreationURL__c  = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/create/salesquote/S4hana'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }   
        
        
        List<Opportunity> testOPP = new List<Opportunity>{testOpportunity};
        // Enqueue the queueable job
        Test.startTest();
        System.enqueueJob(new OpportQueueable(testOPP));   
         OpportunityTriggerHandlerUpdate.triggerHasRun = true;
        Test.stopTest();

        // Verify the results
        Opportunity updatedOpp = [SELECT Id, SAP_Quotation_Order_No__c, Error_Response__c FROM Opportunity WHERE Id = :testOPP[0].Id];
        system.debug('updatedOpp1 ' + updatedOpp);
         system.debug('SAP_Quotation_Order_No__c1 ' + updatedOpp.SAP_Quotation_Order_No__c);
        system.debug('Error_Response__c ' + updatedOpp.Error_Response__c);
        System.assertEquals(null, updatedOpp.SAP_Quotation_Order_No__c);
        System.assertNotEquals(null, updatedOpp.Error_Response__c);
    }

}