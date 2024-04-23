trigger HLA_LoanApplicantIncomeTrigger on LoanApplicantIncome__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicantIncomes.triggerHandler(HLA_LoanApplicantIncomes.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
