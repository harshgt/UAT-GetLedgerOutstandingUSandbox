public class ContactUpdater implements  Queueable, Database.AllowsCallouts {
    private List<Id> contactIds;
    
    public ContactUpdater(List<Id> ids) {
        contactIds = ids;
    }
    
    public void execute(QueueableContext context) {
        // Call the future method to update Contacts
        //ContactUpdater.updateContacts(contactIds);
        
        List<Contact> conListToUpdate = new List<Contact>();
        String SAPAddressId;
        String CustomerId;
        for (Id contactId : contactIds) {
            // Retrieve the Contact record
            Contact con = [SELECT Id, SAPId__c FROM Contact WHERE Id = :contactId LIMIT 1];
            system.debug(con.Id);
            // Create an HTTP request and make the callout
            Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;
            String RelatedContactCreationURL  = customSetting.RelatedContactCreationURL__c ;
            
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(RelatedContactCreationURL);
            req.setMethod('POST'); 
            
            
            Blob headerValue = Blob.valueOf(Username + ':' + Password);        
            String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('authorization', authorizationHeader);
            
            Dom.Document doc = new Dom.Document();
            
            Dom.XmlNode root = doc.createRootElement('ID', null, null);
            
            // Create A_BusinessPartnerType element
            Dom.XmlNode IDroot = root.addChildElement('IDchild', null, null).addTextnode(con.Id);
            
            
            String XmlBody = doc.toXmlString();
            System.debug(XmlBody);
            
            //Adding Body to request
            req.setBody(XmlBody);
            System.debug(XmlBody);
            
            
            HttpResponse res = http.send(req);
            
            try{
                
                
                System.debug(res.getBody());
                System.debug(res.getStatus());
                System.debug(res.getStatusCode());
                
                if(res.getStatusCode() == 201)
                {
                    Dom.Document doc2 = res.getBodyDocument();
                    
                    for(Dom.XmlNode node : doc2.getRootElement().getChildElements())
                    {
                        if(node.getName() == 'A_Addressid')
                        {
                            for(Dom.XmlNode node2 : node.getChildElements())
                            {
                                if(node2.getName() == 'CPAddressId')
                                {
                                    System.debug(node2.getText());
                                    //con.CPAddressId__c = node2.getText();
                                    
                                    SAPAddressId = node2.getText();
                                }
                            }
                            
                        }
                        for(Dom.XmlNode node2 : node.getChildElements())
                        {
                            
                            for(Dom.XmlNode node3 : node2.getChildElements())
                            {
                                if(node3.getName() == 'BPCustomerNumber')
                                {
                                    CustomerId = node3.getText();
                                    System.debug(node3.getText());
                                }
                                else
                                {
                                    System.debug('Node3 is incorrect');
                                    for(Dom.XmlNode node4 : node3.getChildElements())
                                    {
                                        System.debug(node4.getText());
                                    }
                                }   
                            } 
                        }
                    }
                    
                    
                    
                    con.CPAddressId__c = SAPAddressId;
                    con.SAPId__c = CustomerId;
                    conListToUpdate.add(con);
                }
                else{
                    System.debug('not changed');
                }
            }
            catch(Exception e){
                system.debug(e);
            }
        }
        
        
        // Update the Contact records
        if (!conListToUpdate.isEmpty()) {
            update conListToUpdate;
        }
    }
}