trigger HLA_LoanEquityReleaseTrigger on LoanEquityRelease__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanEquityReleases.triggerHandler(HLA_LoanEquityReleases.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
