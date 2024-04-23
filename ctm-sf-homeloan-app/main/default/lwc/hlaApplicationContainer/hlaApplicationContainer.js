import { LightningElement, api } from "lwc";

export default class HlaApplicationContainer extends LightningElement {
  @api recordId;

  selectedMenuItem = "goals_objectives";

  handleMenuSelect(event) {
    this.selectedMenuItem = event.detail.selectedMenuItem;
    console.log(this.selectedMenuItem);
  }
}
