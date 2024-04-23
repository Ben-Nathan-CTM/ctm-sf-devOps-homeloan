trigger HLA_LoanApplicationIncomeTrigger on LoanApplicationIncome__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicationIncome.triggerHandler(HLA_LoanApplicationIncome.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
