@IsTest
public class HLA_LoanApplicationIncomeSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicationIncomeSelector selector = HLA_LoanApplicationIncomeSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicationIncomeSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanApplicationIncomeSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationIncome__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanApplicationIncomeSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationIncome__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanApplicationIncomeSelector.newInstance()
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationIncomeSelector sel = HLA_LoanApplicationIncomeSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
