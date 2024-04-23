@IsTest
public class HLA_LoanApplicantLiabilitiesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicantLiabilitiesSelector selector = HLA_LoanApplicantLiabilitiesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicantLiabilitiesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicantLiability__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicantLiability__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicantLiabilitiesSelector sel = ((HLA_LoanApplicantLiabilitiesSelector) HLA_LoanApplicantLiabilitiesSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
