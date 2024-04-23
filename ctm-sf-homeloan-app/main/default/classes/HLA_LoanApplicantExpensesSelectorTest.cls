@IsTest
public class HLA_LoanApplicantExpensesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantExpensesSelector selector = HLA_LoanApplicantExpensesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantExpensesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantExpensesSelector) HLA_LoanApplicantExpensesSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicantExpense__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantExpensesSelector) HLA_LoanApplicantExpensesSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicantExpense__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantExpensesSelector) HLA_LoanApplicantExpensesSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantExpensesSelector sel = ((HLA_LoanApplicantExpensesSelector) HLA_LoanApplicantExpensesSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
