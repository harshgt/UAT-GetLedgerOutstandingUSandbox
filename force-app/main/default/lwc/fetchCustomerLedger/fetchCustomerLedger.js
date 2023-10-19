import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerLedgerData from '@salesforce/apex/customerLedgerData.customerLedgerData';
import getCustomerOutStandingData from '@salesforce/apex/customerOutStandingData.customerOutStandingData';
import JSPDF from '@salesforce/resourceUrl/jspdf';
import {loadScript} from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


// Define fields to fetch
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c'];

const columns = [
    { label: 'KUNNR', fieldName: 'KUNNR' },
    { label: 'CREDIT', fieldName: 'CREDIT' },
    /* { label: 'IV_FRM_DATE', fieldName: 'IV_FRM_DATE' }, */
    { label: 'BUDAT', fieldName: 'BUDAT' },
    { label: 'BELNR', fieldName: 'BELNR' },
    { label: 'SGTXT', fieldName: 'SGTXT' },
    { label: 'LTEXT', fieldName: 'LTEXT' },
    /* { label: 'XBLNR', fieldName: 'XBLNR' }, */
    { label: 'DEBIT', fieldName: 'DEBIT' },
    { label: 'KWERT', fieldName: 'KWERT' },
    { label: 'IV_BUKRS', fieldName: 'IV_BUKRS' },
    /* { label: 'ZADDRESS', fieldName: 'ZADDRESS' },
    { label: 'IV_FRM_TO', fieldName: 'IV_FRM_TO' },
    { label: 'IV_PRCTR', fieldName: 'IV_PRCTR' }, */ 
    { label: 'BLART', fieldName: 'BLART' },
];


export default class FetchCustomerLedger extends LightningElement {

    columns = columns;
    //data=[];
    data = [];
    @track showNoRecordsMessage = false;
    isLoading = true;
    @api recordId;    
    @track selectedTypeValue;
    @track currentDate;
    @track startDate;
    @track endDate;
    @track isButtonDisabled = true;
    @track isButtonDisabledForOutstd = true;
    AccountSapId;
    CompanyCode;

    
      headers = this.createHeaders([
        'KUNNR', 'CREDIT', 'BUDAT'
      ]);

      createHeaders(keys) {
		var result = [];
		for (let i = 0; i < keys.length; i += 1) {
			result.push({
				id: keys[i],
				name: keys[i],
				prompt: keys[i],
				width: 65,
				align: "center",
				padding: 0
			});
		}
		return result;
	}

  

    @track isShowModal = false;

    hideModalBox() {  
        this.isShowModal = false;
        this.data = null;
        this.isLoading = true;

    }

    //use for outStanding radio button optios
    get options() {
        return [
            { label: 'Overdue', value: 'overdue' },
            { label: 'No Due', value: 'nodue' },
            { label: 'Both', value: 'both' },
        ];
    }

    //fetch data of Account using UIRecordAPI
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    accountRecord({ error, data }) {
        if (data) {
            this.AccountSapId = data.fields.SAP_Code__c.value;
            this.CompanyCode = data.fields.Company_Code__c.value;
        } else if (error) {
            console.error(error);
        }
    }

    //to get the current date
    connectedCallback() {
        const today = new Date();
        const day = String(today.getDate()).padStart(2, '0');
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const year = today.getFullYear();
        this.currentDate = `${year}-${month}-${day}`; // Corrected the date format to YYYY-MM-DD    
    }


    //get the selected radio Type Value
    selectedTypeValueHandler(event){
        this.selectedTypeValue =event.target.value;
        this.isButtonDisabledForOutstd = false;

    }

    //user input for Date Range (Strat Date and End Date) ledger
    /* handleStartDateChangeLedger(event) {
        this.startDate = event.target.value;
        this.isButtonDisabled = this.startDate === '';
    }
    handleEndDateChangeLedger(event) {
        this.endDate = event.target.value;
        this.isButtonDisabled = this.endDate === '';
    } */

