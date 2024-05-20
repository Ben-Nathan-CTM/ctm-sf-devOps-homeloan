public inherited sharing class HLA_LoansSelector extends ApplicationSObjectSelector implements HLA_ILoansSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoansSelector newInstance() {
    return (HLA_ILoansSelector) Application.Selector.newInstance(
      Loan__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{ Loan__c.Id, Loan__c.Name };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return Loan__c.sObjectType;
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

  public HLA_LoansSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
}
