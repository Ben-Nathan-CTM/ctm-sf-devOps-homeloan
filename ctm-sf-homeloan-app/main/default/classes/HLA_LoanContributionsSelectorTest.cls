@IsTest
public class HLA_LoanContributionsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanContributionsSelector selector = HLA_LoanContributionsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanContributionsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanContributionsSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanContribution__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanContributionsSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanContribution__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanContributionsSelector.newInstance().getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanContributionsSelector sel = HLA_LoanContributionsSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
