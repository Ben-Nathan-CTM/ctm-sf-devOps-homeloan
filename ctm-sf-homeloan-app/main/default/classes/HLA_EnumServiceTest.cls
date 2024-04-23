@IStest
public class HLA_EnumServiceTest {
  @IsTest
  public static void should_set_enum_value_to_next_available() {
    // Given

    Enum__c testEnum0 = new Enum__c();
    Enum__c testEnum1 = new Enum__c();
    List<Enum__c> enumList = new List<Enum__c>{ testEnum0, testEnum1 };

    // When
    test.startTest();
    HLA_EnumService.setEnumValues(enumList);
    test.stopTest();

    // Then
    System.assertEquals(0, testEnum0.value__c, 'should have set to 0');
    System.assertEquals(1, testEnum1.value__c, 'should have set to 1');
  }

  @IsTest
  public static void should_get_all_active_enums_mapped_by_type() {
    // Given
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    HLA_IEnumsSelector mockEnumSelector = (HLA_IEnumsSelector) mocks.mock(
      HLA_EnumsSelector.class
    );

    Enum__c testEnum = new Enum__c(
      EnumType__c = 'AssetTypes',
      DisplayName__c = 'test',
      Name = 'test'
    );

    List<Enum__c> enumList = new List<Enum__c>{ testEnum };

    mocks.StartStubbing();
    mocks.when(mockEnumSelector.SObjectType()).thenReturn(Enum__c.sObjectType);
    mocks.when(mockEnumSelector.selectAllActiveEnums()).thenReturn(enumList);
    mocks.StopStubbing();

    Application.Selector.setMock(mockEnumSelector);

    // When
    test.startTest();
    Map<String, List<HLA_Enums.EnumItem>> enumMap = HLA_EnumService.getAllActiveEnumsMappedByType();
    test.stopTest();

    // Then

    System.assert(
      enumMap.containsKey('AssetTypes'),
      'should have added an enum entry for the test enum'
    );

    ((HLA_IEnumsSelector) mocks.verify(mockEnumSelector, 1))
      .selectAllActiveEnums();
  }
}
