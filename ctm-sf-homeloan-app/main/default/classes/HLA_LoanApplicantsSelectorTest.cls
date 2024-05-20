@IsTest
public class HLA_LoanApplicantsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantsSelector selector = HLA_LoanApplicantsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantsSelector) HLA_LoanApplicantsSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicant__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantsSelector) HLA_LoanApplicantsSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicant__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantsSelector) HLA_LoanApplicantsSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantsSelector sel = ((HLA_LoanApplicantsSelector) HLA_LoanApplicantsSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
