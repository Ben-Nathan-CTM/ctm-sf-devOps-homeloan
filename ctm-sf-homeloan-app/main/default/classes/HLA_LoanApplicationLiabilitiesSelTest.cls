@isTest
public class HLA_LoanApplicationLiabilitiesSelTest {
  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicationLiabilitiesSelector selector = HLA_LoanApplicationLiabilitiesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicationLiabilitiesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanApplicationLiabilitiesSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationLiability__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanApplicationLiabilitiesSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationLiability__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanApplicationLiabilitiesSelector.newInstance()
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationLiabilitiesSelector sel = HLA_LoanApplicationLiabilitiesSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }

  @IsTest
  public static void should_getAdditionalSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationLiabilitiesSelector) HLA_LoanApplicationLiabilitiesSelector.newInstance())
      .getAdditionalSObjectFieldList();
    // Then
    Assert.istrue(fields.IsEmpty(), 'should return Empty List');
  }

  @IsTest
  public static void should_returnApplicationLiabilityListWithReferenceId() {
    // Given
    // When
    HLA_TestDataFactory.makeData('LoanApplicationLiability');
    LoanApplicationLiability__c rec = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplication__c
      FROM LoanApplicationLiability__c
      WHERE ReferenceId__c != ''
      LIMIT 1
    ];
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);
    Test.startTest();
    LoanApplicationLiability__c[] sel = ((HLA_LoanApplicationLiabilitiesSelector) HLA_LoanApplicationLiabilitiesSelector.newInstance())
      .selectLoanApplicationLiabilitiesByReferenceId(
        rec.ReferenceId__c,
        rec.ResidentialLoanApplication__c
      );
    Test.stopTest();
    // Then
    Assert.istrue(!sel.IsEmpty(), 'should return results');
  }
}
