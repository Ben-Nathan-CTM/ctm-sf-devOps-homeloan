public inherited sharing class HLA_LoanEquityReleases extends ApplicationSObjectDomain implements HLA_ILoanEquityReleases {
  //

  public static HLA_ILoanEquityReleases newInstance(
    List<LoanEquityRelease__c> records
  ) {
    return (HLA_ILoanEquityReleases) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanEquityReleases newInstance(Set<Id> recordIds) {
    return (HLA_ILoanEquityReleases) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanEquityReleases(List<LoanEquityRelease__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanEquityReleases(sObjectList);
    }
  }

  private List<LoanEquityRelease__c> lerRecords {
    get {
      if (lerRecords == null) {
        lerRecords = (List<LoanEquityRelease__c>) records;
      }
      return lerRecords;
    }
    private set;
  }

  public List<LoanEquityRelease__c> getlerRecords() {
    return this.lerRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> lerRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, lerRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> lerRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        lerRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       lerRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
