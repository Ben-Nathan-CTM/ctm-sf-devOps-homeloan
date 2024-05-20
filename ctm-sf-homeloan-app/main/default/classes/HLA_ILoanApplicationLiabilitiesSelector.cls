public interface HLA_ILoanApplicationLiabilitiesSelector extends IApplicationSObjectSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanApplicationLiabilitiesSelector setNewSortOrder(String fieldToOrderBy);
  List<LoanApplicationLiability__c> selectLoanApplicationLiabilitiesByReferenceId(
    String referenceId,
    String applId
  );
}
