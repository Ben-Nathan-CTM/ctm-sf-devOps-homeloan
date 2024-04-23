public inherited sharing class HLA_LoanApplicationAssets extends ApplicationSObjectDomain implements HLA_ILoanApplicationAssets {
  //

  public static HLA_ILoanApplicationAssets newInstance(
    List<LoanApplicationAsset__c> records
  ) {
    return (HLA_ILoanApplicationAssets) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanApplicationAssets newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicationAssets) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicationAssets(List<LoanApplicationAsset__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicationAssets(sObjectList);
    }
  }

  private List<LoanApplicationAsset__c> laaRecords {
    get {
      if (laaRecords == null) {
        laaRecords = (List<LoanApplicationAsset__c>) records;
      }
      return laaRecords;
    }
    private set;
  }

  public List<LoanApplicationAsset__c> getlaaRecords() {
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
