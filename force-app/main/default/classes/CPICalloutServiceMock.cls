// Mock class to simulate HTTP callout responses
@isTest
global class CPICalloutServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        request = req;
        HttpResponse res = new HttpResponse();
        res.setStatusCode(201);
        res.setBody('<batchPartResponse>'
                    +'<batchChangeSetResponse>'
                + '<batchChangeSetPartResponse>'
                    + '<headers>'
                        + '<Accept></Accept>'
                        + '<Accept-Language></Accept-Language>'
                        + '<Content-Length>0</Content-Length>'
                        + '<dataserviceversion>2.0</dataserviceversion>'
                    + '</headers>'
                    + '<statusInfo>No Content</statusInfo>'
                    + '<contentId/>'
                    + '<body/>'
                    + '<statusCode>204</statusCode>'
                + '</batchChangeSetPartResponse>'
            + '</batchChangeSetResponse>'
            + '</batchPartResponse>');
        return res;
    }

    // Static variables to store request and response for assertions
    @TestVisible private static HTTPRequest request;
    @TestVisible private static HTTPResponse response;
}