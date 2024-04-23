public inherited sharing class HLA_LoanApplicants extends ApplicationSObjectDomain implements HLA_ILoanApplicants {
  //

  public static HLA_ILoanApplicants newInstance(
    List<LoanApplicant__c> records
  ) {
    return (HLA_ILoanApplicants) Application.Domain.newInstance(records);
  }

  public static HLA_ILoanApplicants newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicants) Application.Domain.newInstance(recordIds);
  }

  public HLA_LoanApplicants(List<LoanApplicant__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicants(sObjectList);
    }
  }

  private List<LoanApplicant__c> laRecords {
    get {
      if (laRecords == null) {
        laRecords = (List<LoanApplicant__c>) records;
      }
      return laRecords;
    }
    private set;
  }

  public List<LoanApplicant__c> getlaRecords() {
    return this.laRecords;
  }

  public override void onAfterInsert() {
    // have to clone the records here to remove the isReadOnly flag from after trigger records
    // REPLACED - replaced with Flow. Commenting out so that Ben can still follow the old code below for pattern learning

    // new HLA_AttachContactsAsyncProccessor()
    //   .get(laRecords.deepClone(true, false, false))
    //   .kickoff();
  }

  public override void onBeforeUpdate(Map<Id, SObject> laRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, laRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> laRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        laRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       laRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
