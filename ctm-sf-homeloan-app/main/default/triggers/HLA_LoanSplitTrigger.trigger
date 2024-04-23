trigger HLA_LoanSplitTrigger on LoanSplit__c(before update, after update) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanSplits.triggerHandler(HLA_LoanSplits.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
