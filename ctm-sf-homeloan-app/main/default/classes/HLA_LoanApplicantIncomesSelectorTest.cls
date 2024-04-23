@IsTest
public class HLA_LoanApplicantIncomesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantIncomesSelector selector = HLA_LoanApplicantIncomesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantIncomesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantIncomesSelector) HLA_LoanApplicantIncomesSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicantIncome__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantIncomesSelector) HLA_LoanApplicantIncomesSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicantIncome__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantIncomesSelector) HLA_LoanApplicantIncomesSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantIncomesSelector sel = ((HLA_LoanApplicantIncomesSelector) HLA_LoanApplicantIncomesSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
