public inherited sharing class HLA_LoanApplicantIncomes extends ApplicationSObjectDomain implements HLA_ILoanApplicantIncomes {
  //

  public static HLA_ILoanApplicantIncomes newInstance(
    List<LoanApplicantIncome__c> records
  ) {
    return (HLA_ILoanApplicantIncomes) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanApplicantIncomes newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicantIncomes) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicantIncomes(List<LoanApplicantIncome__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicantIncomes(sObjectList);
    }
  }

  private List<LoanApplicantIncome__c> laiRecords {
    get {
      if (laiRecords == null) {
        laiRecords = (List<LoanApplicantIncome__c>) records;
      }
      return laiRecords;
    }
    private set;
  }

  public List<LoanApplicantIncome__c> getlaiRecords() {
    return this.laiRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> laiRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, laiRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> laiRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        laiRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       laiRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
