trigger HLA_LoanApplicationAssetTrigger on LoanApplicationAsset__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicationAssets.triggerHandler(HLA_LoanApplicationAssets.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
