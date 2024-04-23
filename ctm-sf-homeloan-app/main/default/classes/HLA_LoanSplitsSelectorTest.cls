@IsTest
public class HLA_LoanSplitsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanSplitsSelector selector = HLA_LoanSplitsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanSplitsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanSplitsSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanSplit__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanSplitsSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanSplit__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanSplitsSelector.newInstance().getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanSplitsSelector sel = HLA_LoanSplitsSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
