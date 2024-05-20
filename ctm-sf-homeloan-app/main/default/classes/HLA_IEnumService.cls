public interface HLA_IEnumService {
  void setEnumValues(List<Enum__c> enumsRecords);

  void addEnumValuesToRelatedGlobalPicklist(List<Enum__c> enumsRecords);
  Map<String, List<HLA_Enums.EnumItem>> getAllActiveEnumsMappedByType();
}
