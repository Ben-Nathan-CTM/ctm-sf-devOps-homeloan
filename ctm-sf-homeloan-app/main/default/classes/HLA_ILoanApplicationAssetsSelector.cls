public interface HLA_ILoanApplicationAssetsSelector extends IApplicationSObjectSelector {
  List<LoanApplicationAsset__c> selectLoanApplicationAssetsByReferenceId(
    String referenceId,
    String applId
  );
}
