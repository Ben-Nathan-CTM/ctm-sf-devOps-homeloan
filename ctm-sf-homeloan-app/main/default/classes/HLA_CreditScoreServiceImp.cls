public with sharing class HLA_CreditScoreServiceImp implements HLA_ICreditScoreService {
  //

  public void requestAccountCreditScoreAssessment(List<Account> accountList) {
    new HLA_CreditScoreAssessmentAsyncProccessor().get(accountList).kickoff();
  }

  public List<Account> selectAccountsDueForCreditAssessment() {
    Date creditCheckDueDate = System.Today().addMonths(-1);
    return Database.query(
      ((AccountsSelector) AccountsSelector.newInstance())
        .newQueryFactory()
        .setCondition(
          'customerId__c != null AND CreditScoreID__c != null AND OriginalCreditCheckDate__c = LAST_N_DAYS:365 AND LatestCreditCheckDate__c <= ' +
          string.valueOf(creditCheckDueDate)
        )
        .toSOQL()
    );
  }

  public void deleteCreditScoresUsingApplicantExternalIds(
    Set<String> applicantExternalIds
  ) {
    ApplicationSObjectUnitOfWork uow = (ApplicationSObjectUnitOfWork) Application.UnitOfWork.newInstance();
    List<CreditScore__c> creditScoresToDelete = HLA_CreditScoreSelector.newInstance()
      .selectCreditScoreUsingApplicantExternalId(applicantExternalIds);
    if (!creditScoresToDelete.isEmpty()) {
      uow.registerDeleted(creditScoresToDelete);
      uow.commitWork();
    }
  }
}
