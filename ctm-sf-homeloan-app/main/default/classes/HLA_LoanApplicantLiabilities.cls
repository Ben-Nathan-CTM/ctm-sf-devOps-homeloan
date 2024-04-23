public inherited sharing class HLA_LoanApplicantLiabilities extends ApplicationSObjectDomain implements HLA_ILoanApplicantLiabilities {
  //

  public static HLA_ILoanApplicantLiabilities newInstance(
    List<LoanApplicantLiability__c> records
  ) {
    return (HLA_ILoanApplicantLiabilities) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_ILoanApplicantLiabilities newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicantLiabilities) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicantLiabilities(List<LoanApplicantLiability__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicantLiabilities(sObjectList);
    }
  }

  private List<LoanApplicantLiability__c> lalRecords {
    get {
      if (lalRecords == null) {
        lalRecords = (List<LoanApplicantLiability__c>) records;
      }
      return lalRecords;
    }
    private set;
  }

  public List<LoanApplicantLiability__c> getlalRecords() {
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
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       lalRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
