@IsTest
public class HLA_LoanCostsSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanCostsSelector selector = HLA_LoanCostsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanCostsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_LoanCostsSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanCost__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_LoanCostsSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanCost__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_LoanCostsSelector.newInstance().getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanCostsSelector sel = HLA_LoanCostsSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
