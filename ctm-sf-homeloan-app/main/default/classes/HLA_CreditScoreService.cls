public with sharing class HLA_CreditScoreService implements HLA_ICreditScoreService {
  //

  private static HLA_ICreditScoreService service() {
    return (HLA_ICreditScoreService) Application.Service.newInstance(
      HLA_ICreditScoreService.class
    );
  }

  public static void requestAccountCreditScoreAssessment(
    List<Account> accounts
  ) {
    service().requestAccountCreditScoreAssessment(accounts);
  }

  public static List<Account> selectAccountsDueForCreditAssessment() {
    return service().selectAccountsDueForCreditAssessment();
  }

  public static void deleteCreditScoresUsingApplicantExternalIds(
    Set<String> applicantExternalIds
  ) {
    service().deleteCreditScoresUsingApplicantExternalIds(applicantExternalIds);
  }
}
