public inherited sharing class HLA_ResidentialLoanApplications extends ApplicationSObjectDomain implements HLA_IResidentialLoanApplications {
  //
  public static Id personAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByName()
    .get('Person Account')
    .getRecordTypeId();

  public static HLA_IResidentialLoanApplications newInstance(
    List<ResidentialLoanApplication__c> records
  ) {
    return (HLA_IResidentialLoanApplications) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_IResidentialLoanApplications newInstance(
    Set<Id> recordIds
  ) {
    return (HLA_IResidentialLoanApplications) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_ResidentialLoanApplications(
    List<ResidentialLoanApplication__c> records
  ) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_ResidentialLoanApplications(sObjectList);
    }
  }

  private List<ResidentialLoanApplication__c> rlaRecords {
    get {
      if (rlaRecords == null) {
        rlaRecords = (List<ResidentialLoanApplication__c>) records;
      }
      return rlaRecords;
    }
    private set;
  }

  public List<ResidentialLoanApplication__c> getRLARecords() {
    return this.rlaRecords;
  }

  public override void onBeforeUpdate(Map<Id, SObject> rlaRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.flagEachRecordIsDirty(records, rlaRecordsMap);
    }
  }

  public override void onAfterUpdate(Map<Id, SObject> rlaRecordsMap) {
    if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
      HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
        rlaRecords,
        Trigger.operationType
      );
    }
  }

  public override void onAfterDelete() {
    // if (FeatureManagement.checkPermission('CanSubmitApplicationChanges')) {
    //   System.enqueueJob(
    //     new HLA_LoanApplicationUpdatesQueueable(
    //       rlaRecords,
    //       Trigger.operationType
    //     )
    //   );
    // }
  }
}
