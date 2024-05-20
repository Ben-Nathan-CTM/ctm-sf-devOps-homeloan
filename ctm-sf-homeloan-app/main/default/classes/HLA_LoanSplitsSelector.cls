public inherited sharing class HLA_LoanSplitsSelector extends ApplicationSObjectSelector implements HLA_ILoanSplitsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanSplitsSelector newInstance() {
    return (HLA_ILoanSplitsSelector) Application.Selector.newInstance(
      LoanSplit__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanSplit__c.Id,
      LoanSplit__c.Name,
      LoanSplit__c.ExternalId__c,
      LoanSplit__c.isDirty__c,
      LoanSplit__c.Loan__c,
      LoanSplit__c.LoanApplicationLiability__c,
      LoanSplit__c.ResidentialLoanApplication__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanSplit__c.sObjectType;
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

  public HLA_LoanSplitsSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
}
