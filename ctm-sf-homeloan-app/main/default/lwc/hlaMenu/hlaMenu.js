import { LightningElement } from "lwc";

export default class HlaMenu extends LightningElement {
  handleSelect(event) {
    const selectedName = event.detail.name;
    const selectEvent = new CustomEvent("menuselect", {
      detail: { selectedMenuItem: selectedName }
    });
    this.dispatchEvent(selectEvent);
  }
}
