@isTest
global class CustomerLedgerMockCls implements HttpCalloutMock {
    Integer statusCode;

    global CustomerLedgerMockCls(Integer strStatusCode){
        statusCode = strStatusCode;
    }

    global HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        
        // Set the body based on the status code
        if(statusCode == 200){
            res.setBody('{"status":"success","Cust_ledgerSet":{"Cust_ledger":[{"KUNNR":"0021000066","CREDIT":"","IV_KUNNR":"","IV_FRM_DATE":"","BLDAT":"2023-05-01T00:00:00.000","CLSBAL":"3000000.00","BUDAT":"2023-05-01T00:00:00.000","BELNR":"10900078","SGTXT":"text","LTEXT":"Customer Invoice","XBLNR":"","DEBIT":"3200000.00","KWERT":"0","IV_BUKRS":"1000","ZADDRESS":"","IV_FRM_TO":"","IV_PRCTR":"","BLART":"DR"}]}}');
        } else {
            res.setBody('{"status":"error","message":"Some error message"}');
        }

        res.setStatusCode(statusCode);
        return res;
    }
}