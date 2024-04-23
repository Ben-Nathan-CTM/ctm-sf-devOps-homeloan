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
}
