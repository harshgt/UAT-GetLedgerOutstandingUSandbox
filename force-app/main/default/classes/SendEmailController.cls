public with sharing class SendEmailController { 
    
    //public static String sendEmail(List<String> toAddress,List<String> toCCAddress, String toAttachment) { 
        @AuraEnabled    
        public static String sendEmail(List<String> toAddress,List<String> toCCAddress,String BodyEmail, String toAttachment, String CurrentUser, String CurrentUserNa){ //String recipientEmail, String emailSubject
            List<Object> attachmentList = (List<Object>) JSON.deserializeUntyped(toAttachment);
            ///system.debug('senderEmail is '+replyEmail);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // Get the email address of the currently logged in user
             /* User currentUser = [SELECT Email,Name, Username FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            String senderEmail = currentUser.Email;
            String SenderDisplayName = currentUser.Name;
            //system.debug('senderEmail is '+senderEmail);  */

            mail.setReplyTo(CurrentUserNa);

            //system.debug('senderEmail is '+replyEmail);

            //mail.setReplyTo('harshal.thakare@sapours.net.in.brilliant.briuat');
            mail.setSenderDisplayName(CurrentUser);
            
            mail.setToAddresses(toAddress);
            
            if (toCCAddress != null && !toCCAddress.isEmpty()) {
                mail.setCcAddresses(toCCAddress);
            }
            
            List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
            
            for (Object attachmentData : attachmentList) {
                Map<String, Object> attachmentMap = (Map<String, Object>)attachmentData;
                String fileName = String.valueOf(attachmentMap.get('name'));
                String contentVersionId = String.valueOf(attachmentMap.get('contentVersionId'));
                String mimeType = String.valueOf(attachmentMap.get('mimeType'));
                
                // Fetch the attachment content based on contentVersionId
                Blob attachmentContent = YourAttachmentRetrievalMethod(contentVersionId);
                
                if (attachmentContent != null) {
                    // Create EmailFileAttachment
                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setFileName(fileName);
                    attachment.setBody(attachmentContent);
                    attachment.setContentType(mimeType);
                    emailAttachments.add(attachment);
                }
            }
            
            mail.setFileAttachments(emailAttachments);
            mail.setSubject('Showing Ledger data...! ');
            mail.setHtmlBody('Hello, </br></br>' + BodyEmail + ' <p>thank You!<br>Harshal Thakare</p>');
            mail.setSaveAsActivity(true);
            
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.Email> { mail });
                return 'true';
            } catch (EmailException e) {
                return e.getMessage();
            }
        }
        
        // Implement a method to retrieve attachment content based on contentVersionId
        public static Blob YourAttachmentRetrievalMethod(String contentVersionId) {
            ContentVersion contentVersion = [SELECT VersionData FROM ContentVersion WHERE Id = :contentVersionId LIMIT 1];
            
            if (contentVersion != null && contentVersion.VersionData != null) {
                // Retrieve and return the content data as a Blob
                return contentVersion.VersionData;
            } else {
                // Return null if the content cannot be retrieved
                return null;
            }
        }
    }