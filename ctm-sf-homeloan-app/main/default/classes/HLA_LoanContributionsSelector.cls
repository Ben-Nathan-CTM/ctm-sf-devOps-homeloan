public inherited sharing class HLA_LoanContributionsSelector extends ApplicationSObjectSelector implements HLA_ILoanContributionsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanContributionsSelector newInstance() {
    return (HLA_ILoanContributionsSelector) Application.Selector.newInstance(
      LoanContribution__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanContribution__c.Id,
      LoanContribution__c.Name,
      LoanContribution__c.ExternalId__c,
      LoanContribution__c.isDirty__c,
      LoanContribution__c.amount__c,
      LoanContribution__c.Loan__c,
      LoanContribution__c.Type__c,
      LoanContribution__c.ResidentialLoanApplication__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanContribution__c.sObjectType;
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

  public HLA_LoanContributionsSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
}
