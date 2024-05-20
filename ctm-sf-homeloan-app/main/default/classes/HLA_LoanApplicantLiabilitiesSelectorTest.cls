@IsTest
public class HLA_LoanApplicantLiabilitiesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantLiabilitiesSelector selector = HLA_LoanApplicantLiabilitiesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantLiabilitiesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicantLiability__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicantLiability__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantLiabilitiesSelector sel = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }

  @IsTest
  public static void should_getAdditionalSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getAdditionalSObjectFieldList();
    // Then
    Assert.istrue(fields.IsEmpty(), 'should return Empty List');
  }

  @IsTest
  public static void should_returnApplicantIncomesListWithReferenceId() {
    // Given
    // When
    HLA_TestDataFactory.makeData('LoanApplicantLiability');
    LoanApplicantLiability__c rec = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplicationId__c
      FROM LoanApplicantLiability__c
      WHERE ReferenceId__c != ''
      LIMIT 1
    ];
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Test.startTest();
    LoanApplicantLiability__c[] sel = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .selectLoanApplicantLiabilitiesByReferenceId(
        rec.ReferenceId__c,
        rec.ResidentialLoanApplicationId__c
      );
    Test.stopTest();
    // Then
    Assert.istrue(!sel.IsEmpty(), 'should return results');
  }
}
