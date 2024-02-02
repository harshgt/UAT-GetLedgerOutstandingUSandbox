@isTest
public class CPICalloutServiceTest {

    @isTest
    static void testUpdateContactSetup() {
        
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
            Sales_Organization__c = salesOrg.Id,//'a061y000007ujs6AAA',
            Division__c =  div.Id,//'a021y000007r7Y7AAI',
            Distribution_Channel__c =  dis.Id,//'a011y000003j1mbAAA',
            Ship_To_Name__c = 'Test Account',
            Ship_To_Country__c = 'IN',
            AccountSource = 'Employee Referral',
            Sales_Office__c = salesOff.Id,//'a051y0000045tUlAAI',
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
            Sales_Organization__c = salesOrg.Id,//'a061y000007ujs6AAA',
            Distribution_Channel__c = dis.Id, //'a011y000003j1mbAAA',
            Division__c =  div.Id,//'a021y000007r7Y7AAI',
            Sales_Office__c = salesOff.Id,//'a051y0000045tUlAAI',
            LeadSource = 'Web',
            Department__c = 'Z1',
            Contact_Type__c = 'ZDMC',
            Contact_City__c = 'pune',
            SAPId__c = '26001547',
            CPAddressId__c = '37568',
            CreatedFromLeadConversion__c = true
              
        );
        insert testContactss;
        
         testContactss.FirstName = 'UpdatedFirstName1212';
        update testContactss;
    
        
        Test.setMock(HttpCalloutMock.class, new CPICalloutServiceMock());

        
        
        // Call the trigger
        Test.startTest();
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'testuser@sapours.com',
            Password__c = '234234',
            ContactUpdateURL__c  = 'https://test.com'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }    
        
        CPICalloutService.sendToCPI(new List<Id>{testContactss.Id});
        Test.stopTest();

        
        // Replace the assertions based on your specific response structure
     // System.assert(CPICalloutServiceMock.request != null);
       // System.assert(CPICalloutServiceMock.request.getBody() != null);
       // System.assert(CPICalloutServiceMock.response.getStatusCode() == 202);
        // System.assert(CPICalloutServiceMock.response.getBody().contains('Successful transaction'));
    }
}