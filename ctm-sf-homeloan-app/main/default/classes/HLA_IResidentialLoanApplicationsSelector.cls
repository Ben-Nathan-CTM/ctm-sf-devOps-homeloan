public interface HLA_IResidentialLoanApplicationsSelector extends IApplicationSObjectSelector {
  List<Schema.SObjectField> getSObjectFieldList();
  Schema.SObjectType getSObjectType();
  String getOrderBy();
  HLA_ResidentialLoanApplicationsSelector setNewSortOrder(
    String fieldToOrderBy
  );
  List<ResidentialLoanApplication__c> selectByIdWithTaskListWithLoanTracking(
    Set<Id> applicationIds
  );

  List<ResidentialLoanApplication__c> selectByIdWithCustomerId(
    Set<Id> applicationIds
  );
  List<ResidentialLoanApplication__c> selectByApplicationId(
    Set<String> applicationIds
  );
}
