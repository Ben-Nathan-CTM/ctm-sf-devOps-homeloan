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

  @IsTest
  public static void should_returnApplicantExpenseListWithReferenceId() {
    // Given
    // When
    HLA_TestDataFactory.makeData('LoanApplicantExpense');
    LoanApplicantExpense__c rec = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplication__c
      FROM LoanApplicantExpense__c
      WHERE ReferenceId__c != ''
      LIMIT 1
    ];
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);
    Test.startTest();
    LoanApplicantExpense__c[] sel = ((HLA_LoanApplicantExpensesSelector) HLA_LoanApplicantExpensesSelector.newInstance())
      .selectLoanApplicantExpensesByReferenceId(
        rec.ReferenceId__c,
        rec.ResidentialLoanApplication__c
      );
    Test.stopTest();
    // Then
    Assert.istrue(!sel.IsEmpty(), 'should return results');
  }
}
