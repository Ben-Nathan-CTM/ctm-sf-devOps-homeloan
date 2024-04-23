@IsTest
public class HLA_LoanApplicantEmploymentsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantEmploymentsSelector selector = HLA_LoanApplicantEmploymentsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantEmploymentsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantEmploymentsSelector) HLA_LoanApplicantEmploymentsSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicantEmployment__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantEmploymentsSelector) HLA_LoanApplicantEmploymentsSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicantEmployment__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantEmploymentsSelector) HLA_LoanApplicantEmploymentsSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantEmploymentsSelector sel = ((HLA_LoanApplicantEmploymentsSelector) HLA_LoanApplicantEmploymentsSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
