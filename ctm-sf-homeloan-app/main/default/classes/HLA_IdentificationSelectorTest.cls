@IsTest
public class HLA_IdentificationSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_IIdentificationSelector selector = HLA_IdentificationSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_IdentificationSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_IdentificationSelector) HLA_IdentificationSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(Identification__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_IdentificationSelector) HLA_IdentificationSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == Identification__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_IdentificationSelector) HLA_IdentificationSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_IdentificationSelector sel = ((HLA_IdentificationSelector) HLA_IdentificationSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }
}
