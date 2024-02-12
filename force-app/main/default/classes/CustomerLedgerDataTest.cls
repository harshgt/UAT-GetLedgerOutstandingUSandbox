@isTest
public class CustomerLedgerDataTest {

    @isTest
    static void testCustomerLedgerData_Success() {
        // Set up test data
        Date startDate = Date.valueOf('2023-01-01');
        Date endDate = Date.valueOf('2023-01-31');
        String accountSapId = '001';
        String companyCode = '1000';

        // Mock the HTTP response with 200 status code
        Test.setMock(HttpCalloutMock.class, new CustomerLedgerMockCls(200));
 Test.startTest(); 
        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            CustomerLedgerURL__c = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMERLEGER'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }
        Test.stopTest();
       

        // Verify the inserted custom setting
        System.debug('Inserted Authorization__c: ' + [SELECT Id, username__c, password__c, CustomerLedgerURL__c FROM Authorization__c]);


        // Call the customerLedgerData method
        Map<String, Object> result = CustomerLedgerData.customerLedgerData(startDate, endDate, accountSapId, companyCode);
 
        // Add assertions for the expected result
        System.assertNotEquals(null, result, 'Response should not be null');
        System.assertEquals('success', result.get('status'));
        System.assertNotEquals(null, result.get('status'), 'Status should not be empty');
    }

    @isTest
    static void testCustomerLedgerData_Error() {
        // Set up test data for an error scenario
        Date startDate = Date.valueOf('2023-01-01');
        Date endDate = Date.valueOf('2023-01-31');
        String accountSapId = '001';
        String companyCode = '1000';

        // Mock the HTTP response with a non-200 status code (e.g., 404)
        Test.setMock(HttpCalloutMock.class, new CustomerLedgerMockCls(404));

        // Get the organization ID dynamically
        String organizationId = [SELECT Id FROM Organization LIMIT 1].Id;

        // Mock the custom setting
        Authorization__c authSettings = new Authorization__c(
            SetupOwnerId = organizationId,
            Username__c = 'harshal.thakare@sapours.net.in',
            Password__c = '@Shyam004',
            CustomerLedgerURL__c = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/GETCUSTOMERLEGER'
            // Add other fields as needed
        );
        if (Test.isRunningTest()) {
            // Insert custom setting only during test
            insert authSettings;
        }

        Test.startTest(); 
        // Call the customerLedgerData method
        Map<String, Object> result = CustomerLedgerData.customerLedgerData(startDate, endDate, accountSapId, companyCode);
 Test.stopTest();
        // Add assertions for the expected error handling
        System.assertNotEquals(null, result, 'Response should not be null');
    }
}















/*@isTest
public class CustomerLedgerDataTest {

    @isTest
    static void testCustomerLedgerData_Success() {
        // Set up test data
        Date startDate = Date.valueOf('2023-01-01');
        Date endDate = Date.valueOf('2023-01-31');
        String accountSapId = '001';
        String companyCode = '1000';

        // Mock the HTTP response with 200 status code
        Test.setMock(HttpCalloutMock.class, new CustomerLedgerMockCls(200));
        
        

        // Call the customerLedgerData method
        Map<String, Object> result = CustomerLedgerData.customerLedgerData(startDate, endDate, accountSapId, companyCode);

        // Add assertions for the expected result
        System.assertNotEquals(null, result, 'Response should not be null');
		System.assertEquals('success', result.get('status'));
        System.assertNotEquals(null, result.get('status'), 'Status should not be empty');

    }

    @isTest
    static void testCustomerLedgerData_Error() {
        // Set up test data for an error scenario
        Date startDate = Date.valueOf('2023-01-01');
        Date endDate = Date.valueOf('2023-01-31');
        String accountSapId = '001';
        String companyCode = '1000';

        // Mock the HTTP response with a non-200 status code (e.g., 404)
        Test.setMock(HttpCalloutMock.class, new CustomerLedgerMockCls(404));
// Mock the custom setting directly in the test method
        
        // Call the customerLedgerData method
        Map<String, Object> result = CustomerLedgerData.customerLedgerData(startDate, endDate, accountSapId, companyCode);

        // Add assertions for the expected error handling
        System.assertNotEquals(null, result, 'Response should not be null'); 
        
    }
}*/