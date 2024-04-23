public inherited sharing class HLA_Enums extends ApplicationSObjectDomain implements HLA_IEnums {
  private Map<String, List<EnumItem>> enumItemMap;

  public static HLA_IEnums newInstance(List<Enum__c> records) {
    return (HLA_IEnums) Application.Domain.newInstance(records);
  }

  public static HLA_IEnums newInstance(Set<Id> recordIds) {
    return (HLA_IEnums) Application.Domain.newInstance(recordIds);
  }

  public HLA_Enums(List<Enum__c> enums) {
    super(enums);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_Enums(sObjectList);
    }
  }

  private List<Enum__c> enumsRecords {
    get {
      if (enumsRecords == null) {
        enumsRecords = (List<Enum__c>) records;
      }
      return enumsRecords;
    }
    private set;
  }

  private Map<String, HLA_EnumMapping__mdt> enumMappings {
    get {
      if (enumMappings == null) {
        enumMappings = new Map<String, HLA_EnumMapping__mdt>();
        enumMappings.putall(HLA_EnumMapping__mdt.getAll());
      }
      return enumMappings;
    }
    private set {
    }
  }

  public List<Enum__c> getEnumsRecords() {
    return this.enumsRecords;
  }

  public override void onBeforeInsert() {
    HLA_EnumService.setEnumValues(enumsRecords);
  }

  public override void onAfterInsert() {
    System.enqueueJob(
      new HLA_EnumUpdateRelatedPicklistsQueueable(enumsRecords)
    );
  }

  public override void onAfterUpdate(Map<Id, SObject> enumRecordsMap) {
    System.enqueueJob(
      new HLA_EnumUpdateRelatedPicklistsQueueable(enumsRecords)
    );
  }
  public override void onAfterDelete() {
    System.enqueueJob(
      new HLA_EnumUpdateRelatedPicklistsQueueable(enumsRecords)
    );
  }

  public void setEnumValues() {
    for (Enum__c en : (List<Enum__c>) records) {
      if (en.Value__c == null) {
        en.Value__c = nextEnumValue;
      }
      en.GlobalPicklistAPIName__c = enumMappings.get(en.EnumType__c)
        ?.GlobalPicklistAPIName__c;
    }
  }

  /* Returns the next available Enum Value__c
   * making it static incase it is called from multiple places in a single transaction
   * */
  public static Integer nextEnumValue {
    get {
      if (nextEnumValue == null) {
        List<Enum__c> enumFound = [
          SELECT value__c
          FROM Enum__c
          WHERE Value__c != NULL
          ORDER BY value__c DESC
          LIMIT 1
        ];
        nextEnumValue = Integer.valueOf(
          enumFound.isEmpty() ? 0 : enumFound[0].Value__c + 1
        );
      }
      return nextEnumValue++;
    }
    private set {
    }
  }

  public Map<String, List<EnumItem>> getEnumItemMap() {
    if (enumItemMap == null) {
      enumItemMap = new Map<String, List<EnumItem>>();
      for (Enum__c en : (List<Enum__c>) records) {
        EnumItem item = new EnumItem();
        item.enumName = en.Name;
        item.label = en.DisplayName__c;
        item.value = Integer.valueOf(en.Value__c);
        if (enumItemMap.containsKey(en.EnumType__c)) {
          enumItemMap.get(en.EnumType__c).add(item);
        } else {
          enumItemMap.put(en.EnumType__c, new List<EnumItem>{ item });
        }
      }
    }
    return enumItemMap;
  }

  public class EnumItem {
    public String label;
    public String enumName;
    public Integer value;
  }
}
