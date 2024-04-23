import { LightningElement, api } from "lwc";

export default class HlaKeyIndicators extends LightningElement {
  @api indicators = [
    { id: 0, label: "Owner Occupied" },
    { id: 1, label: "Interest Only" }
  ];
}
