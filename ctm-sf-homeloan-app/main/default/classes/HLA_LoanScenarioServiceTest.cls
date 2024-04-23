@IsTest
public class HLA_LoanScenarioServiceTest {
  @IsTest
  public static void should_parse_and_create_loan_scenario() {
    // Given

    String loanScenarioJSON = '{"name":"test"}';

    // When

    Loan_Scenario__c ls = HLA_LoanScenarioService.parseAndCreateNewLoanScenario(
      loanScenarioJSON
    );
    // Then
    ls = [SELECT name FROM Loan_Scenario__c WHERE Id = :ls.id];
    system.assertEquals(
      'test',
      ls.name,
      'should have parsed and inserted loan scenarion'
    );
  }
}