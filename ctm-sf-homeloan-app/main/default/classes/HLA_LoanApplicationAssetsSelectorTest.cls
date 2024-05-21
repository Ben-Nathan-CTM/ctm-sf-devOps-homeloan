@IsTest
public class HLA_LoanApplicationAssetsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicationAssetsSelector selector = HLA_LoanApplicationAssetsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicationAssetsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationAssetsSelector) HLA_LoanApplicationAssetsSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationAsset__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicationAssetsSelector) HLA_LoanApplicationAssetsSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationAsset__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicationAssetsSelector) HLA_LoanApplicationAssetsSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationAssetsSelector sel = ((HLA_LoanApplicationAssetsSelector) HLA_LoanApplicationAssetsSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
  @IsTest
  public static void should_getAdditionalSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationAssetsSelector) HLA_LoanApplicationAssetsSelector.newInstance())
      .getAdditionalSObjectFieldList();
    // Then
    Assert.istrue(fields.IsEmpty(), 'should return Empty List');
  }

  @IsTest
  public static void should_returnApplicationAssetsListWithReferenceId() {
    // Given
    // When
    HLA_TestDataFactory.makeData('LoanApplicationAsset');
    LoanApplicationAsset__c rec = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplication__c
      FROM LoanApplicationAsset__c
      WHERE ReferenceId__c != ''
      LIMIT 1
    ];
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Test.startTest();
    LoanApplicationAsset__c[] sel = ((HLA_LoanApplicationAssetsSelector) HLA_LoanApplicationAssetsSelector.newInstance())
      .selectLoanApplicationAssetsByReferenceId(
        rec.ReferenceId__c,
        rec.ResidentialLoanApplication__c
      );
    Test.stopTest();
    // Then
    Assert.istrue(!sel.IsEmpty(), 'should return results');
  }
}
