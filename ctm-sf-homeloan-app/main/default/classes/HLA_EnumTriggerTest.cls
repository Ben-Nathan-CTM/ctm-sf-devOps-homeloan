@IsTest
public class HLA_EnumTriggerTest {
  @IsTest
  public static void should_add_enum_to_related_global_picklist() {
    // Given

    // account field that uses 'Countries' global picklist
    SObjectField picklistUsingGlobal = SObjectType.Account.fields.CountryofBirth__c.getSObjectField();
    PicklistEntry plEntry = picklistUsingGlobal.getDescribe()
      .getPicklistValues()[0];

    String originalName = plentry.getValue();
    String originalLabel = plentry.getLabel();

    Enum__c testEnum0 = new Enum__c(
      EnumType__c = 'AssetTypes',
      DisplayName__c = originalLabel,
      Name = 'test',
      GlobalPicklistAPIName__c = 'Countries'
    );

    List<Enum__c> enumList = new List<Enum__c>{ testEnum0 };

    // When
    test.startTest();
    insert testEnum0;
    test.stopTest();

    // Then
  }
}
