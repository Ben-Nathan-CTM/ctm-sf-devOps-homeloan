trigger HLA_LoanApplicantExpenseTrigger on LoanApplicantExpense__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicantExpenses.triggerHandler(HLA_LoanApplicantExpenses.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
