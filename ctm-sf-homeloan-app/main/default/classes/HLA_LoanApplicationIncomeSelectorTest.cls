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

  @IsTest
  public static void should_getAdditionalSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationIncomeSelector) HLA_LoanApplicationIncomeSelector.newInstance())
      .getAdditionalSObjectFieldList();
    // Then
    Assert.istrue(fields.IsEmpty(), 'should return Empty List');
  }

  @IsTest
  public static void should_returnApplicationIncomeListWithReferenceId() {
    // Given
    // When
    TestDataFactory.makeData('LoanApplicationIncome');
    LoanApplicationIncome__c rec = [
      SELECT id, name, ReferenceId__c, ResidentialLoanApplication__c
      FROM LoanApplicationIncome__c
      WHERE ReferenceId__c != ''
    ];

    Test.startTest();
    LoanApplicationIncome__c[] sel = ((HLA_LoanApplicationIncomeSelector) HLA_LoanApplicationIncomeSelector.newInstance())
      .selectLoanApplicationIncomesByReferenceId(
        rec.ReferenceId__c,
        rec.ResidentialLoanApplication__c
      );
    Test.stopTest();
    // Then
    Assert.istrue(!sel.IsEmpty(), 'should return results');
  }
}
