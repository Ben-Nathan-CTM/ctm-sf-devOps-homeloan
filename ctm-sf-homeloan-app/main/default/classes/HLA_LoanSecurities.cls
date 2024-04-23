public inherited sharing class HLA_LoanSecurities extends ApplicationSObjectDomain implements HLA_ILoanSecurities {
  //

  public static HLA_ILoanSecurities newInstance(List<LoanSecurity__c> records) {
    return (HLA_ILoanSecurities) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanSecurities newInstance(Set<Id> recordIds) {
    return (HLA_ILoanSecurities) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanSecurities(List<LoanSecurity__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanSecurities(sObjectList);
    }
  }

  private List<LoanSecurity__c> lsRecords {
    get {
      if (lsRecords == null) {
        lsRecords = (List<LoanSecurity__c>) records;
      }
      return lsRecords;
    }
    private set;
  }

  public List<LoanSecurity__c> getlsRecords() {
    return this.lsRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> lsRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, lsRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> lsRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        lsRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(new HLA_LoanApplicationUpdatesQueueable(lsRecords,
    //   Trigger.operationType));
    // }
  }
}
