public with sharing class HLA_LoanApplicantService implements HLA_ILoanApplicantService {
  //

  private static HLA_ILoanApplicantService service() {
    return (HLA_ILoanApplicantService) Application.Service.newInstance(
      HLA_ILoanApplicantService.class
    );
  }

  public static void attachContactsToApplicants(
    List<LoanApplicant__c> applicants
  ) {
    service().attachContactsToApplicants(applicants);
  }
}
