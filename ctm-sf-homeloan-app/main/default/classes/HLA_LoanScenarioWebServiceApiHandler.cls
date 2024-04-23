public with sharing class HLA_LoanScenarioWebServiceApiHandler extends Api.Handler {
  //

  public HLA_LoanScenarioWebServiceApiHandler() {
    super();
  }

  public override Api.Response doPut(ApiRequestResolver resolver) {
    try {
      Loan_Scenario__c loanScenarioRecord = HLA_LoanScenarioService.parseAndCreateNewLoanScenario(
        resolver.requestBody
      );
      Api.Response res = new Api.Response(loanScenarioRecord.Id);
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      return res;
    }
  }
}