@isTest
public class FirstLeadQueueTest {
    
    
    /* @testSetup
public static void Setup(){
testLead = new Lead(
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
Website = 'www.test.com');
insert testLead;

}
*/
    
    @isTest
    static void execute(){
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
			Sales_Office__c = salesOff.Id);
        insert testLead;
        
        
        System.debug(testLead);
        //FirstLeadQueueTest.Setup();
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
        
        
       
        
        
        
        Test.stopTest();
        
        
         System.enqueueJob(new FirstLeadQueue(new List<Lead>{testLead}));
        //System.enqueueJob(new SecondLeadQueue('TestCustomerId'));
        
        
        
        
        Lead updatedLead = [SELECT Id, Status, Error_Response__c FROM Lead WHERE Id = :testLead.Id];
        System.debug(updatedLead);
        //System.assertEquals('Closed – Converted', testLead.Status);
        //System.assertNull(updatedLead.Error_Response__c);
        
        
        
    }
    @isTest
    static void failedexecute(){
        
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
			Sales_Office__c = salesOff.Id);
        insert testLead;
        
        
        System.debug(testLead);
        //FirstLeadQueueTest.Setup();
        Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(400));
        
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
        System.enqueueJob(new FirstLeadQueue(new List<Lead>{testLead}));
        Test.stopTest();
        
        Lead updatedLead = [SELECT Id, Status, Error_Response__c FROM Lead WHERE Id = :testLead.Id];
        System.debug(updatedLead);
        //System.assertEquals('Closed – Converted', testLead.Status);
        //System.assertNull(updatedLead.Error_Response__c);
        
        
        
    }
    
    
    @isTest
    static void testUpdateRecords() {
        
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
			Sales_Office__c = salesOff.Id);
        insert testLead; 
        
        Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(201));
        
        
        FirstLeadQueue.convertLead(testLead.Id);
        
        
        /*			Account testAccount = new Account(
Name = 'Test Company',
Bill_To_Mobile__c = '1234567890',
Bill_To_Email__c = 'Test@test.com',
Bill_To_GST_No__c = '22AAAAA0000A1H5',
Bill_To_PAN_Number__c = 'EGGPR9887T',
Bill_To_Country__c = 'IN',
Bill_To_State__c = 'Maharashtra',
Bill_To_State_Code_as_Per_GST__c = '27',
Bill_To_City__c = 'Pune',
Bill_To_Street__c = 'Baner',
Bill_To_Zip_Postal_Code__c	 = '411017',
Payment_Term__c = 'C001',
Region__c = 'North Region',
Rating = 'Warm',
Division__c = 'a021y000007r7Y7AAI',
Distribution_Channel__c = 'a011y000003j1mbAAA',
Ship_To_Name__c = 'TestTest',
Ship_To_Country__c = 'IN',
AccountSource = 'Employee Referral',
Sales_Office__c = 'a051y0000045tUlAAI',
Search_Term__c = 'test',     
Bill_To_Street2__c = 'Pashan Link',
Bill_To_Street3__c = 'PAN card club road',
Bill_To_Phone__c = '1234567890',
Bill_To_Name2__c = 'Test Test',
Bill_To_Name__c = 'TestTest'


);
insert testAccount;

// Create a test Contact record
Contact testContact = new Contact(
FirstName = 'Test',
AccountId = testAccount.Id,
LastName = 'Lead',
Email = 'Test@test.com',
MobilePhone = '1234567890',
Sales_Organization__c = 'a061y000007ujs6AAA',
Distribution_Channel__c = 'a011y000003j1mbAAA',
Division__c = 'a021y000007r7Y7AAI',
Sales_Office__c = 'a051y0000045tUlAAI',
LeadSource = 'Other',
Department__c = 'Z3',
Contact_Type__c = 'ZDMC',
Contact_City__c = 'Pune',
CreatedFromLeadConversion__c = true



);
insert testContact;
*/
        
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
        FirstLeadQueue.updateRecords('SAPAddressId', 'CustomerAddressId', 'CustomerId', 'SapId', testLead.Id);
        
        Test.stopTest();
        
        // Retrieve the updated records and assert the expected changes
        //Account updatedAccount = [SELECT SAP_Code__c, BPAddressId__c FROM Account WHERE Id = :testLead.ConvertedAccountId];
        //Contact updatedContact = [SELECT SAPId__c, CPAddressId__c FROM Contact WHERE Id = :testLead.ConvertedContactId];
        
        // Add assertions based on your expected behavior
        // Assert.assertEquals(expectedValue, actualValue);
    }
    
    @isTest
    static void testRevertStatus() {
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
        
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
        
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
        
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
        // Create test data
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
			Sales_Office__c = salesOff.Id);
        
        insert testLead;
        
        Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(201));
        
        // Start test
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
        // Call the RevertStatus method
        FirstLeadQueue.RevertStatus(testLead.Id, 'Error message');
        
        // Stop test
        Test.stopTest();
        
        // Retrieve the updated lead and assert the expected changes
        Lead updatedLead = [SELECT Status, Error_Response__c FROM Lead WHERE Id = :testLead.Id];
        
        // Add assertions based on your expected behavior
        // Assert.assertEquals(expectedValue, actualValue);
    }
    
    @isTest
    static void testConvertLead() {
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
        
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
        
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
        
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        // Create test data
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
			Sales_Office__c = salesOff.Id);
        
        insert testLead;
        
        Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(201));
        
        // Start test
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
        
        // Call the convertLead method
        FirstLeadQueue.convertLead(testLead.Id);
        
        // Stop test
        Test.stopTest();
        
        // Retrieve the converted lead and assert the expected changes
        Lead convertedLead = [SELECT Id, Status, Error_Response__c FROM Lead WHERE Id = :testLead.Id];
        
        // Add assertions based on your expected behavior
        // Assert.assertEquals(expectedValue, actualValue);
    }
    
    // ... Additional test methods ...
    
}