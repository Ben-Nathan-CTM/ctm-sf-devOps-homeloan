public inherited sharing class HLA_LoanCostsSelector extends ApplicationSObjectSelector implements HLA_ILoanCostsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanCostsSelector newInstance() {
    return (HLA_ILoanCostsSelector) Application.Selector.newInstance(
      LoanCost__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanCost__c.Id,
      LoanCost__c.Name,
      LoanCost__c.ExternalId__c,
      LoanCost__c.isDirty__c,
      LoanCost__c.Amount__c,
      LoanCost__c.Loan__c,
      LoanCost__c.ResidentialLoanApplication__c,
      LoanCost__c.Type__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanCost__c.sObjectType;
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

  public HLA_LoanCostsSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
}
