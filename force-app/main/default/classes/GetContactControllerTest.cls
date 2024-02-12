@isTest
private class GetContactControllerTest {

    @isTest
    static void testGetEmailsForAccount() {
        
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
        
        
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
        
        
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
        
        
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg; 
                
        
         Account testAccount = new Account(
            Name = 'Test Account123',
            Bill_To_Mobile__c = '8788995624',
           	Bill_To_Email__c = 'test.ontact12@example.com',
            Bill_To_GST_No__c = '22AAAAA0000A1B6',
            Bill_To_PAN_Number__c = 'EGGPR9885A',
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
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
            Division__c = div.Id,   //'a021y000007r7Y7AAI',
            Distribution_Channel__c = dis.Id, //'a011y000003j1mbAAA',
            Ship_To_Name__c = 'Test Account',
            Ship_To_Country__c = 'IN',
            AccountSource = 'Employee Referral',
            Sales_Office__c = salesOff.Id, //'a051y0000045tUlAAI',
            Search_Term__c = 'test',     
            Bill_To_Street2__c = 'abc',
            Bill_To_Street3__c = 'bcd',
            Bill_To_Phone__c = '8788554462',
            Bill_To_Name2__c = 'abhi123',
            Bill_To_Name__c = ' abhii3'
            
            // FIELD_CUSTOM_VALIDATION_EXCEPTION, Bill to Fields Fields Cannot be Blank : 
            // Name, Mobile, Email, GST No. PAN Number, Country, State, State Code As Per GST,
            //  City, Street, Zip/Postal Code, Payment Term.: [] 
              
        );
        insert testAccount;
        
        // Create a test Contact record
        Contact testContactss = new Contact(
            FirstName = 'Test111',
            AccountId = testAccount.Id,
            LastName = 'Contacts1',
            Email = 'test.conta3ct23@example.com',
            MobilePhone = '1234567815',
            Sales_Organization__c = salesOrg.Id, //'a061y000007ujs6AAA',
            Distribution_Channel__c =  dis.Id, //'a011y000003j1mbAAA',
            Division__c = div.Id, //'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id,  //'a051y0000045tUlAAI',
            LeadSource = 'Web',
            Department__c = 'Z1',
            Contact_Type__c = 'ZDMC',
            Contact_City__c = 'pune',
            SAPId__c = '26001547',
            CPAddressId__c = '37568',
            CreatedFromLeadConversion__c = true
              
        );
         

        // Create test contacts for the account
        Contact testContact1 = testContactss;
        insert new List<Contact>{testContact1};

        Test.startTest();
        // Call the method to be tested
        List<String> result = GetContactController.getEmailsForAccount(testAccount.Id);
        Test.stopTest();

        // Verify the result
        System.assertEquals('test.conta3ct23@example.com', result[0], 'Unexpected email');
        System.assert(!result.isEmpty(), 'Email list should not be empty');
    }
}