import { LightningElement, wire, api } from "lwc";
import { getRecord, notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { refreshApex } from '@salesforce/apex';

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRecordToBeDeleted from "@salesforce/apex/HLA_AFGCallout.updateRecordToBeDeleted";
import { NavigationMixin } from "lightning/navigation";
import { CloseActionScreenEvent } from "lightning/actions";



const SUCCESS = { title: "Success", variant: "success" };
const NOFIELD = { title: "Error", variant: "error", message: "IsDeleted field error. Please Contact Admin!!!" };




export default class HlaDeleteFinancialsPE extends NavigationMixin(LightningElement)
{

    @api recordId;
    @api objectApiName;
    showSpinner = false;


    data; IsDeleted; error; RLAId
    @wire(getRecord, { recordId: '$recordId', layoutTypes: ["Full"], modes: ["Edit"] })
    sObj({ error, data })
    {
        if (data) {
            this.data = data;
            this.IsDeleted = data.fields?.IsDeleted__c?.value;
            this.RLAId = data.fields?.ResidentialLoanApplication__c?.value;
            this.error = undefined;

        }
    }

    confirmDelete()
    {
        this.showSpinner = true;
        console.log('ObjectApiName:', this.objectApiName);
        console.log('IsDeleted', this.IsDeleted);
        console.log('error', this.error);
        if (this.IsDeleted != null || this.IsDeleted != undefined) {
            this.markRecordIsDeletedandCreatePlatformevent()
        }
        else {
            this.showSpinner = false;
            this.showToast(NOFIELD);
            this.dispatchEvent(new CloseActionScreenEvent());

        }

    }

    async markRecordIsDeletedandCreatePlatformevent()
    {
        try {

            await updateRecordToBeDeleted({ objectName: String(this.objectApiName), recordId: String(this.recordId) });
            refreshApex(this.data);
            this.showSpinner = true;
            this.showToast(SUCCESS);
            this.dispatchEvent(new CloseActionScreenEvent());
            this.returnToRLAHomePage();


        } catch (error) {
            this.showSpinner = false;
            this.dispatchEvent(new CloseActionScreenEvent());
            this.showToast({
                title: 'Error deleting Financials record',
                message: error.body?.message,
                variant: 'error',
            });

            console.log(error);
        }




    }

    returnToRLAHomePage()
    {
        if (!this.RLAId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'ResidentialLoanApplication__c',
                    actionName: 'List',
                },
                state: { filterName: "Recent", }
            });
        }
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: this.RLAId,
                actionName: "view",
            },
        });
    }



    cancel()
    {
        this.dispatchEvent(new CloseActionScreenEvent());
        //this.showToast(ERROREVE);
    }

    showToast(passedValue)
    {
        this.dispatchEvent(
            new ShowToastEvent({
                title: passedValue.title,
                message: passedValue.message,
                variant: passedValue.variant
            })
        );
    }



}