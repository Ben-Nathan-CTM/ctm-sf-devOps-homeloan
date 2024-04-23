public interface HLA_ILoanCostsSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanCostsSelector setNewSortOrder(String fieldToOrderBy);
}
