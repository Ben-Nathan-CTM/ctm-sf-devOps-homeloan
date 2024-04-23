public with sharing class HLA_ApplicationService implements HLA_IApplicationService {
  //

  private static HLA_IApplicationService service() {
    return (HLA_IApplicationService) Application.Service.newInstance(
      HLA_IApplicationService.class
    );
  }

  public static void submitApplicationUpdates(List<SObject> records) {
    service().submitApplicationUpdates(records);
  }

  @InvocableMethod(
    label='Delete Residential Loan'
    description='Delete\'s an Residential Loan Application and all related records'
    category='Residential Loans'
    callout=true
  )
  public static void deleteApplicationAndRelatedrecords(
    List<Id> residentialLoanAppIds
  ) {
    service().deleteApplicationAndRelatedrecords(residentialLoanAppIds);
  }

  @AuraEnabled(cacheable=true)
  public static List<LoanApplicationProduct__c> getEligibleLoanProducts(
    Id resiLoanId
  ) {
    return service().getEligibleLoanProducts(resiLoanId);
  }
}
