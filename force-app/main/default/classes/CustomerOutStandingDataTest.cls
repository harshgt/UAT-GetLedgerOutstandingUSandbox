@isTest
public class CustomerOutStandingDataTest {
    @isTest
    static void testOverdueScenario() {
        String accountSapId = 'TestAccount';
        String companyCode = 'TestCompanyCode';
        String selectedValueForType = 'Overdue';
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));

        Test.startTest();
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            CustomerOutstandingURL__c = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMEROUTSTANDING'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        } 
        
        Test.stopTest();
        
        Map<String, Object> result = customerOutStandingData.customerOutStandingData(accountSapId, companyCode, selectedValueForType);
       

        //System.assertNotEquals(null, result);
        // Add assertions for specific response data in the 'Overdue' scenario
    }

    @isTest
    static void testNoDueScenario() {
        String accountSapId = 'TestAccount';
        String companyCode = 'TestCompanyCode';
        String selectedValueForType = 'No Due';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));

        Test.startTest();
        
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            CustomerOutstandingURL__c = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMEROUTSTANDING'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }
        
        Test.stopTest();
        
        Map<String, Object> result = customerOutStandingData.customerOutStandingData(accountSapId, companyCode, selectedValueForType);
        

        System.assertNotEquals(null, result);
        // Add assertions for specific response data in the 'No Due' scenario
    }

    @isTest
    static void testDefaultScenario() {
        String accountSapId = 'TestAccount';
        String companyCode = 'TestCompanyCode';
        String selectedValueForType = 'SomeOtherValue';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));

        Test.startTest();
        
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            CustomerOutstandingURL__c = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMEROUTSTANDING'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        } 
        Test.stopTest();
        
        Map<String, Object> result = customerOutStandingData.customerOutStandingData(accountSapId, companyCode, selectedValueForType);
       
		System.assertNotEquals(result.get('message'), 'Response should not be null');
        System.assertNotEquals(null, result);
        // Add assertions for specific response data in the default scenario
    }

    @isTest
    static void testInvalidResponse() {
        String accountSapId = 'TestAccount';
        String companyCode = 'TestCompanyCode';
        String selectedValueForType = 'Overdue';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(404));

        Test.startTest();
        
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            CustomerOutstandingURL__c = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMEROUTSTANDING'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        } 
         Test.stopTest();
        
        
       
        Map<String, Object> result = customerOutStandingData.customerOutStandingData(accountSapId, companyCode, selectedValueForType);
      

        
        System.assertEquals('Some error message', result.get('message'));
        // Add assertions for handling invalid responses
    }
}