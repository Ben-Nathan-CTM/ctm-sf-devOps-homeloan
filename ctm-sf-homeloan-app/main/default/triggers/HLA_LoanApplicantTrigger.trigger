trigger HLA_LoanApplicantTrigger on LoanApplicant__c(
  before update,
  after update,
  after insert
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicants.triggerHandler(HLA_LoanApplicants.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
