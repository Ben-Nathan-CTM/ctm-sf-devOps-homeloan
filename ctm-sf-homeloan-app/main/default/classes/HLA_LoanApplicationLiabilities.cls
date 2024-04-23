public with sharing class HLA_LoanApplicationLiabilities extends ApplicationSObjectDomain implements HLA_ILoanApplicationLiabilities {
  //

  public static HLA_ILoanApplicationLiabilities newInstance(
    List<LoanApplicationLiability__c> records
  ) {
    return (HLA_ILoanApplicationLiabilities) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_ILoanApplicationLiabilities newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicationLiabilities) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicationLiabilities(
    List<LoanApplicationLiability__c> records
  ) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicationLiabilities(sObjectList);
    }
  }

  private List<LoanApplicationLiability__c> lalRecords {
    get {
      if (lalRecords == null) {
        lalRecords = (List<LoanApplicationLiability__c>) records;
      }
      return lalRecords;
    }
    private set;
  }

  public List<LoanApplicationLiability__c> getlalRecords() {
    return this.lalRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> lalRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, lalRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> lalRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        lalRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(new HLA_LoanApplicationUpdatesQueueable(lalRecords,
    //   Trigger.operationType));
    // }
  }
}
