public inherited sharing class HLA_LoanApplicationDocuments extends ApplicationSObjectDomain implements HLA_ILoanApplicationDocuments {
  //

  public static HLA_ILoanApplicationDocuments newInstance(
    List<LoanApplicationDocument__c> records
  ) {
    return (HLA_ILoanApplicationDocuments) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_ILoanApplicationDocuments newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicationDocuments) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicationDocuments(
    List<LoanApplicationDocument__c> records
  ) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicationDocuments(sObjectList);
    }
  }

  private List<LoanApplicationDocument__c> ladRecords {
    get {
      if (ladRecords == null) {
        ladRecords = (List<LoanApplicationDocument__c>) records;
      }
      return ladRecords;
    }
    private set;
  }

  public List<LoanApplicationDocument__c> getladRecords() {
    return this.ladRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> ladRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, ladRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> ladRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        ladRecords,
        Trigger.operationType
      );
    }
  }

    public override void onAfterInsert() {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        ladRecords,
        Trigger.operationType
      );    
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(new HLA_LoanApplicationUpdatesQueueable(ladRecords,
    //   Trigger.operationType));
    // }
  }
}
