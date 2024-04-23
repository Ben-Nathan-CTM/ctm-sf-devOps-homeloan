@IsTest
public class HLA_LoanApplicationExpensesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicationExpensesSelector selector = HLA_LoanApplicationExpensesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicationExpensesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanApplicationExpensesSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationExpense__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanApplicationExpensesSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationExpense__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanApplicationExpensesSelector.newInstance()
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationExpensesSelector sel = HLA_LoanApplicationExpensesSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
