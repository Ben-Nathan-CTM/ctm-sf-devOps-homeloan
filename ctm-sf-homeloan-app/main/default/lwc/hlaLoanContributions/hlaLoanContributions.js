import { LightningElement, api } from "lwc";

export default class HlaLoanContributions extends LightningElement {
  contributions = [];

  @api
  set loanContributions(value) {
    this.processloanContributions(value);
  }

  get loanContributions() {
    return this.contributions;
  }

  processloanContributions(loanContributions) {
    this.contributions = loanContributions.map((contribution) => {
      return Object.assign(
        {},
        {
          Id: contribution.id,
          Type: contribution.Type__c,
          Value: contribution.amount__c
        }
      );
    });
  }
}
