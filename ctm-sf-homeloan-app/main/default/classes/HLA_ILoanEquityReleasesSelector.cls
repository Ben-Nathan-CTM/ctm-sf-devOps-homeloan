public interface HLA_ILoanEquityReleasesSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_LoanEquityReleasesSelector setNewSortOrder(String fieldToOrderBy);
}
