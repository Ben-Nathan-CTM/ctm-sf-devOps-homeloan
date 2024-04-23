trigger HLA_LoanApplicationLiabilityTrigger on LoanApplicationLiability__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicationLiabilities.triggerHandler(
    HLA_LoanApplicationLiabilities.class
  );
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
