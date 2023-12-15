import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ERRORRESPONSE_FIELD from '@salesforce/schema/Lead.Error_Response__c';
import CONVERTEDLEAD_FIELD from '@salesforce/schema/Lead.Status';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeadCalloutLWC extends LightningElement {
    @api recordId; // Opportunity record Id
    LeadError_Response__c; 
    LeadStatus;
    showButton = false;

    @wire(getRecord, { recordId: '$recordId', fields: [ERRORRESPONSE_FIELD, CONVERTEDLEAD_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            this.LeadError_Response__c = getFieldValue(data, ERRORRESPONSE_FIELD);
            this.LeadStatus = getFieldValue(data, CONVERTEDLEAD_FIELD);
            this.showButton = this.LeadError_Response__c !== null && this.LeadStatus !== 'Closed – Converted';
        } else if (error) {
            // Handle the error
            console.error(error);
        }
    }

    handleButtonClick() {
        const event = new ShowToastEvent({
            title: 'Error',
            message:  this.LeadError_Response__c,
            variant: 'error',
        });
        this.dispatchEvent(event);
        

    }
}