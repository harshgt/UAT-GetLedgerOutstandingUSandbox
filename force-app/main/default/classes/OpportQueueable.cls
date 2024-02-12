public class OpportQueueable implements Queueable, Database.AllowsCallouts {
    private List<Opportunity> opportunities;
  
    public OpportQueueable(List<Opportunity> opportunities) {
        this.opportunities = opportunities;
    }

public void execute(QueueableContext qc) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for (Opportunity opp : this.opportunities) {
            try {
                // Your authentication logic (consider using Named Credentials or Custom Metadata)
            Authorization__c customSetting  = Authorization__c.getInstance();
            String Username = customSetting.Username__c;
            String Password = customSetting.Password__c;
            String OpportunityCreationURL = customSetting.OpportunityCreationURL__c;
                
               
               
                // Create request
                HttpRequest req = new HttpRequest();
                req.setEndpoint(OpportunityCreationURL);
                req.setMethod('POST');
               // req.setTimeout(30000);
                system.debug(req);
                req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(Username + ':' + Password)));

                // Create XML body
                Dom.Document doc = new Dom.Document();
                Dom.XmlNode root = doc.createRootElement('ID', null, null);
                Dom.XmlNode IDroot = root.addChildElement('IDchild', null, null);
                IDroot.addChildElement('Id', null, null).addTextnode(opp.Id);
                String XmlBody = doc.toXmlString();
                
                req.setBody(XmlBody);

                System.debug(XmlBody);
                
                
                
                // Send request
                HttpResponse res = new Http().send(req);
               // system.debug('Response timeout =>'+res);
                System.debug('Response body: ' + res.getBody());
                System.debug('Response res: ' + res);

                // Handle response
                if (res.getStatusCode() == 201) {
                    Dom.Document doc2 = res.getBodyDocument();
                    for (Dom.XmlNode node : doc2.getRootElement().getChildElements()) {
                        for (Dom.XmlNode node2 : node.getChildElements()) {
                            if (node2.getName() == 'SalesQuotation') {
                                opp.SAP_Quotation_Order_No__c = Integer.valueOf(node2.getText());
                                opp.Error_Response__c = null;
                               //OpportunityTriggerHandlerUpdate.triggerHasRun = true;
                            }
                        }
                    }
                } else if(res.getStatusCode() == 200){
                    system.debug(res.getStatusCode());
                    opp.Error_Response__c = 'Error 500';
                    OpportunityTriggerHandlerUpdate.triggerHasRun = true;
                }
                else {
                    // Parse the XML string into a Dom.Document
                    Dom.Document doc1 = new Dom.Document();
                    doc1.load(res.getBody());

                    // Find the <message> element and extract its content
                    String messageContent = '';
                    Dom.XmlNode rootNode = doc1.getRootElement();
                    for (Dom.XmlNode childNode : rootNode.getChildElements()) {
                        if (childNode.getName() == 'message') {
                            messageContent = childNode.getText();
                            opp.Error_Response__c = messageContent;
                            OpportunityTriggerHandlerUpdate.triggerHasRun = true;
                        }else{
                            opp.Error_Response__c = 'Error 500';
                    		OpportunityTriggerHandlerUpdate.triggerHasRun = true;
                        }
                    }
                }

                opportunitiesToUpdate.add(opp);
            } catch (Exception e) {
                opp.Error_Response__c = '404 Authorization Error ' + e.getMessage();
                System.debug(e.getMessage()); 
                OpportunityTriggerHandlerUpdate.triggerHasRun = true;
            }
        }

        // Update all opportunities in a single DML statement
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }
}