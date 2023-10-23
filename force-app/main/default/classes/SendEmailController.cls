public with sharing class SendEmailController {
    @AuraEnabled
    public static String sendEmail(List<String> toAddress,List<String> toCCAddress, String toAttachment) { 
        // Create a new SingleEmailMessage object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //system.debug(replyTos);
        //system.debug(senderNames);  

        // Set the recipient's email address
        mail.setReplyTo('harshgthakare@gmail.com'); // change it with your mail address.
        mail.setSenderDisplayName('salesforce test User'); 
        
        system.debug(toAddress);
       // Create an email attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('demo.pdf'); // Set the attachment file name
        attachment.setBody(EncodingUtil.base64Decode(toAttachment)); // Convert base64 to Blob

        // Add the attachment to the email
        mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});   
        
          
        mail.setToAddresses(toAddress );

        if(toCCAddress != NULL && toCCAddress.isEmpty()){
             mail.setccAddresses(toCCAddress);
        }
       

        // Set the email subject
        mail.setSubject('Showing Outstanding data...! for Contact <strong> HARSHAL </strong>');
       mail.setHtmlBody(' <p>thank You!<br>SHYAM GT 10 </p>');
     
         //mail.setTemplateId('00X5j0000032nsNEAQ');
        mail.setSaveAsActivity(true);


        // Send the email using the Messaging.sendEmail method
        try {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.Email> { mail });
              
             system.debug(results);
             return 'true';
        } catch (EmailException e) {
            system.debug('EmailException: ' + e.getMessage());
            //system.debug('EmailException: ' + e.);
            return e.getMessage(); // Email sending failed
        }


    }
}