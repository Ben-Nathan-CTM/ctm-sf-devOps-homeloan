public inherited sharing class HLA_LoanApplicantExpenses extends ApplicationSObjectDomain implements HLA_ILoanApplicantExpenses {
  //

  public static HLA_ILoanApplicantExpenses newInstance(
    List<LoanApplicantExpense__c> records
  ) {
    return (HLA_ILoanApplicantExpenses) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanApplicantExpenses newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicantExpenses) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicantExpenses(List<LoanApplicantExpense__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicantExpenses(sObjectList);
    }
  }

  private List<LoanApplicantExpense__c> laexpRecords {
    get {
      if (laexpRecords == null) {
        laexpRecords = (List<LoanApplicantExpense__c>) records;
      }
      return laexpRecords;
    }
    private set;
  }

  public List<LoanApplicantExpense__c> getlaexpRecords() {
    return this.laexpRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> laexpRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, laexpRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> laexpRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        laexpRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       laexpRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
