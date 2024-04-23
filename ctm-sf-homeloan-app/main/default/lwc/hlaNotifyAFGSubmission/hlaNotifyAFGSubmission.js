import { LightningElement, wire, api, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from "lightning/empApi";
//import requestAFGCallout from "@salesforce/apex/HLA_ProductRecommendations.requestAFGCallout";
import requestAFGCallout from "@salesforce/apex/HLA_AFGCallout.requestAFGCallout";

import { updateRecord } from "lightning/uiRecordApi";
import RLA_ID from "@salesforce/schema/ResidentialLoanApplication__c.Id";
import RLA_CORR_ID from "@salesforce/schema/ResidentialLoanApplication__c.CorrelationId__c";
import RLA_AFGSTATUS from "@salesforce/schema/ResidentialLoanApplication__c.AFGStatus__c";
import RLA_AFGID from "@salesforce/schema/ResidentialLoanApplication__c.AFGId__c";
import RLA_AFGError from "@salesforce/schema/ResidentialLoanApplication__c.AFGError__c";


import { refreshApex } from "@salesforce/apex";
import { CloseActionScreenEvent } from "lightning/actions";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const WARN = { title: "Warning", variant: "warning", message: "Not Submitted - Cancelled" };
const WARNAPP = { title: "Warning", variant: "warning", message: "Application Doesnt Match" };
const SUCCESSEVE = { title: "Success", variant: "success", message: "Successfully submitted the Appplication to AFG !!!" };
const ERROREVE = { title: "Error", variant: "error", message: "Failed to Submit Application !!!" };
const ERRORTIMEOUT = { title: "Error", variant: "error", message: "Server Timedout !!" };

const AFG_EVENT_CHANNEL = '/event/HLASubmittedToAFG__e';

export default class HlaNotifyAFGSubmission extends LightningElement
{

  _recordId;
  @api
  get recordId()
  {
    return this._recordId;
  }

  set recordId(recordId)
  {
    if (recordId !== this._recordId) {
      this._recordId = recordId;
    }
  }


  data; applicationId; recordName;
  @wire(getRecord, { recordId: "$recordId", fields: ["ResidentialLoanApplication__c.Name", "ResidentialLoanApplication__c.ApplicationId__c"] })
  RLA({ error, data })
  {
    if (data) {
      this.data = data;
      this.recordName = data.fields.Name.value;
      this.applicationId = data.fields.ApplicationId__c.value;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      console.log("🚀 ~ this.error:", this.error)
      this.data = undefined;
    }
  }

  //Apex http Callout
  handleSumbit()
  {
    this.doApexCallout();
  }


  httpRes; showModal = true; showProgressBar = false; correlationValue; @track isLoading = false;
  async doApexCallout()
  {
    this.showModal = false;
    this.isLoading = true;
    this.correlationValue = this.generateCorrelationId(3);
    try {
      let res = await requestAFGCallout({
        residentialLoanAppIds: [this._recordId],
        correlationId: this.correlationValue
      })
      await this.handleResponse(res);

    } catch (error) {
      console.error(error)
    } finally {
      this.isLoading = false;
    }


  }
  statusResult;
  handleResponse(response)
  {
    if (response >= 300) {
      this.showModal = false;
      this.showToast(ERROREVE);
      this.dispatchEvent(new CloseActionScreenEvent());
      this.updateRecordFields(this.statusResult = 'Callout-Failed');
      throw new Error(response);
    }
    this.showModal = false;
    this.showProgressBar = true;
    this.toggleProgress();
  }


  //Progress Bar Logic
  isProgressing = false; progress = 0; tries = 0; maxtries = 100;
  toggleProgress()
  {
    if (this.isProgressing) {
      this.isProgressing = false;
      clearInterval(this._interval);
    } else {
      this.isProgressing = true;
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this._interval = setInterval(() =>
      {
        this.progress = this.progress === 100 ? 0 : this.progress + 0.75;
        this.tries++;
        if (this.tries > this.maxtries) {
          this.stop();
          this.showToast(ERRORTIMEOUT);
          this.updateRecordFields(this.statusResult = 'Timed-Out');
        }
      }, 250);
    }
  }

  stop()
  {
    this.dispatchEvent(new CloseActionScreenEvent());
    clearInterval(this._interval);
  }

  //Platform Event Listener
  async connectedCallback()
  {
    console.log("🚀 ~ Platform Event Listening:")
    const isEmpApiEnabled = await isEmpEnabled();
    if (!isEmpApiEnabled) {
      this.reportError('The EMP API is not enabled.');
      return;
    }
    setDebugFlag(true);
    onError((error) =>
    {
      this.reportError('EMP API error', error);
    });

    try {
      this.subscription = await subscribe(
        AFG_EVENT_CHANNEL,
        -1,
        (event) =>
        {
          this.handlePlatformEvent(event);
        }
      );
    } catch (error) {
      this.reportError('EMP API error: failed to subscribe', error);
    }
    this.registerErrorListener();
  }


  //Platform event handling  
  afgId = '';errorLog;
  handlePlatformEvent(event)
  {
    console.log("🚀 ~ Platform event received:")
    if(event.data.payload?.Log__c){ 
      console.log("🚀 ~ Error From Middleware :", event.data.payload.Log__c);
    }
    const { AfgId__c: AfgId, ApplicationId__c: ApplicationId, CorrelationId__c: CorrelationId, SubmittedReturnValue__c: SubmittedReturnValue,Log__c: Errors, ...args } = event.data.payload;
    this.afgId = AfgId;
    this.applicationId = ApplicationId;
    this.correlationId = CorrelationId;
    this.status = SubmittedReturnValue;
    this.errorLog = Errors;
    this.stop();
    this.updateRecordFields(this.status);
    if (this.status === 'success' && ApplicationId === this.applicationId) {
      this.showToast(SUCCESSEVE)
      this.unsubscribeToMessageChannel();
    }
    else {
      this.showToast(ERROREVE);
    }
  }

  //Update Loan Application Record
  updateRecordFields(statusResult)
  {
    console.log("🚀 ~Starting to updateRecordFields:")
    const fields = {};
    fields[RLA_ID.fieldApiName] = this._recordId;
    fields[RLA_CORR_ID.fieldApiName] = this.correlationValue || this.CorrelationId;
    fields[RLA_AFGSTATUS.fieldApiName] = statusResult;
    fields[RLA_AFGID.fieldApiName] = this.afgId;
    fields[RLA_AFGError.fieldApiName] = this.errorLog || '' ;

    const recordInput = { fields };
    updateRecord(recordInput).then((res) =>
    {
      refreshApex(this.data);
    }).
      catch((err) => 
      {
        console.log("🚀 ~ Err:Updating Records", err)
      });
  }



  //misc
  unsubscribeToMessageChannel()
  {
    if (this.subscription) {
      unsubscribe(this.subscription, response =>
      {
        console.log('🚀 ~ Unsubscribed Event Channel');
      });
    }
  }

  generateCorrelationId(valLength)
  {
    let uiid = this._recordId.slice(-6).toLowerCase();
    for (let i = 0; i < valLength; i++) {
      uiid = uiid + '-' + this.random();
    }
    return uiid;

  }
  random()
  {
    return (Math.random() + 1).toString(36).substring(2);

  }

  sleep(ms)
  {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  handleCancel()
  {
    this.dispatchEvent(new CloseActionScreenEvent());
    this.showToast(WARN);
  }

  registerErrorListener()
  {
    // Invoke onError empApi method
    onError((error) =>
    {
      console.error('Received error from server: ');
    });
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
