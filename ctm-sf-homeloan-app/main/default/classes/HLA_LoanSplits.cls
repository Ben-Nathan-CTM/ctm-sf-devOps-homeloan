public inherited sharing class HLA_LoanSplits extends ApplicationSObjectDomain implements HLA_ILoanSplits {
  //

  public static HLA_ILoanSplits newInstance(List<LoanSplit__c> records) {
    return (HLA_ILoanSplits) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanSplits newInstance(Set<Id> recordIds) {
    return (HLA_ILoanSplits) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanSplits(List<LoanSplit__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanSplits(sObjectList);
    }
  }

  private List<LoanSplit__c> lsRecords {
    get {
      if (lsRecords == null) {
        lsRecords = (List<LoanSplit__c>) records;
      }
      return lsRecords;
    }
    private set;
  }

  public List<LoanSplit__c> getlsRecords() {
    return this.lsRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> lsRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, lsRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> lsRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        lsRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       lsRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
