trigger HLA_IdentificationTrigger on Identification__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_Identification.triggerHandler(HLA_Identification.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();

}
