@isTest
public class ContactNewHtPClassMk implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a mock response with the desired status code and body
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setStatusCode(201);
        //res.setBody('<Response><A_CustSalesPartnerFunc>...</A_CustSalesPartnerFunc></Response>');
       res.setBody('<Response>' +
    '<A_CustSalesPartnerFunc>' +
        '<A_CustSalesPartnerFuncType>' +
            '<PartnerCounter>0</PartnerCounter>' +
            '<PersonnelNumber>0</PersonnelNumber>' +
            '<Customer>21001057</Customer>' +
            '<DistributionChannel>11</DistributionChannel>' +
            '<SalesOrganization>1001</SalesOrganization>' +
            '<BPCustomerNumber>26001544</BPCustomerNumber>' +
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
        '<CPAddressId>37556</CPAddressId>' +
    '</A_Addressid>' +
'</Response>');

        return res;
    }
}