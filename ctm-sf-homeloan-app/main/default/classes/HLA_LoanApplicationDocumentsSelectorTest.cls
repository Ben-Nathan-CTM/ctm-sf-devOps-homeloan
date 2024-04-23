@IsTest
public class HLA_LoanApplicationDocumentsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicationDocumentsSelector selector = HLA_LoanApplicationDocumentsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicationDocumentsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationDocumentsSelector) HLA_LoanApplicationDocumentsSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationDocument__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicationDocumentsSelector) HLA_LoanApplicationDocumentsSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationDocument__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicationDocumentsSelector) HLA_LoanApplicationDocumentsSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationDocumentsSelector sel = ((HLA_LoanApplicationDocumentsSelector) HLA_LoanApplicationDocumentsSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
