public inherited sharing class HLA_LoanApplicantEmployments extends ApplicationSObjectDomain implements HLA_ILoanApplicantEmployments {
  //

  public static HLA_ILoanApplicantEmployments newInstance(
    List<LoanApplicantEmployment__c> records
  ) {
    return (HLA_ILoanApplicantEmployments) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_ILoanApplicantEmployments newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicantEmployments) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicantEmployments(
    List<LoanApplicantEmployment__c> records
  ) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicantEmployments(sObjectList);
    }
  }

  private List<LoanApplicantEmployment__c> laeRecords {
    get {
      if (laeRecords == null) {
        laeRecords = (List<LoanApplicantEmployment__c>) records;
      }
      return laeRecords;
    }
    private set;
  }

  public List<LoanApplicantEmployment__c> getlaeRecords() {
    return this.laeRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> laeRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, laeRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> laeRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        laeRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       laeRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
