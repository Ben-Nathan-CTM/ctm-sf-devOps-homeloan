import { LightningElement, api, wire } from "lwc";
import { getRelatedListRecords } from "lightning/uiRelatedListApi";

const LOAN_APPLICATION_PRODUCT_RELATEDLIST_API = "Loan_Application_Products__r";

export default class HlaKeyInformationPanel extends LightningElement {
  @api recordId;
  selectedProductId;

  error;
  records;

  @wire(getRelatedListRecords, {
    parentRecordId: "$recordId",
    relatedListId: LOAN_APPLICATION_PRODUCT_RELATEDLIST_API,
    fields: ["LoanApplicationProduct__c.Id"],
    where: "{ SelectedProduct__c: { eq: true }}"
  })
  selectedProductInfo({ error, data }) {
    if (data) {
      this.selectedProductId = data.records[0].id;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.selectedProductId = undefined;
    }
  }
}
