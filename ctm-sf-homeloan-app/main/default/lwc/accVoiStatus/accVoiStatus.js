import { LightningElement, api, track, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Account_OBJECT from '@salesforce/schema/Account';
import LIVENESS_FIELD from '@salesforce/schema/Account.Liveness__c';
import DOCUMENT_FIELD from '@salesforce/schema/Account.Document__c';
import FACE_FIELD from '@salesforce/schema/Account.Face__c';
import OVERALL_STATUS_FIELD from '@salesforce/schema/Account.OverallStatus__c';

const fields = [LIVENESS_FIELD, DOCUMENT_FIELD,FACE_FIELD, OVERALL_STATUS_FIELD];
const pass = 'background-color:green;color:white';
const failed = 'background-color:#ffc107;color:white';
export default class AccVoiStatus extends LightningElement {
   
    @track docuStyle = pass;
    @track faceStyle = pass;
    @track livenessStyle = pass;
    @track overall_status = '';
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields})
    wiredAcc({error, data}){
        if(data){
            console.log(data.fields.Document__c.value);
            if(data.fields.Document__c.value != 'Pass'){
                this.docuStyle = failed;
            }
            if(data.fields.Face__c.value != 'Pass'){
                this.faceStyle = failed;
            }
            if(data.fields.Liveness__c.value != 'Pass'){
                this.livenessStyle = failed;
            }
            if(data.fields.Overall_Status__c.value!=null){
                this.overall_status = "VOI Status - "+data.fields.OverallStatus__c.value;
            }else  this.overall_status = "VOI Status - Not Started";
            
        }
    } 
}