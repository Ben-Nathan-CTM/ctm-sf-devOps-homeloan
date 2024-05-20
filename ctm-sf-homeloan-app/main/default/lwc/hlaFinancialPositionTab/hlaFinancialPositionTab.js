import { LightningElement, api } from "lwc";

export default class HlaFinancialPositionTab extends LightningElement {
  @api recordId;

  error;
  isLoading = true;

  handleLoading() {
    this.isLoading = true;
  }

  handleLoadingDone() {
    this.isLoading = false;
  }
}
