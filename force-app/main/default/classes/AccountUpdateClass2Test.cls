@isTest
public class AccountUpdateClass2Test {

    @isTest
    static void testTriggerLogic() {
        // Create test data
       Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
        
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
        
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
        
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
         
        
        
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
            Sales_Organization__c = salesOrg.Id,
			Distribution_Channel__c =  dis.Id,
			Division__c = div.Id,
			Sales_Office__c = salesOff.Id
            
            
              
        );
        insert testAccount;
        
        Sales_Organization__c salesOrg1 = new Sales_Organization__c(Name = 'BPPL - Export', Sales_Org_Code__c = 1003);
        insert salesOrg1;
        
        testAccount.Sales_Organization__c = salesOrg1.Id;
        update testAccount;
        
        testAccount.Bill_To_Name2__c = 'Updated Test Account';
        update testAccount;

        
		Test.setMock(HttpCalloutMock.class, new Account2CallHttpMock(202));
         Test.startTest();
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
           Username__c = 'test123',
            Password__c = 'test124',
            BPUpdateURL1__c = ' https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/test'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }
        
        Test.stopTest();
       
        
        
         AccountUpdateClass2 testClass2 = new AccountUpdateClass2(testAccount.Id, '21000963', 1);
        //Test.startTest();
        
		 System.enqueueJob(testClass2);

        //Test.stopTest();

        // Retrieve the updated account
        Account updatedAccount = [SELECT Id, Bill_To_Name2__c, SAP_Code__c FROM Account WHERE Id = :testAccount.Id];

        // Perform assertions
        System.assertEquals('Updated Test Account', updatedAccount.Bill_To_Name2__c, 'Account Name should be updated');
        
    }
    
    
}