import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
const fields = ["Account.Name"];
import getProductList from "@salesforce/apex/HLA_LenderProductSearch.getProductList";

export default class LenderProductList extends LightningElement {
  //Current Record
  @api recordId;
  lender;

  //Error Handling
  showError;
  errorMessage;

  //Data
  @track products;

  //Loading
  loading = true;

  //Get Data from the current record
  @wire(getRecord, { recordId: "$recordId", fields })
  wireRecord({ error, data }) {
    if (data) {
      const acc = data.fields;
      console.log(acc);
      this.lender = acc.Name.value;
      console.log(this.lender);
    } else if (error) {
      this.stopLoading(500);
      this.showError = true;
      this.errorMessage = error.errorMessage;
    }
  }

  //Get the product list from the ctm product endpoint once the lender name is populated
  @wire(getProductList, {
    lender: "$lender"
  })
  wireProducts({ error, data }) {
    if (data) {
      this.stopLoading(500);
      console.log(JSON.parse(data).results);
      this.products = JSON.parse(data).results;
    } else if (error) {
      this.stopLoading(500);
      this.showError = true;
      this.error = error.errorMessage;
      this.products = undefined;
    }
  }
  // Handle loading
  stopLoading(timeoutValue) {
    setTimeout(() => {
      this.loading = false;
    }, timeoutValue);
  }
}