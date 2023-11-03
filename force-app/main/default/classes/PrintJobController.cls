public with sharing class PrintJobController { 
    public String pdfData { get; set; }
    
    public PrintJobController() {
        // Call the Apex method and populate the data
        List<String> pageString = getPDFprint(new List<String>());
        pdfData = String.join(pageString, '<br/>');
    }

    @AuraEnabled
    public static List<String> getPDFprint(List<String> dataList){
        List<String> pageString = new List<String>();
        PageReference pdfPage = page.gereratePdf;
        Blob pdfBlob = pdfPage.getContent();
        String downloadURL = EncodingUtil.base64Encode(pdfBlob);
        
        pageString.add(downloadURL);
        pageString.add(pdfPage.getUrl());
        return pageString;

    }
    
}