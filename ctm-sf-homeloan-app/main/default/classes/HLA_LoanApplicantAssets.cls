public inherited sharing class HLA_LoanApplicantAssets extends ApplicationSObjectDomain implements HLA_ILoanApplicantAssets {
  //

  public static HLA_ILoanApplicantAssets newInstance(
    List<LoanApplicantAsset__c> records
  ) {
    return (HLA_ILoanApplicantAssets) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanApplicantAssets newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicantAssets) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanApplicantAssets(List<LoanApplicantAsset__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicantAssets(sObjectList);
    }
  }

  private List<LoanApplicantAsset__c> laaRecords {
    get {
      if (laaRecords == null) {
        laaRecords = (List<LoanApplicantAsset__c>) records;
      }
      return laaRecords;
    }
    private set;
  }

  public List<LoanApplicantAsset__c> getlaaRecords() {
    return this.laaRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> laaRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, laaRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> laaRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        laaRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       laaRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
