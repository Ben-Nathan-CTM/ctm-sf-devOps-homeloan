public interface HLA_ILoanApplicantAssetsSelector extends IApplicationSObjectSelector {
  List<LoanApplicantAsset__c> selectLoanApplicantAssetsByReferenceId(
    String referenceId,
    String applId
  );
}
