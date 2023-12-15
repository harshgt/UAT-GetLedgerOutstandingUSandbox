import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerLedgerData from '@salesforce/apex/customerLedgerData.customerLedgerData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendEmailWithPDF from '@salesforce/apex/SendEmailController.sendEmail';
import MY_STATIC_RESOURCE from '@salesforce/resourceUrl/email_template';
import { loadScript } from 'lightning/platformResourceLoader';
import JS_PDF from '@salesforce/resourceUrl/jsPDFLibrary';
import JS_PDF_AUTO_TABLE from '@salesforce/resourceUrl/jsPDFAutoTable';
import MY_LOGO from '@salesforce/resourceUrl/MyDomainLogo';
import MY_ADD from '@salesforce/resourceUrl/footerAddress';

// Define fields to fetch
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c', 'Account.Name', 'Account.Bill_To_Name__c', 'Account.Bill_To_Street__c', 'Account.Bill_To_Zip_Postal_Code__c', 'Account.Bill_To_Country__c', 'Account.Bill_To_Street2__c', 'Account.Bill_To_Street3__c', 'Account.Bill_To_City__c', 'Account.Bill_To_Name2__c' , 'Account.Currency__c'];   //Bill_To_Name__c, Bill_To_Street__c, Bill_To_Zip_Postal_Code__c, Bill_To_Country__c



