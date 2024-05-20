public inherited sharing class HLA_LoanApplicationExpenses extends ApplicationSObjectDomain implements HLA_ILoanApplicationExpenses {
  //

  public static HLA_ILoanApplicationExpenses newInstance(
    List<LoanApplicationExpense__c> records
  ) {
    return (HLA_ILoanApplicationExpenses) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_ILoanApplicationExpenses newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicationExpenses) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicationExpenses(List<LoanApplicationExpense__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicationExpenses(sObjectList);
    }
  }

  private List<LoanApplicationExpense__c> LaeRecords {
    get {
      if (LaeRecords == null) {
        LaeRecords = (List<LoanApplicationExpense__c>) records;
      }
      return LaeRecords;
    }
    private set;
  }

  public List<LoanApplicationExpense__c> getLaeRecords() {
    return this.LaeRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> LaeRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, LaeRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> LaeRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        LaeRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       LaeRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
