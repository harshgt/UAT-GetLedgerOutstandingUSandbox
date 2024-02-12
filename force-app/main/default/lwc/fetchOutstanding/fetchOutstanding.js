import { LightningElement,api,track,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerOutStandingData from '@salesforce/apex/customerOutStandingData.customerOutStandingData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import MY_STATIC_RESOURCE from '@salesforce/resourceUrl/email_template';
import sendEmailWithPDF from '@salesforce/apex/SendEmailController.sendEmail';
import { loadScript } from 'lightning/platformResourceLoader';
import JS_PDF from '@salesforce/resourceUrl/jsPDFLibrary';
import JS_PDF_AUTO_TABLE from '@salesforce/resourceUrl/jsPDFAutoTable';
import MY_LOGO from '@salesforce/resourceUrl/MyDomainLogo';
import MY_ADD from '@salesforce/resourceUrl/footerAddress';

import getEmailsForAccount from '@salesforce/apex/GetContactController.getEmailsForAccount';




// Define fields to fetch
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c', 'Account.Name', 'Account.Bill_To_Name__c', 'Account.Bill_To_Name2__c', 'Account.Currency__c'];


const columns = [
    
    { label: 'Customer Name', fieldName: 'CustName' },
    { label: 'Document Number', fieldName: 'Belnr' },
    { label: 'Document Date', fieldName: 'Bldat' },
    { label: 'Due Date', fieldName: 'netdt' },
    { label: 'Overdue Days', fieldName: 'OutDays' },
    { label: 'Aging', fieldName: 'Ageing' },
    { label: 'Invoice Amount LC ', fieldName: 'InvAmt' },
    { label: 'Remaining Amount IC ', fieldName: 'RemAmt' },

    /* { label: 'Document Type', fieldName: 'Blart' },
    { label: 'Reference Document No.', fieldName: 'Xblnr' }, 
    { label: 'Credit Period', fieldName: 'CreditP' }, */
    /* { label: 'Not Due', fieldName: 'IV_NOTDUE' }, */
    /* { label: 'Customer code', fieldName: 'IV_KUNNR' },    
    { label: 'REM_AMT_DC', fieldName: 'RemAmtDC' }, */
    /* { label: 'INV_AMT_DC', fieldName: 'InvAmtDc' }, */
    /* { label: 'OverDue', fieldName: 'IV_OVERDUE' }, */
    /* { label: 'company code', fieldName: 'IV_BUKRS' },  */
    /*  { label: 'PayTerms', fieldName: 'PayTerms' }, */
];

export default class FetchOutstanding extends LightningElement {
    @api recordId;
    @track currentDate;
    AccountSapId;
    CompanyCode;
    SelectedValueForType;
    @track isButtonDisabledForOutstd = true;
    data = [];
    isLoading = true;
    @track showNoRecordsMessage = false;
    columns = columns;
    AccountName;
    @track emailList = [];
    @track emailCCList = [];
    /* @track getEma; */
    attachmentData;
    @track uploadedFileNames = [];
    @track isShowModal = false;
    @track isShowModal1  = false;
    jsPDFInitialized = false;
    showSendButton = true;
    @track formattedData = '';
    BillToName;
    BillToName2;
    Currency;
    emails = '';

    Disclaimer = 'Disclaimer: For any queries please contact on collections@brilliantpolymers.com';


    
    hideModalBox() {  
        this.isShowModal = false;
        this.data = null;
        this.isLoading = true;    
    }
    
    hideModalBox1() {  
        this.isShowModal1 = false;   
        this.uploadedFileNames=[];
    }
    
    //use for outStanding radio button optios
    get options() {
        return [
            { label: 'Overdue', value: 'Overdue' },
            { label: 'No Due', value: 'No Due' },
            { label: 'Both', value: 'Both' },
        ];
    }
    
    
    handleToAddress(event) {
        const inputString = event.target.value;
        const emails = inputString.split(',').map(email => email.trim());
        this.emailList = emails;   
    }
    
    handleCCAddress(event) {
        const inputCCString = event.target.value;
        const CCemails = inputCCString.split(/[, ]+/).map(email => email.trim());
        this.emailCCList = CCemails;
    }


    
    
    
    
    handleRischText(event) {
        const inputrichText = event.target.value; 
        //const inputrichText1 = this.template.querySelector('lightning-input-rich-text').value;
        //this.getEma = inputrichText;
        this.formattedData = inputrichText;
    }
    
    get acceptedFormats() {
        return ['.png','.xlsx', '.xls', '.csv', '.png', '.doc', '.docx', '.pdf'];
    }
    
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        this.uploadedFileNames = uploadedFiles.map(file => file.name);
        this.attachmentData = uploadedFiles;
        //alert('files uploaded : ' + uploadedFiles.length);
    }

    //code for getting static resources file.
    /*async loadStaticResource() {
        try {
            const response = await fetch(MY_STATIC_RESOURCE);
            if (response.ok) {
                const htmlText = await response.text();
                //this.getEma = htmlText; 
                //console.log(this.getEma);
            } else {
                //console.error('Failed to fetch HTML content:', response.statusText);
            }
        } catch (error) {
            //console.error('Error loading HTML content:', error);
        }
    }*/
    
    //fetch data of Account using UIRecordAPI
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    accountRecord({ error, data }) {
        if (data) {
            this.AccountSapId = data.fields.SAP_Code__c.value;
            this.CompanyCode = data.fields.Company_Code__c.value;
            this.AccountName = data.fields.Name.value;
            this.BillToName= data.fields.Bill_To_Name__c.value;  
            this.BillToName2 = data.fields.Bill_To_Name2__c.value || '';
            this.Currency = data.fields.Currency__c.value || 'INR';
            this.updateColumnLabels();
        } else if (error) {
            console.error(error);
        }
    }


    @wire(getEmailsForAccount, { accountId: '$recordId' })
    wiredEmails({ error, data }) {
        if (data) {
            this.emails = data.join(', '); // Join emails with comma separation
            const emails =  this.emails.split(',').map(email => email.trim());
            this.emailList = emails;
            //console.log('show emails1 ', this.emailList);
            //console.log('show emails2 ', emails);
        } else if (error) {
            console.error('Error retrieving emails', error);
        }
    }




    updateColumnLabels() {
        const currencyLabel = this.Currency; // Default to 'INR' if not set
    
        this.columns = this.columns.map(column => {
            if(currencyLabel === 'INR'){
                if (column.fieldName === 'InvAmt') {
                    column.label = `Invoice Amount LC  (${currencyLabel})`;
                } else if (column.fieldName === 'RemAmt') {
                    column.label = `Remaining Amount IC (${currencyLabel})`;
                }
            }else if(currencyLabel === 'USDN'){
                if (column.fieldName === 'InvAmt') {
                    column.label = `Invoice Amount LC (${currencyLabel})`;
                } else if (column.fieldName === 'RemAmt') {
                    column.label = `Remaining Amount IC (${currencyLabel})`;
                }
            }
            else if(currencyLabel === 'EUR'){
                    if (column.fieldName === 'InvAmt') {
                        column.label = `Invoice Amount LC (${currencyLabel})`;
                    } else if (column.fieldName === 'RemAmt') {
                        column.label = `Remaining Amount IC (${currencyLabel})`;
                    }
                }
                
            
            
            // Add more conditions for other columns as needed
            return column;
        });
    }
    
    
    
    
    //to get the current date
    connectedCallback() {
        //this.loadContactData();
        //this.loadStaticResource();
        const today = new Date();
        const day = String(today.getDate()).padStart(2, '0');
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const year = today.getFullYear();
        this.currentDate = `${day}/${month}/${year}`; // Corrected the date format to YYYY-MM-DD `${year}-${month}-${day}`   
    }   
    
    //get the selected radio Type Value
    selectedTypeValueHandler(event){
        this.selectedTypeValue =event.target.value;
        this.SelectedValueForType = this.selectedTypeValue;
        this.isButtonDisabledForOutstd = false;  
    }


    
    
    handleClickForOutStanding(){
        this.isShowModal = true;

        //this.logRelatedContacts();
        // check if any data is blank & show error message
        if(this.AccountSapId && this.CompanyCode){
            getCustomerOutStandingData({AccountSapId : this.AccountSapId, CompanyCode : this.CompanyCode, SelectedValueForType : this.SelectedValueForType  })
            .then(data => {
                //this.data = JSON.stringify(data);
                if (data && data.customer_detailsSet) {
                    const ledgerData = data.customer_detailsSet.customer_details;
                    
                    if (Array.isArray(ledgerData)) {
                        // If ledgerData is already an array, use it directly
                        this.data = ledgerData;
                        this.formattedData = this.formatDataAsTable();
                    } else if (ledgerData && typeof ledgerData === 'object') {
                        // If ledgerData is an object, convert it to an array
                        this.data = [ledgerData];
                        this.formattedData = this.formatDataAsTable();
                    } else {
                        // Handle other cases where data is missing or not in the expected format
                        this.data = [];
                    }
                    this.showNoRecordsMessage = this.data.length === 0;
                } else {
                    this.data = [];
                    this.showNoRecordsMessage = true;
                } 
                this.isLoading = false;   
            })
            .catch(error => {
                //console.log("hrllo"+JSON.stringify(error));
                this.isLoading = true;
                this.showToast('Error '+ error.status, error.body.message , 'error');
                this.isShowModal = false;
            }); 
        }
        else{
            //console.log("this.AccountSapId && this.CompanyCode" + this.AccountSapId + ' '+  this.CompanyCode);
            this.showToast('Error', 'SAP Code and Company Code is Mandatory!!!', 'error');
            this.isLoading = true;
            this.data = null;
            this.isShowModal = false;
        }
    }



    /* logRelatedContacts() {
        getContactForAccount({ accountId: this.recordId })
            .then(contactData => {
                if (contactData) {
                    console.log('Related Contacts:', contactData);
                    this.relatedContacts = contactData;
                }
            })
            .catch(error => {
                console.error('Error fetching related contacts:', error);
            });
    } */
     
    // Function to show toast notifications
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
 
    columnHeader = ['Customer Name','Document Number','Document Date','Due Date', 'Overdue Days', 'Aging','Invoice Amount LC','Remaining Amount IC'];
    //columnHeader = ['Customer Name','Document Number.','Document Date','Document Type','Reference Document No.','Credit Period','Outstanding Days','Aging','Invoice Amount','Remaining Amount'];
    exportContactData(){


        let totalInvoiceAmt1 = 0;
        let totalRemainingAmt1 = 0;
        const currencyLabel1 = this.Currency; // Default to 'INR' if not set

    
        this.columnHeader1 = this.columnHeader.map(columnHead => {
            if(currencyLabel1 === 'INR'){
                if (columnHead === 'Invoice Amount LC') {
                    return `Invoice Amount LC (${currencyLabel1})`;
                } else if (columnHead === 'Remaining Amount IC') {
                    return `Remaining Amount IC (${currencyLabel1})`;
                }
            }
            else if(currencyLabel1 === 'USDN'){
                if (columnHead === 'Invoice Amount LC') {
                    return `Invoice Amount LC (${currencyLabel1})`;
                } else if (columnHead === 'Remaining Amount IC') {
                    return `Remaining Amount IC (${currencyLabel1})`;
                }
            }
            else if(currencyLabel1 === 'EUR'){
                if (columnHead === 'Invoice Amount LC') {
                    return `Invoice Amount LC (${currencyLabel1})`;
                } else if (columnHead === 'Remaining Amount IC') {
                    return `Remaining Amount IC (${currencyLabel1})`;
                }
            }
            return columnHead;
        });





        // Prepare a html table
        let doc = '';
        
        // Add content at the top of the Excel sheet
        doc += '<h1>Outstanding Data</h1>';
        doc += '<p>Customer Name : '+this.BillToName+ ' '+ this.BillToName2 + '</p>';
        doc += '<p>SAP Code : '+this.AccountSapId+ '</p>'; 
        doc += '<p>Type : '+this.SelectedValueForType+ '</p>'; 
        doc += '<p>Date : '+this.currentDate+ '</p>';

        // Start the HTML table
        doc += '<table>';
        // Add styles for the table
        doc += '<style>';
        doc += 'table, th, td {';
        doc += '    border: 1px solid black;';
        doc += '    border-collapse: collapse;';
        doc += '}';          
        doc += '</style>';
        // Add all the Table Headers
        doc += '<tr>';
        this.columnHeader1.forEach(element => {            
            doc += '<th>'+ element +'</th>'           
        });
        doc += '</tr>';

        // Add the data rows
        this.data.forEach(record => {
            doc += '<tr>';
            /* doc += '<th>'+record.IV_NOTDUE+'</th>'; */
            doc += '<th>'+record.CustName+'</th>';
            doc += '<th>'+record.Belnr+'</th>';
            doc += '<th>'+record.Bldat+'</th>';
            doc += '<th>'+record.netdt+'</th>';
            doc += '<th>'+record.OutDays+'</th>';
            doc += '<th>'+record.Ageing+'</th>';
            doc += '<th>'+record.InvAmt+'</th>'; 
            doc += '<th>'+record.RemAmt+'</th>'; 
            /* doc += '<th>'+record.OutDays+'</th>'; */
            /*   doc += '<th>'+record.IV_BUKRS+'</th>';  */

            // Update the total debit and credit
            totalInvoiceAmt1 += parseFloat(record.InvAmt) || 0;
            totalRemainingAmt1 += parseFloat(record.RemAmt) || 0;

            doc += '</tr>';
        });


        doc += '<tr>';
            doc += '<th colspan="6">Total</th>'; 
            doc += '<th>'+ totalInvoiceAmt1 +'</th>'; 
            doc += '<th>'+ totalRemainingAmt1 +'</th>';
            
            doc += '</tr>';
        doc += '</table>';

        
        doc += '<br/><br/><br/> <span style="color: red;">' +this.Disclaimer+ '</span>';
        
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'OutstandingData.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
    
    renderedCallback() {
        if (!this.jsPDFInitialized) {
            this.jsPDFInitialized = true;
            loadScript(this, JS_PDF)
            .then(() => {
                console.log('jsPDF library loaded successfully');
                // Load jsPDF-AutoTable after jsPDF
                return loadScript(this, JS_PDF_AUTO_TABLE);
            })
            .then(() => {
                console.log('jsPDF-AutoTable library loaded successfully');
            })
            .catch((error) => {
                console.error('Error loading libraries', error);
            });
        }
    }
    

    //predefinedColumnHeaders = ['Customer Name', 'Document No.', 'Document Date', 'Document Type', 'Reference Document No.', 'Credit Period', 'Outstanding Days', 'Aging', 'Invoice Amount', 'Remaining Amount'];
    predefinedColumnHeaders = ['Customer Name', 'Document Number', 'Document Date', 'Due Date', 'Overdue Days', 'Aging', 'Invoice Amount LC', 'Remaining Amount IC'];
    
    modifyColumnHeader(columnHead, currencyLabel) {
    if (columnHead === 'Invoice Amount LC' || columnHead === 'Remaining Amount IC' ) {
        return `${columnHead} (${currencyLabel})`;
    }
    return columnHead;
} 

    handleGeneratePDF() {
        if (this.jsPDFInitialized) {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            const logoDataUrl = MY_LOGO ; 
            const img = new Image();
            img.src = logoDataUrl;
            img.onload = () => {
                const imageWidth = 60;
                const xCoordinate = (doc.internal.pageSize.getWidth() - imageWidth) / 2;
                doc.addImage(img, 'PNG', xCoordinate, 10, imageWidth, 20);

                doc.setFontSize(20);
                doc.setFont('times', 'bold');
                doc.text('Outstanding Account', doc.internal.pageSize.getWidth() / 2, 40, 'center');
                doc.setFont('times', 'normal');
                
                doc.setFontSize(12);
                doc.text('Customer Name : ' +this.BillToName+ ' '+ this.BillToName2 , 15, 55);
                doc.text('Account SAP Code : ' + this.AccountSapId, 15, 65);
                doc.text('Type : ' + this.SelectedValueForType, 15, 75);
                doc.text('Date : ' + this.currentDate, 15, 85);
    
                // Convert the JSON string back to an array of objects
                const outstandingData = this.data;
    
                const data = [];

                data.push(this.predefinedColumnHeaders.map(columnHead => this.modifyColumnHeader(columnHead, this.Currency)));
    
                //data.push(['Customer Name', 'Document No.', 'Document Date', 'Document Type', 'Reference Document No.', 'Credit Period', 'Outstanding Days', 'Aging', 'Invoice Amount', 'Remaining Amount']);
    

                let totalInvoiceAmt = 0;
                let totalRemainingAmt = 0;

                outstandingData.forEach(outData => {
                    data.push([outData.CustName, outData.Belnr, outData.Bldat, outData.netdt, outData.OutDays, outData.Ageing, outData.InvAmt, outData.RemAmt]);
                    //data.push([outData.CustName, outData.Belnr, outData.Bldat, outData.Blart, outData.Xblnr, outData.CreditP, outData.OutDays, outData.Ageing, outData.InvAmt, outData.RemAmt]);
                    totalInvoiceAmt += parseFloat(outData.InvAmt) || 0;
                    totalRemainingAmt += parseFloat(outData.RemAmt) || 0;
                });

                data.push(['', '', '', '', '','Total : ', totalInvoiceAmt.toFixed(2),totalRemainingAmt.toFixed(2)]);
    
                const tableOptions = {
                    head: [data[0]],
                    body: data.slice(1),
                    /* startY: 80,  */
                    styles: {
                        fontSize: 9, // Set the font size for the table
                        cellPadding: 2,
                        halign: 'center',

                    },
                    
                    bodyStyles: {
                        valign: 'middle', // Vertical alignment for the entire body middle
                    },
                };
                const pageSize = doc.internal.pageSize;
                const pageHeight = pageSize.height - 10; 
                let currentPage = 1;
                let startY = 90;

                for (let i = 1; i < data.length; i += 15) {
                    const tableData = data.slice(i, i + 15); 

                    if (currentPage > 1) {
                        doc.addPage();
                        startY = 20;
                    }

                    tableOptions.body = tableData;
                    tableOptions.startY = startY;

                    doc.autoTable(tableOptions);
                    //add Footer
                    const footerImage = MY_ADD; 
                    const imgWidth = 130; 
                    const imgHeight = 30; 

                    const imgX = (doc.internal.pageSize.getWidth() - imgWidth) / 2;
                    const imgY = doc.internal.pageSize.getHeight() - 30;
                    doc.addImage(footerImage, 'PNG', imgX, imgY, imgWidth, imgHeight);
                    currentPage++;
                }
                this.addDisclaimer(doc); 
                doc.save('outstanding_Data.pdf');
            };
        } else {
            console.error('jsPDF library not initialized');
        }
    }


    addDisclaimer(doc) {
        // Add disclaimer text
        doc.setTextColor(255, 0, 0);
        doc.setFontSize(8);
        doc.text(this.Disclaimer, 10, doc.internal.pageSize.getHeight() - 40);
        doc.setTextColor(0, 0, 0); 
    }
    
    showDataForEmail(){
        this.isShowModal1 = true;
        
        
    }
    
    sendEmailData1() {
        const attachm = JSON.stringify(this.attachmentData);
        const OutCodeEmails = 'oustanding';
        const CustomerName = this.BillToName+ ' '+ this.BillToName2;

        

        sendEmailWithPDF({toAddress: this.emailList, toCCAddress : this.emailCCList, BodyEmail : this.formattedData, toAttachment : attachm, CustCodeEmail : OutCodeEmails, CustomerName : CustomerName   }) 
        .then((data) => {
            // Show success toast notification
            if(data === 'true')
            {
                //console.log(data);
                this.showToast('Success', 'Email sent successfully', 'success');
                this.clearFields();    
            }  
            else
            {
                this.showToast('Error', data, 'error');
                //this.clearFields();    
            }  
        }).catch(error =>{
            //this.showToast('Error', error, 'error');
        })
        
    }
    
    clearFields(){ 
        this.isShowModal1 = false;
        this.uploadedFileNames = null;
        //this.attachm = null;
    }
    
    formatDataAsTable() {
        let tableHTML = '<table style="width: 50%; border: 1px solid black; border-collapse: collapse; "><tr>';
        
        // Mapping of field names to desired labels
        const fieldLabelMap = {
            'CustName': 'Customer Name',
            'Belnr': 'Document Number',
            'Bldat': 'Document Date',
            'netdt': 'Due Date',
            'OutDays': 'Overdue Days',
            'Ageing': 'Aging',
            'InvAmt': 'Invoice Amount LC',
            'RemAmt': 'Remaining Amount IC',
        };


        //const currencyLabel = this.Currency || 'INR'; // Default to 'INR' if not set

        // Apply the condition to modify column headers based on currency label
        const modifiedHeaders = Object.values(fieldLabelMap).map(columnHead => {
            if (columnHead === 'Invoice Amount LC' || columnHead === 'Remaining Amount IC') {
                return `${columnHead} (${this.Currency})`;
            }
            return columnHead;
        });
    
        // Adding modified column headers to the table using labels with custom color
        modifiedHeaders.forEach(modifiedHeader => {
            tableHTML += `<th style="border: 1px solid black; background-color: #3498db; font-size: 14px; padding: 12px; text-align: center; line-height: 18px; color: #ffffff;">${modifiedHeader}</th>`;
        });
    
        /* // Adding column headers to the table using labels with custom color
        Object.keys(fieldLabelMap).forEach(fieldName => {
            tableHTML += `<th style="border: 1px solid black; background-color: #3498db; font-size: 14px; padding: 12px; line-height: 18px; color: #ffffff;">${fieldLabelMap[fieldName]}</th>`;
        }); */
    
        tableHTML += '</tr>';
    
        let totalInvAmt = 0;
        let totalRemAmt = 0;
    
        // Iterate through customer_details array and add rows
        this.data.forEach(item => {
            tableHTML += '<tr>';
    
            // Iterate through columns and add corresponding values
            Object.keys(fieldLabelMap).forEach(fieldName => {
                const cellValue = item[fieldName];
                 // Adjust the width dynamically based on content
                const cellStyle = 'min-width: 100px;  text-align: center; white-space: nowrap;';                
                tableHTML += `<td style="border: 1px solid black; font-size: 12px; padding: 12px; line-height: 16px; ${cellStyle}">${cellValue}</td>`;

                // Calculate totals for 'InvAmt' and 'RemAmt'
                if (fieldName === 'InvAmt') {
                    totalInvAmt += parseFloat(cellValue) || 0;
                    
                } else if (fieldName === 'RemAmt') {
                    totalRemAmt += parseFloat(cellValue) || 0;
                   
                    
                }
            });
    
            tableHTML += '</tr>';
        });
    
        // Add a row for totals at the bottom
        /* tableHTML += `<tr><td colspan="${Object.keys(fieldLabelMap).length - 2}" style="border: 1px solid black; text-align: right;">Total Invoice Amount:</td><td style="border: 1px solid black;">${totalInvAmt.toFixed(2)}</td></tr>`;
        tableHTML += `<tr><td colspan="${Object.keys(fieldLabelMap).length - 2}" style="border: 1px solid black; text-align: right;">Total Remaining Amount:</td><td style="border: 1px solid black;">${totalRemAmt.toFixed(2)}</td></tr>`;
     */

        tableHTML += `<tr style="border: 1px solid black; font-weight: bold;  color: #ffffff; background-color: #3498db; font-size: 14px; padding: 12px; line-height: 18px;"><td colspan="${Object.keys(fieldLabelMap).length - 2}" style="border: 1px solid black; text-align: right; font-size: 14px; padding: 12px; line-height: 18px;  ">Total:</td><td style="border: 1px solid black; font-size: 14px; padding: 12px; line-height: 18px;">${totalInvAmt.toFixed(2)}</td>
                                          <td style="border: 1px solid black; font-size: 14px; padding: 12px; line-height: 18px; ">${totalRemAmt.toFixed(2)}</td></tr>`;
        

        tableHTML += '</table>';
        return tableHTML;
    }
    
}