import { LightningElement,api,track,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getCustomerOutStandingData from '@salesforce/apex/customerOutStandingData.customerOutStandingData';

// Define fields to fetch
const FIELDS = ['Account.SAP_Code__c', 'Account.Company_Code__c'];


export default class FetchOutstanding extends LightningElement {
    @api recordId;
    @track currentDate;
    AccountSapId;
    CompanyCode;
    @track isButtonDisabledForOutstd = true;
    
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

    handleClickForOutStanding(){
        
    }
    
    
}