import { LightningElement, api, wire } from "lwc";
import { subscribe, onError, unsubscribe } from "lightning/empApi";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";

import PRODUCT_PRODUCT_NAME from "@salesforce/schema/LoanApplicationProduct__c.ProductName__c";
import PRODUCT_LMI from "@salesforce/schema/LoanApplicationProduct__c.LMIAmount__c";
import PRODUCT_LOAN_AMOUNT from "@salesforce/schema/LoanApplicationProduct__c.LoanAmount__c";
import PRODUCT_LVR from "@salesforce/schema/LoanApplicationProduct__c.LVR__c";
import PRODUCT_LENDER_NAME from "@salesforce/schema/LoanApplicationProduct__c.Lender__r.Name";
import PRODUCT_LENDER_LOGO from "@salesforce/schema/LoanApplicationProduct__c.Lender__r.logoRectangleUrl__c";
import PRODUCT_ID from "@salesforce/schema/LoanApplicationProduct__c.Id";

const PRODUCT_FIELDS = [
  PRODUCT_ID,
  PRODUCT_PRODUCT_NAME,
  PRODUCT_LMI,
  PRODUCT_LOAN_AMOUNT,
  PRODUCT_LVR,
  PRODUCT_LENDER_NAME,
  PRODUCT_LENDER_LOGO
];
export default class HlaSelectedProductInfo extends NavigationMixin(
  LightningElement
) {
  @api selectedProductId;
  @api residentialLoanApplicationId;

  channelName = "/event/HLA_ProductSelected__e";
  subscription = null;

  @wire(getRecord, { recordId: "$selectedProductId", fields: PRODUCT_FIELDS })
  selectedProduct;

  get productName() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_PRODUCT_NAME);
  }
  get lmi() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_LMI);
  }
  get loanAmount() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_LOAN_AMOUNT);
  }
  get lvr() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_LVR);
  }
  get lenderName() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_LENDER_NAME);
  }
  get logoURL() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_LENDER_LOGO);
  }

  get productId() {
    return getFieldValue(this.selectedProduct.data, PRODUCT_ID);
  }

  handleProductNameClick(event) {
    event.preventDefault();
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.productId,
        objectApiName: "LoanApplicationProduct__c",
        actionName: "view"
      }
    });
  }

  connectedCallback() {
    this.registerErrorListener();
    this.subscribePRE();
  }

  registerErrorListener() {
    onError((error) => {
      console.error("Received error from server: ", JSON.stringify(error));
    });
  }

  subscribePRE() {
    if (this.subscription) {
      return;
    }
    subscribe(this.channelName, -1, (message) => {
      const productId = message.data.payload.SelectedProductId__c;
      const applicationId =
        message.data.payload.ResidentialLoanApplicationId__c;
      if (applicationId === this.residentialLoanApplicationId) {
        this.selectedProductId = productId;
      }
    }).then((subscriptionResponse) => {
      this.subscription = subscriptionResponse;
    });
  }

  disconnectedCallback() {
    this.unsubscribeFromMessageChannel();
  }

  unsubscribeFromMessageChannel() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }
}
