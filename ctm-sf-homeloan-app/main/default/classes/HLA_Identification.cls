public inherited sharing class HLA_Identification extends ApplicationSObjectDomain implements HLA_IIdentification {
  //

  public static HLA_IIdentification newInstance(
    List<Identification__c> records
  ) {
    return (HLA_IIdentification) Application.Domain.newInstance(records);
  }

  public static HLA_IIdentification newInstance(Set<Id> recordIds) {
    return (HLA_IIdentification) Application.Domain.newInstance(recordIds);
  }

  public HLA_Identification(List<Identification__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_Identification(sObjectList);
    }
  }

  private List<Identification__c> IdentificationRecords {
    get {
      if (IdentificationRecords == null) {
        IdentificationRecords = (List<Identification__c>) records;
      }
      return IdentificationRecords;
    }
    private set;
  }

  public List<Identification__c> getIdentificationRecords() {
    return this.IdentificationRecords;
  }

  public override void onBeforeUpdate(
    Map<Id, SObject> IdentificationRecordsMap
  ) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, IdentificationRecordsMap);
    }
  }

  public override void onAfterUpdate(
    Map<Id, SObject> IdentificationRecordsMap
  ) {
    HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
      IdentificationRecords,
      Trigger.operationType
    );
  }

  public override void onAfterDelete() {
    // System.enqueueJob(
    //   new HLA_LoanApplicationUpdatesQueueable(
    //     IdentificationRecords,
    //     Trigger.operationType
    //   )
    // );
  }
}
