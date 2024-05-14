@isTest
public class HLA_AddFinancialstoRLAServiceTest {
  @isTest
  public static void createsPayloadandDoesHttpCallout() {
    TestDataFactory.makeData('LoanApplicationLiability');
    LoanApplicationLiability__c lasset = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplication__c
      FROM LoanApplicationLiability__c
      WHERE ReferenceId__c != ''
      LIMIT 1
    ];

    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, mockHttp);
    HLA_AddFinancialstoRLAService.createPayloadFlowCreatedFinancialRecords(
      lasset.ReferenceId__c,
      lasset.ResidentialLoanApplication__c
    );

    Test.stopTest();
    system.assert(
      MockHttpResponseGenerator.calloutCounter == 6,
      'should have generated 6 mock callouts'
    );
  }
}
