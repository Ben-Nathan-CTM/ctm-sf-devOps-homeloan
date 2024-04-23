public with sharing class HLA_EnumUpdateRelatedPicklistsQueueable implements Queueable, Database.AllowsCallouts {
  private List<Enum__c> enumRecords;

  public HLA_EnumUpdateRelatedPicklistsQueueable(List<Enum__c> enumRecords) {
    this.enumRecords = enumRecords;
  }

  public void execute(QueueableContext context) {
    Nebula.Logger.info('ENTRY ', enumRecords);
    HLA_EnumService.addEnumValuesToRelatedGlobalPicklist(enumRecords);
    Nebula.Logger.info('EXIT ');
    Nebula.Logger.saveLog();
  }
}
