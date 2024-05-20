public interface HLA_ILoanApplicantLiabilitiesSelector extends IApplicationSObjectSelector {
    List<LoanApplicantLiability__c> selectLoanApplicantLiabilitiesByReferenceId(String referenceId,String applId);
}
