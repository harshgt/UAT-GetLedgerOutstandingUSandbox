@isTest
global class OpportHttpCalloutMockError implements HttpCalloutMock {
    private Integer statusCode;
   

    public OpportHttpCalloutMockError(Integer statusCode) {
        this.statusCode = statusCode;
        
    }

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake error response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setStatusCode(statusCode);

        // Simulate the error response body
        if (statusCode != 201) {
            res.setBody('<?xml version="1.0" encoding="utf-8"?><error xmlns="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"><code>CX_SD_SLS_INTEGRATION</code><message xml:lang="en">No customer master record exists for sold-to party 23232</message><innererror><application><component_id>SD-SLS-QUT</component_id><service_namespace>/SAP/</service_namespace><service_id>API_SALES_QUOTATION_SRV</service_id><service_version>0001</service_version></application><transactionid>0b6d9a45ea0e4239bba954cf1bcbeedc</transactionid><timestamp/><Error_Resolution><SAP_Transaction/><SAP_Note>See SAP Note 1797736 for error analysis (https://service.sap.com/sap/support/notes/1797736)</SAP_Note></Error_Resolution><errordetails><errordetail><ContentID/><code>CX_SD_SLS_INTEGRATION</code><message>No customer master record exists for sold-to party 23232</message><propertyref/><severity>error</severity><target/><transition>false</transition></errordetail><errordetail><ContentID/><code>/IWBEP/CX_MGW_BUSI_EXCEPTION</code><message>An exception was raised</message><propertyref/><severity>error</severity><target/><transition>false</transition></errordetail></errordetails></innererror></error>');
        }
		//system.debug('responsesss '+res);
        return res;
    }
}