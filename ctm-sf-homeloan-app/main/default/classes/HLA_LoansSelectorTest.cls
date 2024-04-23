@IsTest
public class HLA_LoansSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoansSelector selector = HLA_LoansSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoansSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoansSelector) HLA_LoansSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(Loan__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoansSelector) HLA_LoansSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == Loan__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoansSelector) HLA_LoansSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoansSelector sel = ((HLA_LoansSelector) HLA_LoansSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
