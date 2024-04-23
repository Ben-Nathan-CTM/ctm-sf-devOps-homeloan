public with sharing class HLA_LoanScenarioServiceImp implements HLA_ILoanScenarioService {
  public Loan_Scenario__c parseAndCreateNewLoanScenario(String requestBody) {
    Loan_Scenario__c loanScenarioRecord = (Loan_Scenario__c) JSON.deserialize(
      requestBody,
      Loan_Scenario__c.class
    );

    upsert loanScenarioRecord;
    return loanScenarioRecord;
  }
}