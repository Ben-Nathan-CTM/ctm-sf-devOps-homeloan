public inherited sharing class HLA_Loans extends ApplicationSObjectDomain implements HLA_ILoans {
  //

  public static HLA_ILoans newInstance(List<Loan__c> records) {
    return (HLA_ILoans) Application.Domain.newInstance(records);
  }

  public static HLA_ILoans newInstance(Set<Id> recordIds) {
    return (HLA_ILoans) Application.Domain.newInstance(recordIds);
  }

  public HLA_Loans(List<Loan__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_Loans(sObjectList);
    }
  }

  private List<Loan__c> loanRecords {
    get {
      if (loanRecords == null) {
        loanRecords = (List<Loan__c>) records;
      }
      return loanRecords;
    }
    private set;
  }

  public List<Loan__c> getloanRecords() {
    return this.loanRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> loanRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, loanRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> loanRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        loanRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(new HLA_LoanApplicationUpdatesQueueable(loanRecords,
    //   Trigger.operationType));
    // }
  }
}
