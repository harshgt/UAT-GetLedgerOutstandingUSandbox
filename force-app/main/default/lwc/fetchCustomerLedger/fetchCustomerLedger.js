import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerLedgerData from '@salesforce/apex/customerLedgerData.customerLedgerData';
import getCustomerOutStandingData from '@salesforce/apex/customerOutStandingData.customerOutStandingData';



// Define fields to fetch
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c'];



export default class FetchCustomerLedger extends LightningElement {

    @api recordId;    
    @track selectedTypeValue;
    @track currentDate;
    @track startDate;
    @track endDate;
    @track isButtonDisabled = true;
    @track isButtonDisabledForOutstd = true;
    AccountSapId;
    CompanyCode;

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
        window.alert(this.startDate + ' and\n ' + this.endDate);
        //call rest api
        //check the response 
        //display response 
        let endpoint = 'https://brilliant-polymers-ixuv1tbr.it-cpi011-rt.cfapps.jp20.hana.ondemand.com/http/TEST/ODATA';
       
        //call apex class with endpoint
        getCustomerLedgerData({endPointUrl:endpoint, startDate : this.startDate, endDate : this.endDate })
        .then(data => {
            console.log(JSON.stringify(data));

            });
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