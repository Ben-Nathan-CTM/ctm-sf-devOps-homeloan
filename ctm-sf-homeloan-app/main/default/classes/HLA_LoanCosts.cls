public inherited sharing class HLA_LoanCosts extends ApplicationSObjectDomain implements HLA_ILoanCosts {
  //

  public static HLA_ILoanCosts newInstance(List<LoanCost__c> records) {
    return (HLA_ILoanCosts) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanCosts newInstance(Set<Id> recordIds) {
    return (HLA_ILoanCosts) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanCosts(List<LoanCost__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanCosts(sObjectList);
    }
  }

  private List<LoanCost__c> lcRecords {
    get {
      if (lcRecords == null) {
        lcRecords = (List<LoanCost__c>) records;
      }
      return lcRecords;
    }
    private set;
  }

  public List<LoanCost__c> getlcRecords() {
    return this.lcRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> lcRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, lcRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> lcRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        lcRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       lcRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
