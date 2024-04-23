public inherited sharing class HLA_LoanEquityReleasesSelector extends ApplicationSObjectSelector implements HLA_ILoanEquityReleasesSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanEquityReleasesSelector newInstance() {
    return (HLA_ILoanEquityReleasesSelector) Application.Selector.newInstance(
      LoanEquityRelease__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanEquityRelease__c.Id,
      LoanEquityRelease__c.Name,
      LoanEquityRelease__c.ExternalId__c,
      LoanEquityRelease__c.isDirty__c,
      LoanEquityRelease__c.Amount__c,
      LoanEquityRelease__c.Loan__c,
      LoanEquityRelease__c.Type__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanEquityRelease__c.sObjectType;
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

  public HLA_LoanEquityReleasesSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
}
