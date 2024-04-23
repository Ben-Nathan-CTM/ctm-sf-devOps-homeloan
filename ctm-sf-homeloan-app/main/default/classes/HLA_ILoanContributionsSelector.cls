public interface HLA_ILoanContributionsSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanContributionsSelector setNewSortOrder(String fieldToOrderBy);
}
