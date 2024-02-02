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
        res.setBody('<root><message>Invalid endpoint</message></root>');

        // Debug the status code and response body
        system.debug('Response status code: ' + res.getStatusCode());
        system.debug('Response body: ' + res.getBody());

        return res;
    }
}