trigger HLA_LoanCostTrigger on LoanCost__c(before update, after update) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanCosts.triggerHandler(HLA_LoanCosts.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
