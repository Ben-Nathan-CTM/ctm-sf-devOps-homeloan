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
}