    handleStartDateChangeLedger(event)
    {
        if (event.target.name === 'startDate') {
            this.startDate = event.target.value;
        } else if(event.target.name === 'endDate') {
            this.endDate = event.target.value;
        }
        this.isButtonDisabled = !this.startDate || !this.endDate; 
    }



    //take default date Outstanding
    handleDefaultDateOutstanding(event)
    {
        this.currentDate = event.target.value;
    }

    //call Http class of ledger
    ledgerFetchHandler() {
        //window.alert(this.startDate + ' and\n ' + this.endDate);
        this.isShowModal = true;


        // check if any data is blank  show error message
        if(this.AccountSapId && this.CompanyCode){
            //call rest api
            //check the response 
            //display response 
            
            //call apex class 
            getCustomerLedgerData({startDate : this.startDate, endDate : this.endDate, AccountSapId : this.AccountSapId, CompanyCode : this.CompanyCode   })
            .then(data => {
                //console.log(JSON.stringify(data));
                //this.data = data.Cust_ledgerSet.Cust_ledger;
               /*  if (data && data.Cust_ledgerSet && data.Cust_ledgerSet.Cust_ledger) {
                    this.data = data.Cust_ledgerSet.Cust_ledger;
                    this.showNoRecordsMessage = false;
                } else {
                    this.data = [];
                    this.showNoRecordsMessage = true;
                }
                this.isLoading = false; */
                // Handle the response data
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
                console.log(JSON.stringify(error));
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


    getSelectedRow(event){
        const getSelectedRows = event.detail.selectedRows;
        console.log("selectedRows"+ getSelectedRows);
        
    }

    columnHeader = ['KUNNR', 'CREDIT', 'BUDAT', 'BELNR' ]
    exportContactData(){
        // Prepare a html table
        let doc = '<table>';
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
            doc += '<th>'+record.CREDIT+'</th>'; 
            doc += '<th>'+record.BUDAT+'</th>';
            doc += '<th>'+record.BELNR+'</th>'; 
            doc += '</tr>';
        });
        doc += '</table>';
        
        var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(doc);
        let downloadElement = document.createElement('a');
        downloadElement.href = element;
        downloadElement.target = '_self';
        // use .csv as extension on below line if you want to export data as csv
        downloadElement.download = 'Customer Ledger.xls';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }




    renderedCallback() {
		Promise.all([
			loadScript(this, JSPDF)
		]);
	}

	generatePdf(){
    console.log('its working');
    //console.log(this.data);
		const { jsPDF } = window.jspdf;
		const doc = new jsPDF({
			/* encryption: {
				userPassword: "user",
				ownerPassword: "owner",
				userPermissions: ["print", "modify", "copy", "annot-forms"]
				// try changing the user permissions granted
			} */
		});
    console.log('its working1');

		
    //doc.text("Customer", 40, 40); // Adjusted Y-coordinate

    //imageData, format, x, y, width, height, alias, compression, rotation
    //doc.addImage(this.imgData, 'PNG', 30, 60, 30, 30); // Adjusted Y-coordinate


    doc.setFontSize(20);
    doc.setFont('helvetica');
    doc.text("CUSTOMER LEDGER", 90, 20);

    // Adjusted table position
    doc.table(40, 100, this.data , this.headers, { autosize: true });
		doc.save("Customer ledg.pdf");
	}


    
       







    //call Http class of OutStanding
    handleClickForOutStanding()
    {   
        window.alert(' currentDate: ' +this.currentDate + ' AccountSapID ' + this.AccountSapId + ' SelType ' + this.selectedTypeValue + ' CompanyCode ' + this.CompanyCode);
        //call rest api
        //check the response 
        //display response 
        let endpoint = 'testapi';
       
        //call apex class with endpoint
        getCustomerOutStandingData({endPointUrl:endpoint, accountSapCode : this.AccountSapId})
        .then(data => {
            console.log(JSON.stringify(data));
            
            });
        
    }
}