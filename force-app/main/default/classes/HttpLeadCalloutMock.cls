@isTest
global class HttpLeadCalloutMock implements HttpCalloutMock {
    private Integer statusCode;

    public HttpLeadCalloutMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setStatusCode(statusCode);

        if (req.getMethod() == 'POST' && req.getEndpoint().endsWith('/create/salesquote/S4hana')) {
            // Check the request URL and respond accordingly
            if (statusCode == 201) {
                // Simulate a successful response
                res.setBody('<Response>' +
                    '<A_CustSalesPartnerFunc>' +
                        '<A_CustSalesPartnerFuncType>' +
                            '<PartnerCounter>0</PartnerCounter>' +
                            '<PersonnelNumber>0</PersonnelNumber>' +
                            '<Customer>21001114</Customer>' +
                            '<DistributionChannel>11</DistributionChannel>' +
                            '<SalesOrganization>1001</SalesOrganization>' +
                            '<BPCustomerNumber>26001552</BPCustomerNumber>' +
                            '<ContactPerson>0</ContactPerson>' +
                            '<CustomerPartnerDescription></CustomerPartnerDescription>' +
                            '<PartnerFunction>Z3</PartnerFunction>' +
                            '<AuthorizationGroup></AuthorizationGroup>' +
                            '<Division>11</Division>' +
                            '<Supplier></Supplier>' +
                            '<DefaultPartner>false</DefaultPartner>' +
                        '</A_CustSalesPartnerFuncType>' +
                    '</A_CustSalesPartnerFunc>' +
                    '<A_Addressid>' +
                        '<BPAddressid>37595</BPAddressid>' +
                        '<CPAddressId>37598</CPAddressId>' +
                    '</A_Addressid>' +
                '</Response>');
            } else {
                // Simulate an error response
                res.setBody('<root><message>Error message</message></root>');
            }

            // Debug the status code and response body
            system.debug('Response status code: ' + res.getStatusCode());
            system.debug('Response body: ' + res.getBody());

            return res;
        }

        // Default response for unmatched endpoint
        res.setBody('<?xml version="1.0" encoding="utf-8"?><error xmlns="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"><code>AM/215</code><message xml:lang="en">Region 09 is not defined for IQ.</message><innererror><application><component_id>LO-MD-BP</component_id><service_namespace>/SAP/</service_namespace><service_id>API_BUSINESS_PARTNER</service_id><service_version>0001</service_version></application><transactionid>68c1d4df99f7464f9eb878f598890872</transactionid><timestamp/><Error_Resolution><SAP_Transaction/><SAP_Note>See SAP Note 1797736 for error analysis (https://service.sap.com/sap/support/notes/1797736)</SAP_Note></Error_Resolution><errordetails><errordetail><ContentID/><code>AM/215</code><message>Region 09 is not defined for IQ.</message><longtext_url>/sap/opu/odata/iwbep/message_text;o=LOCAL/</longtext_url><propertyref/><severity>error</severity><target/><transition>false</transition></errordetail></errordetails></innererror></error>');

        // Debug the status code and response body
        system.debug('Response status code: ' + res.getStatusCode());
        system.debug('Response body: ' + res.getBody());

        return res;
    }
}