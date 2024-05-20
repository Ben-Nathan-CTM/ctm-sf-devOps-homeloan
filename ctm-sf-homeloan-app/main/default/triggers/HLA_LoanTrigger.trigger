trigger HLA_LoanTrigger on Loan__c(before update, after update) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_Loans.triggerHandler(HLA_Loans.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();

}
