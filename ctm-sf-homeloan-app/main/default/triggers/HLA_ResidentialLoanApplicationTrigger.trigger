trigger HLA_ResidentialLoanApplicationTrigger on ResidentialLoanApplication__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_ResidentialLoanApplications.triggerHandler(
    HLA_ResidentialLoanApplications.class
  );
  Nebula.Logger.info(Trigger.operationType + ' EXIT');
  Nebula.Logger.saveLog();
}
