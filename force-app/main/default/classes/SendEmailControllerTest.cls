@isTest
private class SendEmailControllerTest {

    @isTest
    static void testSendEmail() {
        // Set up test data
        List<String> toAddress = new List<String>{'test@example.com'};
        List<String> toCCAddress = new List<String>{'cc@example.com'};
        String bodyEmail = 'Test email body';
        String toAttachment = '[{"name": "TestAttachment.txt", "contentVersionId": "ContentVersionId123", "mimeType": "text/plain"}]';
        String CustomerName = 'Test1';
        
        // Mock the call to UserInfo.getUserId()
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            // Insert a ContentVersion record
            ContentVersion testContentVersion = new ContentVersion(
                VersionData = Blob.valueOf('Test attachment content'),
                PathOnClient = 'TestAttachment.txt',
                Title = 'TestAttachment'
            );
            insert testContentVersion;

            // Test with CustOutCodeEmail = 'oustanding' and attachmentContent not null
            String custOutCodeEmail1 = 'oustanding';
            String result1 = SendEmailController.sendEmail(toAddress, toCCAddress, bodyEmail, toAttachment, custOutCodeEmail1, CustomerName );
            System.assertNotEquals(null, result1);

            // Test with CustOutCodeEmail = 'ledger' and attachmentContent not null
            String custOutCodeEmail2 = 'ledger';
            String result2 = SendEmailController.sendEmail(toAddress, toCCAddress, bodyEmail, toAttachment, custOutCodeEmail2, CustomerName);
            System.assertNotEquals(null, result2);

            // Test with a different value of CustOutCodeEmail and attachmentContent not null
            String custOutCodeEmail3 = 'otherCase';
            String result3 = SendEmailController.sendEmail(toAddress, toCCAddress, bodyEmail, toAttachment, custOutCodeEmail3, CustomerName);
            System.assertNotEquals(null, result3);

            // Test with a different value of CustOutCodeEmail and attachmentContent is null
            String custOutCodeEmail4 = 'caseWithNullAttachment';
            String result4 = SendEmailController.sendEmail(toAddress, toCCAddress, bodyEmail, '[]', custOutCodeEmail4, CustomerName);
            System.assertNotEquals(null, result4);

            // Test with a different value of CustOutCodeEmail and attachmentContent not null
            String custOutCodeEmail5 = 'caseWithAttachment';
            String result5 = SendEmailController.sendEmail(toAddress, toCCAddress, bodyEmail, toAttachment, custOutCodeEmail5, CustomerName);
            System.assertNotEquals(null, result5);
        }
        Test.stopTest();
    }

    @isTest
    static void testAttachmentRetrievalMethod() {
        // Set up test data
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'TestAttachment',
            VersionData = Blob.valueOf('Test attachment content'),
            PathOnClient = 'TestAttachment.txt'
        );
        insert testContentVersion;

        // Call the method under test with a valid ContentVersionId
        Blob attachmentContent = SendEmailController.YourAttachmentRetrievalMethod(testContentVersion.Id);
        System.assertNotEquals(null, attachmentContent);
        System.assertEquals('Test attachment content', attachmentContent.toString());

        // Call the method under test with an invalid ContentVersionId
        Blob nullAttachmentContent = SendEmailController.YourAttachmentRetrievalMethod('invalidId');
        System.assertEquals(null, nullAttachmentContent);
    }
}