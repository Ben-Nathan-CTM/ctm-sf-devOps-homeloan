public interface HLA_ILoanApplicantExpensesSelector extends IApplicationSObjectSelector {
    List<LoanApplicantExpense__c> selectLoanApplicantExpensesByReferenceId(String referenceId,String applId);
}
