public interface HLA_ICreditScoreService {
  void requestAccountCreditScoreAssessment(List<Account> accounts);
  List<Account> selectAccountsDueForCreditAssessment();
  void deleteCreditScoresUsingApplicantExternalIds(
    Set<String> applicantExternalIds
  );
}
