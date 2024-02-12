@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    Integer statusCode;

    global MockHttpResponseGenerator(Integer strStatusCode){
        statusCode = strStatusCode;
    }

    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        
        // Set the body based on the status code
        if(statusCode == 200){
            res.setBody('{"customer_detailsSet":{"customer_details":[{"IV_NOTDUE":"","Xblnr":"EMAIL","InvAmt":"368561.00","RemAmt":"368561.00","IV_KUNNR":"21000152","Ageing":"61-90","Blart":"RV","RemAmtDC":"368561.00","InvAmtDc":"368561.00","CustName":"Akshay Polypacks","IV_OVERDUE":"","OutDays":"81","IV_BUKRS":"","Bldat":"2023-07-12","PayTerms":"","Belnr":"9131001393","CreditP":"60"}]}}');
        } else {
            res.setBody('{"status":"error","message":"Some error message"}');
        }

        res.setStatusCode(statusCode);
        return res;
    }
}