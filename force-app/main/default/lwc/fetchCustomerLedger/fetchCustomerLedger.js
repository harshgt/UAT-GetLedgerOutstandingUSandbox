import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerLedgerData from '@salesforce/apex/customerLedgerData.customerLedgerData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendEmailWithPDF from '@salesforce/apex/SendEmailController.sendEmail';
import MY_STATIC_RESOURCE from '@salesforce/resourceUrl/email_template';
import { loadScript } from 'lightning/platformResourceLoader';
import JS_PDF from '@salesforce/resourceUrl/jsPDFLibrary';
import JS_PDF_AUTO_TABLE from '@salesforce/resourceUrl/jsPDFAutoTable';

import USER_ID from '@salesforce/user/Id';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import USER_EMAIL_FIELD from '@salesforce/schema/User.Email';

// Define fields to fetch
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c', 'Account.Name'];

const columns = [
    { label: 'Customer Number', fieldName: 'KUNNR' },
    { label: 'Posting Date', fieldName: 'BUDAT' },
    { label: 'Document Number', fieldName: 'BELNR' },
    { label: 'Narration', fieldName: 'SGTXT' },
    { label: 'Document Type', fieldName: 'BLART' },
    { label: 'Debit Amount', fieldName: 'DEBIT' }, 
    { label: 'Credit Amount', fieldName: 'CREDIT' },
    { label: 'Closing Balance', fieldName: 'CLSBAL' },
    
    /* { label: 'Customer Number', fieldName: 'IV_KUNNR' },
    { label: 'Document Date', fieldName: 'BLDAT' },
    { label: 'From date', fieldName: 'IV_FRM_DATE' },  
    { label: 'Posting Date', fieldName: 'BUDAT' },
    { label: 'Document Type Description', fieldName: 'LTEXT' },
    { label: 'Reference Key', fieldName: 'XBLNR' }, 
    { label: 'TCS Amount', fieldName: 'KWERT' },
    { label: 'Company Code', fieldName: 'IV_BUKRS' },
    { label: 'Company Address', fieldName: 'ZADDRESS' },
    { label: 'To date', fieldName: 'IV_FRM_TO' },
    { label: 'Profit Center', fieldName: 'IV_PRCTR' }, 
    */
];


export default class FetchCustomerLedger extends LightningElement {
    
    //for email 
    @track emailList = [];
    @track emailCCList = [];
    @track getEma;
    
    columns = columns;
    data = [];
    
    @track showNoRecordsMessage = false;
    isLoading = true;
    @api recordId;    
    @track startDate;
    @track endDate;
    @track isButtonDisabled = true;
    AccountSapId;
    CompanyCode;
    AccountName;
    attachmentData;
    @track uploadedFileNames = [];
    CurrentUserName;
    CurrentUserEmail;
    @track isShowModal = false;
    @track isShowModal1  = false;
    jsPDFInitialized = false;
    
    
    connectedCallback() {
        this.loadStaticResource();
    }
    
    handleToAddress(event) {
        const inputString = event.target.value;
        const emails = inputString.split(/[, ]+/).map(email => email.trim());
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
        this.getEma = inputrichText;
    }
    
