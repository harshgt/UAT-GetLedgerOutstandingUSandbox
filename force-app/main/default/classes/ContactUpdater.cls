public class ContactUpdater {
    @Future(callout=true)
    public static void updateContacts(List<Id> contactIds) {
        List<Contact> conListToUpdate = new List<Contact>();
        String SAPAddressId;
        String CustomerId;
        for (Id contactId : contactIds) {
            // Retrieve the Contact record
           Contact con = [SELECT Id, SAPId__c FROM Contact WHERE Id = :contactId LIMIT 1];
            system.debug(con.Id);
            // Create an HTTP request and make the callout
           	Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/add/cp/to/bp');
            req.setMethod('POST');
            
            String username = 'harshal.thakare@sapours.net.in';        
            String password = '@Shyam004';            
            Blob headerValue = Blob.valueOf(username + ':' + password);        
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
                                       //System.debug(node4.getText());
                                    }
                                }   
                            } 
                        }
                    }
                    
                    
                     
                    con.CPAddressId__c = SAPAddressId;
                    con.SAPId__c = CustomerId;
                    conListToUpdate.add(con);
       			 }
            }
        
        
        // Update the Contact records
        if (!conListToUpdate.isEmpty()) {
            update conListToUpdate;
        }
    }
}