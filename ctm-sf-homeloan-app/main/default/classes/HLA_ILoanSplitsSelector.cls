public interface HLA_ILoanSplitsSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanSplitsSelector setNewSortOrder(String fieldToOrderBy);
}
