public with sharing class SendEmailController { 
    @AuraEnabled    
    public static String sendEmail(List<String> toAddress,List<String> toCCAddress,String BodyEmail, String toAttachment, String CustOutCodeEmail){ 
        //List<Object> attachmentList = (List<Object>) JSON.deserializeUntyped(toAttachment);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        User requestCurrentUser = [SELECT Id, Email, Name, ProfileId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        Datetime currentDateTime = Datetime.now();
        String formattedDate = currentDateTime.format('MMM yyyy');

        mail.setReplyTo(requestCurrentUser.Email);
        mail.setSenderDisplayName(requestCurrentUser.Name);
        mail.setToAddresses(toAddress);
        
        if (toCCAddress != null && !toCCAddress.isEmpty()) {
            mail.setCcAddresses(toCCAddress);
        } 

        // Check if there are attachments  
        if (String.isNotBlank(toAttachment)) { 
            List<Object> attachmentList = (List<Object>) JSON.deserializeUntyped(toAttachment);
            List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();

            for (Object attachmentData : attachmentList) {
                Map<String, Object> attachmentMap = (Map<String, Object>) attachmentData;
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

            // Add attachments to the email
            if (!emailAttachments.isEmpty()) {
                mail.setFileAttachments(emailAttachments);
            }
        }




        
        if(CustOutCodeEmail == 'oustanding'){
            mail.setSubject('Overdue reminder-'+formattedDate);
            String Disclaimers = '<span style="color: red;">Disclaimer : Disclaimer at the end of the ledger for any clarification, please contact us.</span>';
        
            mail.setHtmlBody('Dear Sir, <br/><br/> Please find the below overdue as of today. You are requested to release the same at the earliest.<br/><br/>' + BodyEmail + ' <p><br/> Regards,<br/>'+ requestCurrentUser.Name +' <br/><br/><br/><br/> '+ Disclaimers +'</p>'  );
        }
        else if(CustOutCodeEmail == 'ledger'){
            mail.setSubject('Showing ledger...! ');
            String Disclaimers1 = '<span style="color: red;">Disclaimer : Disclaimer at the end of the outstanding for any clarification, please contact us.</span>';
        
            mail.setHtmlBody('Dear Sir,  <br/><br/>' + BodyEmail + ' <p>thank You!<br/> <br/> Regards,<br/>'+ requestCurrentUser.Name +' <br/><br/><br/><br/> '+ Disclaimers1 +'</p>'  );
        } 
        
        
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