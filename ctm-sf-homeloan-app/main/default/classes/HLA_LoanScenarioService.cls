public with sharing class HLA_LoanScenarioService implements HLA_ILoanScenarioService {
  //

  private static HLA_ILoanScenarioService service() {
    return (HLA_ILoanScenarioService) Application.Service.newInstance(
      HLA_ILoanScenarioService.class
    );
  }

  public static Loan_Scenario__c parseAndCreateNewLoanScenario(
    String requestBody
  ) {
    return service().parseAndCreateNewLoanScenario(requestBody);
  }
}