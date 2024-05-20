@IsTest
public class HLA_LoanEquityReleasesSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanEquityReleasesSelector selector = HLA_LoanEquityReleasesSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanEquityReleasesSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanEquityReleasesSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanEquityRelease__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanEquityReleasesSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanEquityRelease__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanEquityReleasesSelector.newInstance().getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanEquityReleasesSelector sel = HLA_LoanEquityReleasesSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
