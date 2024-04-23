trigger HLA_LoanSecurityTrigger on LoanSecurity__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanSecurities.triggerHandler(HLA_LoanSecurities.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
