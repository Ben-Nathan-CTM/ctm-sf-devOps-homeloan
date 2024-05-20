public interface HLA_IEnumsSelector extends IApplicationSObjectSelector {
  List<Enum__c> selectAllActiveEnums();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_EnumsSelector setNewSortOrder(String fieldToOrderBy);
  List<Schema.SObjectField> getSObjectFieldList();
}