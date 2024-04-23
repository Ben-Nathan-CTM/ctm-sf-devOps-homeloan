import { LightningElement, api } from "lwc";

export default class HlaCustomImageColumn extends LightningElement {
  @api productId;
  @api lenderImageUrl;
  @api title;
  @api selected;

  handleImageclicked(e) {
    e.preventDefault();
    const event = new CustomEvent("imageclicked", {
      composed: true,
      bubbles: true,
      cancelable: true,
      detail: {
        recordId: this.productId
      }
    });
    this.dispatchEvent(event);
  }
}
