public interface HLA_ILoanApplicationProductsSelector extends IApplicationSObjectSelector {
  List<LoanApplicationProduct__c> selectLoanApplicationProductsByApplicationId(
    Set<id> loanAppProductIds
  );
  List<LoanApplicationProduct__c> selectUsingApplicationExternalIdInWhereClause(
    Set<String> applicationExternalIds
  );
  HLA_LoanApplicationProductsSelector setNewSortOrder(String fieldToOrderBy);
  List<LoanApplicationProduct__c> selectLoanApplicationProductsByApplicationIdOrderByRAC(
    Set<id> resiLoanIds
  );
}
