@IsTest
public class HLA_CreditScoreSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ICreditScoreSelector selector = HLA_CreditScoreSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_CreditScoreSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_CreditScoreSelector) HLA_CreditScoreSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(CreditScore__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_CreditScoreSelector) HLA_CreditScoreSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == CreditScore__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_CreditScoreSelector) HLA_CreditScoreSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_CreditScoreSelector sel = ((HLA_CreditScoreSelector) HLA_CreditScoreSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }

  @IsTest
  public static void should_select_credit_scores_to_delete() {
    // Given

    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account testAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      CustomerId__c = '123',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );
    uow.register(testAcc);

    ResidentialLoanApplication__c mockResi = new ResidentialLoanApplication__c(
      Account__c = testAcc.id,
      name = 'test RLA',
      ApplicationId__c = '123'
    );
    uow.register(mockResi, ResidentialLoanApplication__c.Account__c, testAcc);

    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      ResidentialLoanApplication__c = mockResi.id,
      EmailAddress__c = 'test@gmail.com',
      PersonType__c = '831',
      ExternalId__c = '1234'
    );
    //uow.register(testLoanApplicant);
    uow.register(
      testLoanApplicant,
      LoanApplicant__c.ResidentialLoanApplication__c,
      mockResi
    );

    CreditScore__c testCreditScore = new CreditScore__c(
      LoanApplicant__c = testLoanApplicant.id,
      name = 'testCred'
    );
    //uow.register(testCreditScore);
    uow.register(
      testCreditScore,
      CreditScore__c.LoanApplicant__c,
      testLoanApplicant
    );
    uow.commitWork();

    // When
    List<CreditScore__c> credList = ((HLA_CreditScoreSelector) HLA_CreditScoreSelector.newInstance())
      .selectCreditScoreUsingApplicantExternalId(new Set<String>{ '1234' });
    // Then
    Assert.isNotNull(credList, 'should have selected credit score');
    Assert.isFalse(credList.isEmpty(), 'should have selected credit score');
  }
}
