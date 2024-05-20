public interface HLA_IEnums extends IApplicationSObjectDomain {
  void onBeforeInsert();
  void onAfterInsert();
  void setEnumValues();
  List<Enum__c> getEnumsRecords();
  Map<String, List<HLA_Enums.EnumItem>> getEnumItemMap();
}
