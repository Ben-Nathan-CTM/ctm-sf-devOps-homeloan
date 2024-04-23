@IsTest
public class HLA_EnumsSelectorTest {
  //

  @IsTest
  public static void should_create_new_instance() {
    // Given

    // When
    HLA_IEnumsSelector testSelector = HLA_EnumsSelector.newinstance();

    // Then
    System.Assert(testSelector instanceof HLA_EnumsSelector);
  }

  @IsTest
  public static void should_get_field_list() {
    // Given

    // When
    List<Schema.SObjectField> listOfFields = HLA_EnumsSelector.newinstance()
      .getSObjectFieldList();

    // Then
    System.Assert(!listOfFields.isEmpty());
  }

  @Istest
  public static void should_set_sort_order() {
    // Given
    HLA_IEnumsSelector mockselector = HLA_EnumsSelector.newinstance();
    mockselector = mockselector.setNewSortOrder('DisplayName__c');

    // When
    String newOrderField = mockselector.getOrderBy();

    // Then

    system.assertEquals(
      'DisplayName__c',
      newOrderField,
      'shoud have set the new sort order'
    );
  }

  @Istest
  public static void should_select_all_active() {
    // Given

    Enum__c testEnum0 = new Enum__c(
      EnumType__c = 'AssetTypes',
      DisplayName__c = 'test',
      Name = 'test',
      Active__c = true
    );

    insert testEnum0;

    // When
    List<Enum__c> enumList = HLA_EnumsSelector.newinstance()
      .selectAllActiveEnums();

    // Then

    system.assertEquals(
      'test',
      enumList[0].name,
      'shoud have selected the active enum'
    );
  }
}
