public with sharing class GetContactController {
    @AuraEnabled(cacheable=true)
    public static List<String> getEmailsForAccount(String accountId) {
        List<String> emailList = new List<String>();
        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE AccountId = :accountId LIMIT 10];
        
        for (Contact contact : contacts) {
            if (contact.Email != null) {
                emailList.add(contact.Email);
            }
        }

        return emailList;
    }
}