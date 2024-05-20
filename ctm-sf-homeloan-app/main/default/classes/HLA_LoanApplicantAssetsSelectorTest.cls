@IsTest
public class HLA_LoanApplicantAssetsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantAssetsSelector selector = HLA_LoanApplicantAssetsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantAssetsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantAssetsSelector) HLA_LoanApplicantAssetsSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicantAsset__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantAssetsSelector) HLA_LoanApplicantAssetsSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicantAsset__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantAssetsSelector) HLA_LoanApplicantAssetsSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantAssetsSelector sel = ((HLA_LoanApplicantAssetsSelector) HLA_LoanApplicantAssetsSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }

  @IsTest
  public static void should_getAdditionalSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantAssetsSelector) HLA_LoanApplicantAssetsSelector.newInstance())
      .getAdditionalSObjectFieldList();
    // Then
    Assert.istrue(fields.IsEmpty(), 'should return Empty List');
  }

  @IsTest
  public static void should_returnApplicantAssetListWithReferenceId() {
    // Given
    // When
    HLA_TestDataFactory.makeData('LoanApplicantAsset');
    LoanApplicantAsset__c rec = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplicationId__c
      FROM LoanApplicantAsset__c
      WHERE ReferenceId__c != ''
      LIMIT 1
    ];
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);
    Test.startTest();
    LoanApplicantAsset__c[] sel = ((HLA_LoanApplicantAssetsSelector) HLA_LoanApplicantAssetsSelector.newInstance())
      .selectLoanApplicantAssetsByReferenceId(
        rec.ReferenceId__c,
        rec.ResidentialLoanApplicationId__c
      );
    Test.stopTest();
    // Then
    Assert.istrue(!sel.IsEmpty(), 'should return results');
  }
}
