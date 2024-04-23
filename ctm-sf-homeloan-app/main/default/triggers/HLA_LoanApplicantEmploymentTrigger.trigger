trigger HLA_LoanApplicantEmploymentTrigger on LoanApplicantEmployment__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicantEmployments.triggerHandler(
    HLA_LoanApplicantEmployments.class
  );
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
