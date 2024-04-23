public with sharing class HLA_AttachContactsAsyncProccessor extends AsyncProcessor implements Database.AllowsCallouts {
  //

  protected override void innerExecute(List<SObject> records) {
    HLA_LoanApplicantService.attachContactsToApplicants(
      (List<LoanApplicant__c>) records
    );
  }
}
