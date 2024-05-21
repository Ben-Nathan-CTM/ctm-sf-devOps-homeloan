public interface HLA_ILoanApplicationIncomeSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanApplicationIncomeSelector setNewSortOrder(String fieldToOrderBy);
  List<LoanApplicationIncome__c> selectLoanApplicationIncomesByReferenceId(
    String referenceId,
    String applId
  );
}
