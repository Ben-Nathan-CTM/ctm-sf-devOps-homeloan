public interface HLA_ICreditScoreSelector extends IApplicationSObjectSelector {
  List<CreditScore__c> selectCreditScoreUsingApplicantExternalId(
    Set<String> applicantExternalIds
  );
}
