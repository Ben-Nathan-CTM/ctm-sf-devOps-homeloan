@IsTest
public class HLA_LoanSecuritiesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanSecuritiesSelector selector = HLA_LoanSecuritiesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanSecuritiesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanSecuritiesSelector) HLA_LoanSecuritiesSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanSecurity__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanSecuritiesSelector) HLA_LoanSecuritiesSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanSecurity__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanSecuritiesSelector) HLA_LoanSecuritiesSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanSecuritiesSelector sel = ((HLA_LoanSecuritiesSelector) HLA_LoanSecuritiesSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
