@isTest
public class SecondLeadQueueTest {
	@isTest
    static void AccountExecute(){
        Division__c div = new Division__c (Name = 'Laminating Adhesives', Division_Code__c = 11);
        insert div;
        
        Distribution_Channel__c dis = new Distribution_Channel__c(Name = 'Direct Sales', Distribution_Channel_Code__c = 11);
        insert dis; 
        
        Sales_Office__c salesOff = new Sales_Office__c(Name = 'Ambernath', Sales_Office_Code__c = 1001);
        insert salesOff;
        
        Sales_Organization__c salesOrg = new Sales_Organization__c(Name = 'BPPL - Domestic', Sales_Org_Code__c = 1001);
        insert salesOrg;
        
        Account testAccount = new Account(
            Name = 'Test Company',
            SAP_Code__c = '12345678',
            BPAddressId__c = '12345',
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
            Ship_To_Name__c = 'TestTest',
            Ship_To_Country__c = 'IN',
            AccountSource = 'Employee Referral',
            Search_Term__c = 'test',     
            Bill_To_Street2__c = 'Pashan Link',
            Bill_To_Street3__c = 'PAN card club road',
            Bill_To_Phone__c = '1234567890',
            Bill_To_Name2__c = 'Test Test',
            Bill_To_Name__c = 'TestTest',
            Sales_Organization__c = salesOrg.Id,
			Distribution_Channel__c =  dis.Id,
			Division__c = div.Id,
			Sales_Office__c = salesOff.Id);
        
        insert testAccount;
        
        Test.setMock(HttpCalloutMock.class, new HttpLeadCalloutMock(202));
        
        
        Test.startTest();
        
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;
        
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'testuser@sapours.net.in',
            Password__c = 'testuser123',
            BPUpdateURL2__c  = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/update/cin'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }  
                

        System.enqueueJob(new SecondLeadQueue(testAccount.SAP_Code__c));
        Test.stopTest();
        
}
}