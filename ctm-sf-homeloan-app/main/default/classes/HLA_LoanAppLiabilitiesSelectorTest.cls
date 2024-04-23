@IsTest
public class HLA_LoanAppLiabilitiesSelectorTest {
  // full name for class was too long

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
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationLiabilitiesSelector) HLA_LoanApplicationLiabilitiesSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationLiability__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicationLiabilitiesSelector) HLA_LoanApplicationLiabilitiesSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationLiability__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicationLiabilitiesSelector) HLA_LoanApplicationLiabilitiesSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationLiabilitiesSelector sel = ((HLA_LoanApplicationLiabilitiesSelector) HLA_LoanApplicationLiabilitiesSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
