public interface HLA_ILoanApplicationExpensesSelector extends IApplicationSObjectSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanApplicationExpensesSelector setNewSortOrder(String fieldToOrderBy);
}
