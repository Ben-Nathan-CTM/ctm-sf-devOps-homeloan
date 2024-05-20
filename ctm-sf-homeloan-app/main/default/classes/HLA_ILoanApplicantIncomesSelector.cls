public interface HLA_ILoanApplicantIncomesSelector extends IApplicationSObjectSelector {
    List<LoanApplicantIncome__c> selectLoanApplicantIncomesByReferenceId(String referenceId,String rlaId);
}
