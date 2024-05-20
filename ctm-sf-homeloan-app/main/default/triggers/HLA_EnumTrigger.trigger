trigger HLA_EnumTrigger on Enum__c(
  before insert,
  after insert,
  after update,
  after delete
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_Enums.triggerHandler(HLA_Enums.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
