import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ERRORRESPONSE_FIELD from '@salesforce/schema/Opportunity.Error_Response__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Import ShowToastEvent


export default class ErrorMessageForTheOpportunity extends LightningElement {
    @api recordId; // Opportunity record Id
    opportunityError_Response__c; 
    showButton = false;

    @wire(getRecord, { recordId: '$recordId', fields: [ERRORRESPONSE_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            this.opportunityError_Response__c = getFieldValue(data, ERRORRESPONSE_FIELD);
            this.showButton = this.opportunityError_Response__c !== null;
        } else if (error) {
            // Handle the error
            console.error(error);
        }
    }

    handleButtonClick() {
        const event = new ShowToastEvent({
            title: 'Error',
            message:  this.opportunityError_Response__c,
            variant: 'error',
        });
        this.dispatchEvent(event);
        

    }
}