public inherited sharing class HLA_LoanContributions extends ApplicationSObjectDomain implements HLA_ILoanContributions {
  //

  public static HLA_ILoanContributions newInstance(
    List<LoanContribution__c> records
  ) {
    return (HLA_ILoanContributions) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanContributions newInstance(Set<Id> recordIds) {
    return (HLA_ILoanContributions) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanContributions(List<LoanContribution__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanContributions(sObjectList);
    }
  }

  private List<LoanContribution__c> lconRecords {
    get {
      if (lconRecords == null) {
        lconRecords = (List<LoanContribution__c>) records;
      }
      return lconRecords;
    }
    private set;
  }

  public List<LoanContribution__c> getlconRecords() {
    return this.lconRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> lconRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, lconRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> lconRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        lconRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       lconRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
