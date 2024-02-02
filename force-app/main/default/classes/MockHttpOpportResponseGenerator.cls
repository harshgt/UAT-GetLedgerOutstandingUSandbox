@isTest
global class MockHttpOpportResponseGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Create a mock response with the desired status code and body
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        // Set the status code based on your requirements
        res.setStatusCode(200);
        
        // Set the body of the response
        res.setBody('{"status": "success", "message": "Mock response"}');
        
        return res;
    }
}