@isTest
global class OpportHttpCalloutMock implements HttpCalloutMock {
    private Integer statusCode;

    public OpportHttpCalloutMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setStatusCode(statusCode);

        try {
        if (req.getMethod() == 'POST' && req.getEndpoint().endsWith('/create/salesquote/S4hana')) {
            // Check the request URL and respond accordingly
            if (statusCode == 201) {
                // Simulate a successful response
                res.setBody(''
                        + '<A_SalesQuotation>'
                        + '  <A_SalesQuotationType>'
                        + '    <CreationDate/>'
                        + '    <CreatedByUser></CreatedByUser>'
                        + '    <SalesDistrict>000001</SalesDistrict>'
                        + '    <TransactionCurrency>INR</TransactionCurrency>'
                        + '    <CustomerPurchaseOrderDate>2023-11-30T00:00:00.000</CustomerPurchaseOrderDate>'
                        + '    <BindingPeriodValidityStartDate>2023-11-30T00:00:00.000</BindingPeriodValidityStartDate>'
                        + '    <PriceListType></PriceListType>'
                        + '    <ShippingCondition>01</ShippingCondition>'
                        + '    <IncotermsTransferLocation>Nagpur</IncotermsTransferLocation>'
                        + '    <IncotermsVersion></IncotermsVersion>'
                        + '    <SalesQuotation>2020000357</SalesQuotation>'
                        + '    <to_Partner/>'
                        + '    <HeaderBillingBlockReason></HeaderBillingBlockReason>'
                        + '    <SalesGroup>010</SalesGroup>'
                        + '    <CustomerTaxClassification3></CustomerTaxClassification3>'
                        + '    <CustomerTaxClassification4></CustomerTaxClassification4>'
                        + '    <CustomerTaxClassification5></CustomerTaxClassification5>'
                        + '    <ShippingType></ShippingType>'
                        + '    <CustomerTaxClassification6></CustomerTaxClassification6>'
                        + '    <CustomerTaxClassification7></CustomerTaxClassification7>'
                        + '    <DeliveryBlockReason></DeliveryBlockReason>'
                        + '    <CustomerTaxClassification8></CustomerTaxClassification8>'
                        + '    <OrganizationDivision>11</OrganizationDivision>'
                        + '    <CustomerTaxClassification9></CustomerTaxClassification9>'
                        + '    <ReferenceSDDocumentCategory></ReferenceSDDocumentCategory>'
                        + '    <SalesDocApprovalStatus></SalesDocApprovalStatus>'
                        + '    <IncotermsClassification>CFR</IncotermsClassification>'
                        + '    <TotalCreditCheckStatus></TotalCreditCheckStatus>'
                        + '    <PricingDate>2023-11-30T00:00:00.000</PricingDate>'
                        + '    <ExpectedOrderNetAmount>0.00</ExpectedOrderNetAmount>'
                        + '    <SalesQuotationDate>2023-11-30T00:00:00.000</SalesQuotationDate>'
                        + '    <PaymentMethod></PaymentMethod>'
                        + '    <CustomerPriceGroup>01</CustomerPriceGroup>'
                        + '    <DistributionChannel>11</DistributionChannel>'
                        + '    <OverallSDProcessStatus></OverallSDProcessStatus>'
                        + '    <SoldToParty>21000963</SoldToParty>'
                        + '    <TotalNetAmount>-16560.00</TotalNetAmount>'
                        + '    <OverallSDDocumentRejectionSts></OverallSDDocumentRejectionSts>'
                        + '    <SalesQuotationType>Z202</SalesQuotationType>'
                        + '    <CompleteDeliveryIsDefined>false</CompleteDeliveryIsDefined>'
                        + '    <CustomerTaxClassification1></CustomerTaxClassification1>'
                        + '    <CustomerTaxClassification2></CustomerTaxClassification2>'
                        + '    <IncotermsLocation2></IncotermsLocation2>'
                        + '    <IncotermsLocation1>Nagpur</IncotermsLocation1>'
                        + '    <PurchaseOrderByCustomer>Email</PurchaseOrderByCustomer>'
                        + '    <HdrOrderProbabilityInPercent>0</HdrOrderProbabilityInPercent>'
                        + '    <SalesOrganization>1001</SalesOrganization>'
                        + '    <to_Item/>'
                        + '    <SalesOffice>1001</SalesOffice>'
                        + '    <CustomerPurchaseOrderType></CustomerPurchaseOrderType>'
                        + '    <SalesQuotationApprovalReason></SalesQuotationApprovalReason>'
                        + '    <CustomerPaymentTerms>C002</CustomerPaymentTerms>'
                        + '    <ReferenceSDDocument></ReferenceSDDocument>'
                        + '    <LastChangeDate/>'
                        + '    <SDDocumentReason>502</SDDocumentReason>'
                        + '    <RequestedDeliveryDate>2023-11-30T00:00:00.000</RequestedDeliveryDate>'
                        + '    <LastChangeDateTime>2023-11-30T05:33:26.214</LastChangeDateTime>'
                        + '    <BindingPeriodValidityEndDate>2023-12-31T00:00:00.000</BindingPeriodValidityEndDate>'
                        + '  </A_SalesQuotationType>'
                        + '</A_SalesQuotation>'
                    );
            } else if(statusCode != 201) {
                // Simulate an error response
                res.setBody('<?xml version="1.0" encoding="utf-8"?><error xmlns="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"><code>CX_SD_SLS_INTEGRATION</code><message xml:lang="en">No customer master record exists for sold-to party 23232</message><innererror><application><component_id>SD-SLS-QUT</component_id><service_namespace>/SAP/</service_namespace><service_id>API_SALES_QUOTATION_SRV</service_id><service_version>0001</service_version></application><transactionid>0b6d9a45ea0e4239bba954cf1bcbeedc</transactionid><timestamp/><Error_Resolution><SAP_Transaction/><SAP_Note>See SAP Note 1797736 for error analysis (https://service.sap.com/sap/support/notes/1797736)</SAP_Note></Error_Resolution><errordetails><errordetail><ContentID/><code>CX_SD_SLS_INTEGRATION</code><message>No customer master record exists for sold-to party 23232</message><propertyref/><severity>error</severity><target/><transition>false</transition></errordetail><errordetail><ContentID/><code>/IWBEP/CX_MGW_BUSI_EXCEPTION</code><message>An exception was raised</message><propertyref/><severity>error</severity><target/><transition>false</transition></errordetail></errordetails></innererror></error>');
            }

            

           
        }else {
                // Simulate an error response
                res.setBody('<!doctype html><html lang="en"><head><title>HTTP Status 404 – Not Found</title><style type="text/css">body {font-family:Tahoma,Arial,sans-serif;} h1, h2, h3, b {color:white;background-color:#525D76;} h1 {font-size:22px;} h2 {font-size:16px;} h3 {font-size:14px;} p {font-size:12px;} a {color:black;} .line {height:1px;background-color:#525D76;border:none;}</style></head><body><h1>HTTP Status 404 – Not Found</h1></body></html>');
            }
        } catch (Exception e) {
            // Handle exceptions here
            System.debug('Exception caught: ' + e.getMessage());
            // You can choose to set a different response or rethrow the exception if needed
            res.setStatusCode(500);
            res.setBody('Internal Server Error');
        }
 		return res;
        
    }
}