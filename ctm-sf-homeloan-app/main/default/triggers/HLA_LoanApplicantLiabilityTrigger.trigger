trigger HLA_LoanApplicantLiabilityTrigger on LoanApplicantLiability__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicantLiabilities.triggerHandler(
    HLA_LoanApplicantLiabilities.class
  );
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
