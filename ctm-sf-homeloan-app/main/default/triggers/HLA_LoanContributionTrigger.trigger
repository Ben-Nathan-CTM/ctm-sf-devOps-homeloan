trigger HLA_LoanContributionTrigger on LoanContribution__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanContributions.triggerHandler(HLA_LoanContributions.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
