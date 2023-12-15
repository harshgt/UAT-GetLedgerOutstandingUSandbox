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
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c', 'Account.Name', 'Account.Bill_To_Name__c', 'Account.Bill_To_Street__c', 'Account.Bill_To_Zip_Postal_Code__c', 'Account.Bill_To_Country__c', 'Account.Bill_To_Street2__c', 'Account.Bill_To_Street3__c', 'Account.Bill_To_City__c'];   //Bill_To_Name__c, Bill_To_Street__c, Bill_To_Zip_Postal_Code__c, Bill_To_Country__c



const columns = [
    { label: 'Posting Date', fieldName: 'BUDAT' },
    { label: 'Invoice Number', fieldName: 'BELNR' }, //invoice Number 
    { label: 'Bill Date', fieldName: 'BLDAT' }, //bill date
    { label: 'Narration', fieldName: 'SGTXT' },
    { label: 'Document Type', fieldName: 'BLART' },
    { label: 'TCS-TDS', fieldName: 'KWERT' },
    { label: 'Debit Amount', fieldName: 'DEBIT' }, 
    { label: 'Credit Amount', fieldName: 'CREDIT' },
    { label: 'Closing Balance', fieldName: 'CLSBAL' },
    /*{ label: 'Customer Number', fieldName: 'KUNNR' },
    
    { label: 'Narration', fieldName: 'SGTXT' },
    { label: 'Document Type', fieldName: 'BLART' },
    
    */
    
    /* { label: 'Customer Number', fieldName: 'IV_KUNNR' },
    { label: 'Document Date', fieldName: 'BLDAT' },
    { label: 'From date', fieldName: 'IV_FRM_DATE' },  
    { label: 'Posting Date', fieldName: 'BUDAT' },
    { label: 'Document Type Description', fieldName: 'LTEXT' },
    { label: 'Reference Key', fieldName: 'XBLNR' }, 
   
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

    BillToName;
    BillToStreet;
    BillToZipPostalCode;
    BillToCountry;
    BillToStreet2;
    BillToStreet3;
    BillToCity;
    
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
            this.BillToName= data.fields.Bill_To_Name__c.value;  
            this.BillToStreet=data.fields.Bill_To_Street__c.value;
            this.BillToZipPostalCode=data.fields.Bill_To_Zip_Postal_Code__c.value;
            //this.BillToCountry=data.fields.Bill_To_Country__c.displayValue;
            // Check for "None" in the picklist value
            this.BillToCountry = data.fields.Bill_To_Country__c.displayValue === 'NONE'
            ? ''
            : data.fields.Bill_To_Country__c.displayValue;
            this.BillToStreet2=data.fields.Bill_To_Street2__c.value || '';
            this.BillToStreet3=data.fields.Bill_To_Street3__c.value || '';
            this.BillToCity = data.fields.Bill_To_City__c.value;
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
                this.showToast('Error '+ error.status, error.body.message , 'error');
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
    columnHeader =['Posting Date','Invoice Number','Bill Date','Narration','Document Type','TCS-TDS','Debit Amount','Credit Amount','Closing Balance'];
    

    exportContactData(){

        let totalDebit1 = 0;
        let totalCredit1 = 0;

        const dateObject3 = new Date(this.startDate);
        const formattedDate3 = dateObject3.toLocaleDateString('en-GB', {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric',
        });

        const dateObject4 = new Date(this.endDate);
        const formattedDate4 = dateObject4.toLocaleDateString('en-GB', {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric',
        });

        // Prepare a html table
        let doc = '';
        // Add content at the top of the Excel sheet
        doc += '<h1 style="text-align: center;">Brilliant Polymers Pvt Ltd</h1>';

        doc += '<p style="font-size: 12px; text-align: center;">Plot No.15,16,21/4,MIDC Morivali, Ambernath (W) 421505</p>';
        doc += '<p style="font-size: 12px; text-align: center;">Maharashtra</p>';
        doc += '<br>'; // Add a line break

        doc += '<h1 style="font-size: 18px; text-align: center;">'  +this.BillToName+ '</h1>';
        doc += '<p style="font-size: 12px; text-align: center;">' + this.BillToStreet + ''+ this.BillToStreet2 + ' '+ this.BillToStreet3 + ' '+ this.BillToCity + ' ' + this.BillToZipPostalCode+ ' ' + this.BillToCountry+ ' '+ '</p>';
        doc += '<br>';

        doc += '<h1 style="font-size: 18px; text-align: center;">Ledger Account</h1>';
        
        /* doc += '<p>Customer Name : '+this.AccountName + '</p>';
        doc += '<p>SAP Code : '+this.AccountSapId+ '</p>';  */
        doc += '<p style="font-size: 12px; text-align: center;" >From Date : '+formattedDate3+ '</p>';
        doc += '<p style="font-size: 12px; text-align: center;">To Date : '+formattedDate4+ '</p>'; 
        
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
            doc += '<th>'+record.BUDAT+'</th>'; 
            doc += '<th>'+record.BELNR+'</th>'; 
            doc += '<th>'+record.BLDAT+'</th>'; 
            doc += '<th>'+record.SGTXT+'</th>'; 
            doc += '<th>'+record.BLART+'</th>'; 
            doc += '<th>'+record.KWERT+'</th>'; 
            doc += '<th>'+record.DEBIT+'</th>'; 
            doc += '<th>'+record.CREDIT+'</th>';
            doc += '<th>'+record.CLSBAL+'</th>'; 

            // Update the total debit and credit
            totalDebit1 += parseFloat(record.DEBIT) || 0;
            totalCredit1 += parseFloat(record.CREDIT) || 0;
            /*doc += '<th>'+record.IV_KUNNR+'</th>';  
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

        doc += '<tr>';
            doc += '<th colspan="6">Total</th>'; 
            doc += '<th>'+ totalDebit1 +'</th>'; 
            doc += '<th>'+ totalCredit1 +'</th>';
            doc += '<th></th>'; // Assuming the last column is not part of the sum
            doc += '</tr>';
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
        const dateObject1 = new Date(this.startDate);
        const formattedDate1 = dateObject1.toLocaleDateString('en-GB', {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric',
        });

        const dateObject2 = new Date(this.endDate);
        const formattedDate2 = dateObject2.toLocaleDateString('en-GB', {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric',
        });


        if (this.jsPDFInitialized) {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Center-align the title
            doc.setFontSize(18); // Adjust the font size as needed
            doc.text('Brilliant Polymers Pvt Ltd', doc.internal.pageSize.getWidth() / 2, 10, 'center');

            
            doc.setFontSize(10); // Adjust the font size as needed
            doc.text('Plot No.15,16,21/4,MIDC Morivali, Ambernath (W) 421505', doc.internal.pageSize.getWidth() / 2, 20, 'center');
            doc.text('Maharashtra', doc.internal.pageSize.getWidth() / 2, 30, 'center');

            // Add a line break
            //doc.ln(10);

            doc.setFontSize(16); // Adjust the font size as needed
            doc.text(this.BillToName, doc.internal.pageSize.getWidth() / 2, 50, 'center');

           doc.setFontSize(10); // Adjust the font size as needed
           doc.text(this.BillToStreet + ' '+ this.BillToStreet2 + ' '+ this.BillToStreet3 + ' '+ this.BillToCity + ' ' + this.BillToZipPostalCode+ ' ' + this.BillToCountry, doc.internal.pageSize.getWidth() / 2, 60, 'center');
            
            //doc.ln(10);
            doc.setFontSize(15); // Adjust the font size as needed
            doc.text('Ledger Acount ', doc.internal.pageSize.getWidth() / 2, 80, 'center');


           
            /* doc.text('Account Name: ' + this.AccountName, 10, 70);
            doc.text('Account SAP Code: ' + this.AccountSapId, 10, 80); */
            doc.setFontSize(10);
            doc.text('From Date: ' + formattedDate1, 10, 90);
            doc.text('To Date: ' + formattedDate2, 10, 100);
            
            // Convert the JSON string back to an array of objects
            const ledgerData = this.data;//JSON.parse(this.data);
            
            const data = [];
            data.push(['Posting Date','Invoice Number','Bill Date','Narration','Document Type','TCS-TDS','Debit Amount','Credit Amount','Closing Balance']);
            let totalDebit = 0;
            let totalCredit = 0;

            ledgerData.forEach(ledData => {
                data.push([ledData.BUDAT, ledData.BELNR, ledData.BLDAT, ledData.SGTXT, ledData.BLART, ledData.KWERT, ledData.DEBIT, ledData.CREDIT, ledData.CLSBAL]);
                // Accumulate the credit values
                // Accumulate the debit and credit values
                totalDebit += parseFloat(ledData.DEBIT) || 0;
                totalCredit += parseFloat(ledData.CREDIT) || 0;
            
            });

            // Add the total debit and credit rows to the data array
            data.push(['', '', '', '', '', 'Total : ', totalDebit.toFixed(2),totalCredit.toFixed(2), '']);
            //data.push(['', '', '', '', '', '', '', , '']);


            const tableOptions = {
                head: [data[0]],
                body: data.slice(1),
                startY: 120,
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