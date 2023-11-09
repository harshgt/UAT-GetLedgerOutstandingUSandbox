public class OpportQueueable implements Queueable, Database.AllowsCallouts {
    private List<Opportunity>opportunities;
    
    public OpportQueueable(List<Opportunity>opportunities){
        this.opportunities = opportunities;
        
    }
    
    public void execute(QueueableContext qc){
        
        for(Opportunity acct : this.opportunities ){
            try{ 
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/create/salesquote/S4hana');
                req.setMethod('POST');
                String username = 'harshal.thakare@sapours.net.in';        
                String password = '@Shyam004';            
                Blob headerValue = Blob.valueOf(username + ':' + password);        
                String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('authorization', authorizationHeader);
                
                Dom.Document doc = new Dom.Document();
                Dom.XmlNode root = doc.createRootElement('ID', null, null);
                
                Dom.XmlNode IDroot = root.addChildElement('IDchild', null, null);
                IDroot.addChildElement('Id', null, null).addTextnode(acct.Id);
                String XmlBody = doc.toXmlString();
                //System.debug(XmlBody);
                
                req.setBody(XmlBody);
                //System.debug(XmlBody);
                
                
                HttpResponse res = http.send(req);
                
                if(res.getStatusCode() == 201){
                    system.debug('Status Code '+ res.getStatusCode());
                    Dom.Document doc2 = res.getBodyDocument();
                    for(Dom.XmlNode node : doc2.getRootElement().getChildElements())
                    {
                        for(Dom.XmlNode node2 : node.getChildElements())
                        {
                            //System.debug(node2.getName());
                            if(node2.getName() == 'SalesQuotation')
                            {
                                
                                acct.SAP_Quotation_Order_No__c = Integer.valueOf(node2.getText());
                                acct.Error_Response__c = NULL;
                                //acct.Description = NULL;
                               
                            }
                        }
                    }
                    
                } //end of if
                else if(res.getStatusCode() != 201){
                    // Parse the XML string into a Dom.Document
                    Dom.Document doc1 = new Dom.Document();
                    doc1.load(res.getBody());
                    //System.debug(res.getBody());
                    // Find the <message> element and extract its content
                    String messageContent = '';
                    Dom.XmlNode rootNode = doc1.getRootElement();
                    for (Dom.XmlNode childNode : rootNode.getChildElements()) {
                        if (childNode.getName() == 'message') {
                            messageContent = childNode.getText();
                            system.debug('Erroe Message '+ messageContent);
                            acct.Error_Response__c = messageContent;
                            //acct.Description = messageContent;
                            OpportunityTriggerHandlerUpdate.triggerHasRun = true;
                            
                        }
                    }
                    
                   }            
            }catch(Exception e){
                acct.Error_Response__c = '404 Authorization Error '+e.getMessage();
                system.debug(e.getMessage());
                 OpportunityTriggerHandlerUpdate.triggerHasRun = true;
                //throw e;
            }
            
            
          
        }
        
        update this.opportunities;
        
           
    }
    
    
    
}