    get acceptedFormats() {
        return ['.png','.xlsx', '.xls', '.csv', '.png', '.doc', '.docx', '.pdf'];
    }
    
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        this.uploadedFileNames = uploadedFiles.map(file => file.name);
        this.attachmentData = uploadedFiles;
        //alert('No. of files uploaded : ' + uploadedFiles.length);
    } 
    
    hideModalBox() {  
        this.isShowModal = false;
        this.data = null;
        this.isLoading = true;     
    }
    
    hideModalBox1() {  
        this.isShowModal1 = false;  
        this.uploadedFileNames = [];   
    }
    
    
    //fetch data of Account using UIRecordAPI
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    accountRecord({ error, data }) {
        if (data) {
            this.AccountSapId = data.fields.SAP_Code__c.value;
            this.CompanyCode = data.fields.Company_Code__c.value;
            this.AccountName = data.fields.Name.value;     
        } else if (error) {
            console.error(error);
        }
    }
    
    //fetch user data using UIRecordAPI
    @wire(getRecord, { recordId: USER_ID, fields: [USER_NAME_FIELD, USER_EMAIL_FIELD] })
    user;
    
    async loadStaticResource() {
        try {
            const response = await fetch(MY_STATIC_RESOURCE);
            if (response.ok) {
                const htmlText = await response.text();
                this.getEma = htmlText;
                console.log(this.getEma);
            } else {
                //console.error('Failed to fetch HTML content:', response.statusText);
            }
        } catch (error) {
            //console.error('Error loading HTML content:', error);
        }
    }
    
    handleStartDateChangeLedger(event)
    {
        if (event.target.name === 'startDate') {
            this.startDate = event.target.value;
        } else if(event.target.name === 'endDate') {
            this.endDate = event.target.value;
        }
        this.isButtonDisabled = !this.startDate || !this.endDate; 
    }
    
    //call Http class of ledger
    ledgerFetchHandler() {
        //window.alert(this.startDate + ' and\n ' + this.endDate);
        this.isShowModal = true;  
        
        // check if any data is blank & show error message
        if(this.AccountSapId && this.CompanyCode){
            //call rest api
            //check the response 
            //display response 
            //call apex class 
            getCustomerLedgerData({startDate : this.startDate, endDate : this.endDate, AccountSapId : this.AccountSapId, CompanyCode : this.CompanyCode   })
            .then(data => {
                console.log(JSON.stringify(data));
                if (data && data.Cust_ledgerSet) {
                    const ledgerData = data.Cust_ledgerSet.Cust_ledger;
                    
                    if (Array.isArray(ledgerData)) {
                        // If ledgerData is already an array, use it directly
                        this.data = ledgerData;
                        
                    } else if (ledgerData && typeof ledgerData === 'object') {
                        // If ledgerData is an object, convert it to an array
                        this.data = [ledgerData];
                    } else {
                        // Handle other cases where data is missing or not in the expected format
                        this.data = [];
                    }
                    
                    // Check if data is empty and show "Record Not Found" message
                    this.showNoRecordsMessage = this.data.length === 0;
                } else {
                    
                    this.data = [];
                    this.showNoRecordsMessage = true;
                }
                this.isLoading = false;  
            })
            .catch(error => {
                console.log("hrllo"+JSON.stringify(error));
                this.isLoading = true;
                //this.showToast('Error '+ error.status, error.body.message , 'error');
                this.isShowModal = false;
            }); 
        }
        else{
            console.log("this.AccountSapId && this.CompanyCode" + this.AccountSapId + ' '+  this.CompanyCode);
            this.showToast('Error', 'SAP Code and Company Code is Mandatory!!!', 'error');
            this.isLoading = true;
            this.data = null;
            this.isShowModal = false;
        }     
    }
    
    
    // Function to show toast notifications
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    } 
    
    //Excel Generation
    columnHeader = ['Customer Number','Posting Date','Document Number','Narration','Document Type','Debit Amount','Credit Amount','Closing Balance',/* 'Customer Number', 'Document Date','From date','Document Type Description','Reference Key','TCS Amount','Company Code','Company Address','To date','Profit Center'*/ ]
    exportContactData(){
        // Prepare a html table
        let doc = '';
        // Add content at the top of the Excel sheet
        doc += '<h1>Customer Ledger</h1>';
        doc += '<p>Customer Name : '+this.AccountName + '</p>';
        doc += '<p>SAP Code : '+this.AccountSapId+ '</p>'; 
        doc += '<p>From Date : '+this.startDate+ '</p>';
        doc += '<p>To Date : '+this.endDate+ '</p>';
        
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
        this.columnHeader.forEach(element => {            
            doc += '<th>'+ element +'</th>'           
        });
        doc += '</tr>';
        // Add the data rows
        this.data.forEach(record => {
            doc += '<tr>';
            doc += '<th>'+record.KUNNR+'</th>'; 
            doc += '<th>'+record.BUDAT+'</th>'; 
            doc += '<th>'+record.BELNR+'</th>'; 
            doc += '<th>'+record.SGTXT+'</th>'; 
            doc += '<th>'+record.BLART+'</th>'; 
            doc += '<th>'+record.DEBIT+'</th>'; 
            doc += '<th>'+record.CREDIT+'</th>';
            doc += '<th>'+record.CLSBAL+'</th>'; 
            /* doc += '<th>'+record.IV_KUNNR+'</th>';  
            doc += '<th>'+record.BLDAT+'</th>';             
            doc += '<th>'+record.IV_FRM_DATE+'</th>'; 
            doc += '<th>'+record.LTEXT+'</th>'; 
            doc += '<th>'+record.XBLNR+'</th>'; 
            doc += '<th>'+record.KWERT+'</th>'; 
            doc += '<th>'+record.ZADDRESS+'</th>'; 
            doc += '<th>'+record.IV_FRM_TO+'</th>'; 
            doc += '<th>'+record.IV_PRCTR+'</th>';*/
            doc += '</tr>';
        });
        doc += '</table>';
        
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        downloadElement.download = 'Customer Ledger.xls';
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
    
    handleGeneratePDF() {
        if (this.jsPDFInitialized) {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Center-align the title
            doc.setFontSize(18); // Adjust the font size as needed
            doc.text('Ledger Data', doc.internal.pageSize.getWidth() / 2, 10, 'center');
            
            doc.setFontSize(12); // Adjust the font size as needed    
            doc.text('Account Name: ' + this.AccountName, 10, 20);
            doc.text('Account SAP Code: ' + this.AccountSapId, 10, 30);
            doc.text('Start Date: ' + this.startDate, 10, 40);
            doc.text('End Date: ' + this.endDate, 10, 50);
            
            // Convert the JSON string back to an array of objects
            const ledgerData = this.data;//JSON.parse(this.data);
            
            const data = [];
            data.push(['Customer Number','Posting Date','Document Number','Narration','Document Type','Debit Amount','Credit Amount','Closing Balance']);
            
            ledgerData.forEach(ledData => {
                data.push([ledData.KUNNR, ledData.BUDAT, ledData.BELNR, ledData.SGTXT, ledData.BLART, ledData.DEBIT, ledData.CREDIT, ledData.CLSBAL]);
            });
            const tableOptions = {
                head: [data[0]],
                body: data.slice(1),
                startY: 70,
                styles: {
                    fontSize: 6, // Set the font size for the table
                },
            };
            doc.autoTable(tableOptions);
            // Add the table to the PDF using jsPDF-AutoTable
            /* doc.autoTable({
                head: [data[0]],
                body: data.slice(1),
                startY: 70,
            }); */ 
            
            doc.save('ledger_Data.pdf');
        } else {
            console.error('jsPDF library not initialized');
        }
    }
    
    showDataForEmail(){
        this.isShowModal1 = true;
    }
    
    sendEmailData1() {
        const currentUserName = this.user.data.fields.Name.value;
        const currentUserEmail = this.user.data.fields.Email.value;
        this.CurrentUserName = currentUserName;
        this.CurrentUserEmail = currentUserEmail
        
        /* console.log('CurrentUserNam e'+ this.CurrentUserName);
        console.log('CurrentUserEmail e'+ this.CurrentUserEmail);
        console.log('its working'+this.CurrentUserEmail);
        console.log('Attachemntskdjf '+JSON.stringify(this.attachmentData)); */
        
        const attachm = JSON.stringify(this.attachmentData);
        sendEmailWithPDF({toAddress: this.emailList, toCCAddress : this.emailCCList, BodyEmail : this.getEma, toAttachment : attachm, CurrentUser : this.CurrentUserName, CurrentUserNa : this.CurrentUserEmail})
        .then((data) => {
            // Show success toast notification
            if(data === 'true')
            {
                console.log(data);
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
        
    }  
}