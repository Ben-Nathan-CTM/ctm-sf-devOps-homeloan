trigger HLA_LoanApplicationDocumentTrigger on LoanApplicationDocument__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicationDocuments.triggerHandler(
    HLA_LoanApplicationDocuments.class
  );
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
