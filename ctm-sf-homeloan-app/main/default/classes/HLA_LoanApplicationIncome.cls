public inherited sharing class HLA_LoanApplicationIncome extends ApplicationSObjectDomain implements HLA_ILoanApplicationIncome {
  //

  public static HLA_ILoanApplicationIncome newInstance(
    List<LoanApplicationIncome__c> records
  ) {
    return (HLA_ILoanApplicationIncome) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanApplicationIncome newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicationIncome) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicationIncome(List<LoanApplicationIncome__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicationIncome(sObjectList);
    }
  }

  private List<LoanApplicationIncome__c> LaiRecords {
    get {
      if (LaiRecords == null) {
        LaiRecords = (List<LoanApplicationIncome__c>) records;
      }
      return LaiRecords;
    }
    private set;
  }

  public List<LoanApplicationIncome__c> getLaiRecords() {
    return this.LaiRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> laiRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, laiRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> laiRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        LaiRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       LaiRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
