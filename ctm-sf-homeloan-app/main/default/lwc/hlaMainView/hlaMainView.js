import { LightningElement, api } from "lwc";

export default class HlaMainView extends LightningElement {
  goalsSelected = true;
  loanSummarySelected = false;
  applicantDetailsSelected = false;
  financialPositionSelected = false;
  lenderElegibilitySelected = false;
  responsibleLendingSelected = false;
  #selectedMenuItem;

  @api applicationId;

  @api
  get selectedMenuItem() {
    return this.#selectedMenuItem;
  }
  set selectedMenuItem(value) {
    this.#selectedMenuItem = value;
    this.setSelectedValue(value);
  }

  setSelectedValue(value) {
    this.clearCurrentSelection();
    switch (value) {
      case "goals_objectives":
        this.goalsSelected = true;
        break;
      case "loan_summary":
        this.loanSummarySelected = true;
        break;
      case "applicant_details":
        this.applicantDetailsSelected = true;
        break;
      case "financial_position":
        this.financialPositionSelected = true;
        break;
      case "lender_eligibility":
        this.lenderElegibilitySelected = true;
        break;
      case "responsible_lending":
        this.responsibleLendingSelected = true;
        break;
      default:
        this.goalsSelected = true;
    }
  }

  clearCurrentSelection() {
    this.goalsSelected = false;
    this.loanSummarySelected = false;
    this.applicantDetailsSelected = false;
    this.financialPositionSelected = false;
    this.lenderElegibilitySelected = false;
    this.responsibleLendingSelected = false;
  }
}
