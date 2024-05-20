import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class HlaSNoteFlowModal extends LightningModal {
  @api inputVariables;

  handleClose() {
    this.close("finished");
  }

  handleStatusChangeEvent(event) {
    event.stopPropagation();
    let status = event.detail.status;
    if (status === "FINISHED") {
      this.handleClose();
    }
  }
}
