@IsTest
public class HLA_CreditScoreServiceTest {
  //

  @TestSetup
  static void setupData() {
    Account testAcct = new Account(
      firstname = 'test',
      lastname = 'acct',
      customerid__c = '123',
      CreditScoreID__c = 'id1',
      OriginalCreditCheckDate__c = System.today().addMonths(-4),
      LatestCreditCheckDate__c = System.today().addMonths(-3)
    );

    insert testAcct;
  }

  @IsTest
  public static void selectAccountsDueForCreditAssessment() {
    List<Account> accounts = HLA_CreditScoreService.selectAccountsDueForCreditAssessment();
    system.debug(accounts);
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    Test.StartTest();
    HLA_CreditScoreService.requestAccountCreditScoreAssessment(accounts);
    Test.StopTest();

    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      2,
      'should have made 2 callouts'
    );
  }

  @IsTest
  public static void should_delete_creditscores_for_applicant_externalids() {
    // Given
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    IApplicationSObjectUnitOfWork mockUoW = (IApplicationSObjectUnitOfWork) mocks.mock(
      ApplicationSObjectUnitOfWork.class
    );
    Application.UnitOfWork.setMock(mockUoW);

    HLA_ICreditScoreSelector mockSelector = (HLA_ICreditScoreSelector) mocks.mock(
      HLA_CreditScoreSelector.class
    );

    CreditScore__c testCreditScore = new CreditScore__c(
      LoanApplicant__c = fflib_IDGenerator.generate(
        LoanApplicant__c.SObjectType
      ),
      name = 'testCred'
    );
    List<CreditScore__c> credList = new List<CreditScore__c>();
    credList.add(testCreditScore);

    Set<String> testStringSet = new Set<String>{ 'test' };

    mocks.startStubbing();
    mocks.when(mockSelector.SObjectType())
      .thenReturn(CreditScore__c.sObjectType);

    mocks.when(
        mockSelector.selectCreditScoreUsingApplicantExternalId(testStringSet)
      )
      .thenReturn(credList);

    mocks.stopStubbing();
    Application.Selector.setMock(mockSelector);

    // When
    Test.StartTest();
    HLA_CreditScoreService.deleteCreditScoresUsingApplicantExternalIds(
      testStringSet
    );
    Test.StopTest();

    // verify
    ((HLA_ICreditScoreSelector) mocks.verify(mockSelector))
      .selectCreditScoreUsingApplicantExternalId(testStringSet);
    ((IApplicationSObjectUnitOfWork) mocks.verify(mockUoW, 1)).commitWork();
  }
}
