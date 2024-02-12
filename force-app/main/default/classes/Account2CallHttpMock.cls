@isTest
global class Account2CallHttpMock implements HttpCalloutMock {
    private Integer statusCode;

    public Account2CallHttpMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setStatusCode(statusCode);

        
            if (statusCode == 201) {
                // Simulate a successful response
                 res.setBody(
                '<batchPartResponse>' +
                    '<batchChangeSetResponse>' +
                        '<batchChangeSetPartResponse>' +
                            '<headers>' +
                                '<Accept></Accept>' +
                                '<Accept-Language></Accept-Language>' +
                                '<Content-Length>0</Content-Length>' +
                                '<dataserviceversion>2.0</dataserviceversion>' +
                            '</headers>' +
                            '<statusInfo>No Content</statusInfo>' +
                            '<contentId/>' +
                            '<body/>' +
                            '<statusCode>204</statusCode>' +
                        '</batchChangeSetPartResponse>' +
                        // Add more batchChangeSetPartResponse as needed
                    '</batchChangeSetResponse>' +
                '</batchPartResponse>'
            );
            } else if(statusCode != 201) {
                // Simulate an error response
                res.setBody(
                '<batchPartResponse>' +
                    '<batchChangeSetResponse>' +
                        '<batchChangeSetPartResponse>' +
                            '<headers>' +
                                '<Accept></Accept>' +
                                '<Accept-Language></Accept-Language>' +
                                '<Content-Length>0</Content-Length>' +
                                '<dataserviceversion>2.0</dataserviceversion>' +
                            '</headers>' +
                            '<statusInfo>No Content</statusInfo>' +
                            '<contentId/>' +
                            '<body/>' +
                            '<statusCode>204</statusCode>' +
                        '</batchChangeSetPartResponse>' +
                        '<batchChangeSetPartResponse>' +
                            '<headers>' +
                                '<Accept></Accept>' +
                                '<Accept-Language></Accept-Language>' +
                                '<Content-Length>0</Content-Length>' +
                                '<dataserviceversion>2.0</dataserviceversion>' +
                            '</headers>' +
                            '<statusInfo>No Content</statusInfo>' +
                            '<contentId/>' +
                            '<body/>' +
                            '<statusCode>204</statusCode>' +
                        '</batchChangeSetPartResponse>' +
                        // Add more batchChangeSetPartResponse as needed
                    '</batchChangeSetResponse>' +
                '</batchPartResponse>'
            );
            }
        	else if(statusCode == 204) {
                // Simulate an error response
                res.setBody('No Content');
            }
        	else {
                // Simulate an error response
                res.setBody('No Content');
            }

 		return res;
        
    }
}