const columns = [
    { label: 'Document Date', fieldName: 'BUDAT' },
    { label: 'Invoice Number', fieldName: 'BELNR' }, //invoice Number 
    { label: 'Bill Date', fieldName: 'BLDAT' }, //bill date
    /* { label: 'Narration', fieldName: 'SGTXT' }, */
    { label: 'Document Type', fieldName: 'BLART' },
    { label: 'TCS-TDS', fieldName: 'KWERT' },
    { label: 'Debit Amount', fieldName: 'DEBIT' }, 
    { label: 'Credit Amount', fieldName: 'CREDIT' },
    { label: 'Closing Balance', fieldName: 'CLSBAL' },
    /*{ label: 'Customer Number', fieldName: 'KUNNR' },
    { label: 'Narration', fieldName: 'SGTXT' },
    { label: 'Document Type', fieldName: 'BLART' },
    { label: 'Customer Number', fieldName: 'IV_KUNNR' },
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
    @track isShowModal = false;
    @track isShowModal1  = false;
    jsPDFInitialized = false;
    BillToName;
    BillToName2;
    BillToStreet;
    BillToZipPostalCode;
    BillToCountry;
    BillToStreet2;
    BillToStreet3;
    BillToCity;
    Currency;
    
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
            this.BillToName2 = data.fields.Bill_To_Name2__c.value || '';
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
            this.Currency = data.fields.Currency__c.value;
            this.updateColumnLabels();
        } else if (error) {
            console.error(error);
        }
    }

    updateColumnLabels() {
        const currencyLabel = this.Currency; // Default to 'INR' if not set
    
        this.columns = this.columns.map(column => {
            if(currencyLabel === 'INR'){
                if (column.fieldName === 'InvAmt') {
                    column.label = `Invoice Amount (${currencyLabel})`;
                } else if (column.fieldName === 'RemAmt') {
                    column.label = `Remaining Amount (${currencyLabel})`;
                }
            }else if(currencyLabel === 'USDN'){
                if (column.fieldName === 'InvAmt') {
                    column.label = `Invoice Amount (${currencyLabel})`;
                } else if (column.fieldName === 'RemAmt') {
                    column.label = `Remaining Amount (${currencyLabel})`;
                }
            }
            else if(currencyLabel === 'EUR'){
                    if (column.fieldName === 'InvAmt') {
                        column.label = `Invoice Amount (${currencyLabel})`;
                    } else if (column.fieldName === 'RemAmt') {
                        column.label = `Remaining Amount (${currencyLabel})`;
                    }
                }
                
            
            
            // Add more conditions for other columns as needed
            return column;
        });
    }
    
    
    async loadStaticResource() {
        try {
            const response = await fetch(MY_STATIC_RESOURCE);
            if (response.ok) {
                const htmlText = await response.text();
                this.getEma = htmlText;
                //console.log(this.getEma);
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
            //call apex class 
            getCustomerLedgerData({startDate : this.startDate, endDate : this.endDate, AccountSapId : this.AccountSapId, CompanyCode : this.CompanyCode   })
            .then(data => {
                //console.log(JSON.stringify(data));
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
    columnHeader =['Document Date','Invoice Number','Bill Date'/* ,'Narration' */,'Document Type','TCS-TDS','Debit Amount','Credit Amount','Closing Balance'];
    

    exportContactData(){

        const currencyLabel1 = this.Currency; // Default to 'INR' if not set

    
        this.columnHeader1 = this.columnHeader.map(columnHead => {
            if(currencyLabel1 === 'INR'){
                if (columnHead === 'Debit Amount') {
                    return `Debit Amount (${currencyLabel1})`;
                } else if (columnHead === 'Credit Amount') {
                    return `Credit Amount (${currencyLabel1})`;
                }
            }
            else if(currencyLabel1 === 'USDN'){
                if (columnHead === 'Debit Amount') {
                    return `Debit Amount (${currencyLabel1})`;
                } else if (columnHead === 'Credit Amount') {
                    return `Credit Amount (${currencyLabel1})`;
                }
            }
            else if(currencyLabel1 === 'EUR'){
                if (columnHead === 'Debit Amount') {
                    return `Debit Amount (${currencyLabel1})`;
                } else if (columnHead === 'Credit Amount') {
                    return `Credit Amount (${currencyLabel1})`;
                }
            }
            return columnHead;
        });









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

        doc += '<h1 style="font-size: 18px; text-align: center;">'  +this.BillToName+ ' '+ this.BillToName2 + '</h1>';
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
            /* doc += '<th>'+record.SGTXT+'</th>'; */ 
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
                //console.log('jsPDF library loaded successfully');
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
            const logoDataUrl = MY_LOGO ; 
            const img = new Image();
            img.src = logoDataUrl;
            img.onload = () => {                
            const imageWidth = 120;
            const xCoordinate = (doc.internal.pageSize.getWidth() - imageWidth) / 2;
            doc.addImage(img, 'PNG', xCoordinate, 5, imageWidth, 30);
                
            doc.setFontSize(20); 
            doc.setFont('times', 'bold');
            doc.text('Ledger Account', doc.internal.pageSize.getWidth() / 2, 50, 'center');
            doc.setFontSize(12); 
            doc.text(' Customer Name : '+this.BillToName+ ' ' +this.BillToName2, 10, 70);
            doc.setFont('times', 'normal');
            doc.setFontSize(12); 
            doc.text('Address : '+ this.BillToStreet + ' '+ this.BillToStreet2 + ' '+ this.BillToStreet3 + ' '+ this.BillToCity + ' ' + this.BillToZipPostalCode+ ' ' + this.BillToCountry, 10, 80);
            doc.setFontSize(12);
            doc.setFont('times', 'bold');
            doc.text('From Date: ' + formattedDate1 + ' To Date: ' + formattedDate2, 10, 100);
            doc.setFont('times', 'normal');
            const ledgerData = this.data;//JSON.parse(this.data);
            const data = [];
            data.push(['Document Date','Invoice Number','Bill Date'/* ,'Narration' */,'Document Type','TCS-TDS','Debit Amount','Credit Amount','Closing Balance']);
            let totalDebit = 0;
            let totalCredit = 0;

            ledgerData.forEach(ledData => {
                data.push([ledData.BUDAT, ledData.BELNR, ledData.BLDAT, /* ledData.SGTXT, */ ledData.BLART, ledData.KWERT, ledData.DEBIT, ledData.CREDIT, ledData.CLSBAL]);
                totalDebit += parseFloat(ledData.DEBIT) || 0;
                totalCredit += parseFloat(ledData.CREDIT) || 0;
            });

            data.push(['', '', '', '', '', 'Total : ', totalDebit.toFixed(2),totalCredit.toFixed(2), '']);
           
            const tableOptions = {
                head: [data[0]],
                body: data.slice(1),
                /* startY: 120, */
                styles: {
                    fontSize: 6, // Set the font size for the table
                },
            };

            const pageSize = doc.internal.pageSize;
            const pageHeight = pageSize.height - 10; 
            let currentPage = 1;
            let startY = 120;

            for (let i = 1; i < data.length; i += 22) {
                const tableData = data.slice(i, i + 22); 

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
            doc.save('ledger_Data.pdf');
            };
        } 
        else 
        {
            console.error('jsPDF library not initialized');
            
        }
    
    }


    
    showDataForEmail(){
        this.isShowModal1 = true;
    }
    
    sendEmailData1() {
        const attachm = JSON.stringify(this.attachmentData);
        const LedgerCodeEmails = 'ledger';
        sendEmailWithPDF({toAddress: this.emailList, toCCAddress : this.emailCCList, BodyEmail : this.getEma, toAttachment : attachm,  CustOutCodeEmail : LedgerCodeEmails})
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