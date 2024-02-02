@isTest
private class ContactUpdaterTest {

    @isTest
    static void testInsertContacts() {
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
		insert div;
        
		Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
		insert dis; 
        
		Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
		insert salesOff;
        
		Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
		insert salesOrg;
        
        Account testAccount = new Account(
            Name = 'Test Account',
            Bill_To_Mobile__c = '8788995624',
           	Bill_To_Email__c = 'test.ontact1@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A1H5',
            Bill_To_PAN_Number__c = 'EGGPR9887D',
            Bill_To_Country__c = 'IN',
            Bill_To_State__c = 'Maharashtra',
            Bill_To_State_Code_as_Per_GST__c = '06',
            Bill_To_City__c = 'Nagpur',
            Bill_To_Street__c = 'near Armani shop',
            Bill_To_Zip_Postal_Code__c	 = '442001',
            Payment_Term__c = 'C002',
            SAP_Code__c = '21000963',
            Region__c = 'North Region',
            Rating = 'Warm',
            Ship_To_Name__c = 'Test Account',
            Ship_To_Country__c = 'IN',
            AccountSource = 'Employee Referral',
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
			Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
			Division__c = div.Id, //'a021y000007r7Y7AAI',
			Sales_Office__c = salesOff.Id,  //'a051y0000045tUlAAI',
            Search_Term__c = 'test',     
            Bill_To_Street2__c = 'abc',
            Bill_To_Street3__c = 'bcd',
            Bill_To_Phone__c = '8788554462',
            Bill_To_Name2__c = 'abhi',
            Bill_To_Name__c = ' abhii'
            
            // FIELD_CUSTOM_VALIDATION_EXCEPTION, Bill to Fields Fields Cannot be Blank : 
            // Name, Mobile, Email, GST No. PAN Number, Country, State, State Code As Per GST,
            //  City, Street, Zip/Postal Code, Payment Term.: [] 
              
        );
        insert testAccount;
        
        // Create a test Contact record
        Contact testContact = new Contact(
            FirstName = 'Test1',
            AccountId = testAccount.Id,
            LastName = 'Contact',
            Email = 'test.conta3ct@example.com',
            MobilePhone = '1234567895',
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
			Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
			Division__c = div.Id, //'a021y000007r7Y7AAI',
			Sales_Office__c = salesOff.Id,  //'a051y0000045tUlAAI',
            LeadSource = 'Web',
            Department__c = 'Z1',
            Contact_Type__c = 'ZDMC',
            Contact_City__c = 'pune',
            CreatedFromLeadConversion__c = false
            

            
        );
        insert testContact;

        // Set up a successful mock callout response
        Test.setMock(HttpCalloutMock.class, new ContactNewHtPClassMk());

        // Start test execution
        Test.startTest();
         // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'testuser@sapours.com',
            Password__c = '234234',
            RelatedContactCreationURL__c  = 'https://test.com'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }    
       Test.stopTest();
        
         //Test.startTest();
		ContactUpdater contactUpdater = new ContactUpdater(new List<Id>{testContact.Id});
        System.enqueueJob(contactUpdater);
         
        // Call the ContactUpdater.updateContacts method with the test Contact Id
        //ContactUpdater.updateContacts(new List<Id>{testContact.Id});
     
        // Stop test execution
        //Test.stopTest();

        // Retrieve the updated Contact record
        Contact updatedContact = [SELECT Id, SAPId__c, CPAddressId__c FROM Contact WHERE Id = :testContact.Id LIMIT 1];
        
        
        
		 // System.assertNotEquals(null, updatedContact.SAPId__c, 'SAPId__c should not be null');
        // System.assertNotEquals(null, updatedContact.CPAddressId__c, 'CPAddressId__c should not be null');

       
    }
}