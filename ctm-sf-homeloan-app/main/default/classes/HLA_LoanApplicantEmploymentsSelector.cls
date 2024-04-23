public inherited sharing class HLA_LoanApplicantEmploymentsSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicantEmploymentsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicantEmploymentsSelector newInstance() {
    return (HLA_ILoanApplicantEmploymentsSelector) Application.Selector.newInstance(
      LoanApplicantEmployment__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicantEmployment__c.Id,
      LoanApplicantEmployment__c.Name
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicantEmployment__c.sObjectType;
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

  public HLA_LoanApplicantEmploymentsSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
}
