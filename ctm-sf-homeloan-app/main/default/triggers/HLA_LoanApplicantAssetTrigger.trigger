trigger HLA_LoanApplicantAssetTrigger on LoanApplicantAsset__c(
  before update,
  after update
) {
  List<SOBject> recordList = Trigger.isDelete ? Trigger.old : Trigger.new;
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + recordList.size() + ' record(s)',
    recordList
  );
  HLA_LoanApplicantAssets.triggerHandler(HLA_LoanApplicantAssets.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
