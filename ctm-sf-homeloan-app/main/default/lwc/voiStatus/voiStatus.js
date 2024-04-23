import { LightningElement, api, track, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import VOI_OBJECT from '@salesforce/schema/VOI__c';
import LIVENESS_FIELD from '@salesforce/schema/VOI__c.Liveness__c';
import DOCUMENT_FIELD from '@salesforce/schema/VOI__c.Document__c';
import FACE_FIELD from '@salesforce/schema/VOI__c.Face__c';
import Id from '@salesforce/schema/VOI__c.Id';

const fields = [LIVENESS_FIELD, DOCUMENT_FIELD,FACE_FIELD ];
const pass = 'background-color:green;color:white';
const failed = 'background-color:#ffc107;color:white';
export default class VoiStatus extends LightningElement {
   
    @track docuStyle = pass;
    @track faceStyle = pass;
    @track livenessStyle = pass;
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields})
    wiredVOI({error, data}){
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
        }
    }

}