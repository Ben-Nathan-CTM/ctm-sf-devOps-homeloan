public class HLA_CreditScoreAssessmentSchedule implements Schedulable {
  //
  public void execute(SchedulableContext sc) {
    // List<Account> accounts = HLA_CreditScoreService.selectAccountsDueForCreditAssessment();
    // HLA_CreditScoreService.requestAccountCreditScoreAssessment(accounts);
    Date creditCheckDueDate = System.Today().addMonths(-1);
    String queryString = 'SELECT CustomerId__c, CreditScoreID__c '+
                                          'FROM Account '+ 
                                          'where customerId__c != null AND CreditScoreID__c != null AND OriginalCreditCheckDate__c = LAST_N_DAYS:365 AND LatestCreditCheckDate__c <= ' +
                                          string.valueOf(creditCheckDueDate);
    new HLA_CreditScoreAssessmentAsyncProccessor().get(queryString).kickoff();
  }
}
