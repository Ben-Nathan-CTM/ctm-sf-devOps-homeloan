import { LightningElement, api } from "lwc";

export default class HlaLoanCosts extends LightningElement {
  costs = [];

  @api
  set loanCosts(value) {
    this.processLoanCosts(value);
  }

  get loanCosts() {
    return this.costs;
  }

  processLoanCosts(loanCosts) {
    this.costs = loanCosts.map((cost) => {
      return Object.assign(
        {},
        { Id: cost.id, Type: cost.Type__c, Value: cost.Amount__c }
      );
    });
  }
}
