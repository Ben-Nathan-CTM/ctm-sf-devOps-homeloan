public inherited sharing class HLA_EnumService implements HLA_IEnumService {
  //

  private static HLA_IEnumService service() {
    return (HLA_IEnumService) Application.Service.newInstance(
      HLA_IEnumService.class
    );
  }

  public static void setEnumValues(List<Enum__c> enumsRecords) {
    service().setEnumValues(enumsRecords);
  }

  public static void addEnumValuesToRelatedGlobalPicklist(
    List<Enum__c> enumsRecords
  ) {
    service().addEnumValuesToRelatedGlobalPicklist(enumsRecords);
  }

  public static Map<String, List<HLA_Enums.EnumItem>> getAllActiveEnumsMappedByType() {
    return service().getAllActiveEnumsMappedByType();
  }
}
