public inherited sharing class HLA_ResidentialLoanApplicationsSelector extends ApplicationSObjectSelector implements HLA_IResidentialLoanApplicationsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_IResidentialLoanApplicationsSelector newInstance() {
    return (HLA_IResidentialLoanApplicationsSelector) Application.Selector.newInstance(
      ResidentialLoanApplication__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      ResidentialLoanApplication__c.Id,
      ResidentialLoanApplication__c.Name,
      ResidentialLoanApplication__c.ApplicationId__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return ResidentialLoanApplication__c.sObjectType;
  }

  private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
    return new List<Schema.SObjectField>{};
  }

  public override String getOrderBy() {
    if (newOrderByField != null) {
      DEFAULT_ORDERBY_FIELD = newOrderByField;
    }
    return DEFAULT_ORDERBY_FIELD;
  }

  public HLA_ResidentialLoanApplicationsSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */

  public List<ResidentialLoanApplication__c> selectByIdWithTaskListWithLoanTracking(
    Set<Id> applicationIds
  ) {
    // get the parent Query Factory SOQL String
    String parentQueryString = newQueryFactory()
      .SelectField('account__r.CustomerId__c')
      .setCondition('id in :applicationIds')
      .toSOQL();

    // get the Sub Query SOQL String
    String subQueryString = newQueryFactory()
      .subselectQuery('tasks')
      .selectFields(new TasksSelector().getFieldListString().split(','))
      .setCondition('LoanTrackingOrder__c != null')
      .toSOQL();

    String combinedQueryString = combineQueryWithSubQuery(
      parentQueryString,
      subQueryString
    );

    return (List<ResidentialLoanApplication__c>) Database.query(
      combinedQueryString
    );
  }

  public List<ResidentialLoanApplication__c> selectByIdWithCustomerId(
    Set<Id> applicationIds
  ) {
    return (List<ResidentialLoanApplication__c>) Database.query(
      newQueryFactory()
        .SelectField('account__r.CustomerId__c')
        .setCondition('id in :applicationIds')
        .toSOQL()
    );
  }

  public List<ResidentialLoanApplication__c> selectByApplicationId(
    Set<String> applicationIds
  ) {
    return (List<ResidentialLoanApplication__c>) Database.query(
      newQueryFactory()
        .setCondition('applicationId__c in :applicationIds')
        .toSOQL()
    );
  }
}
