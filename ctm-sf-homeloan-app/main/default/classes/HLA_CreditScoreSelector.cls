public inherited sharing class HLA_CreditScoreSelector extends ApplicationSObjectSelector implements HLA_ICreditScoreSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ICreditScoreSelector newInstance() {
    return (HLA_ICreditScoreSelector) Application.Selector.newInstance(
      CreditScore__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      CreditScore__c.Id,
      CreditScore__c.Name,
      CreditScore__c.ExternalId__c,
      CreditScore__c.LoanApplicant__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return CreditScore__c.sObjectType;
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

  public HLA_CreditScoreSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */

  public List<CreditScore__c> selectCreditScoreUsingApplicantExternalId(
    Set<String> applicantExternalIds
  ) {
    return (List<CreditScore__c>) Database.query(
      newQueryFactory()
        .setCondition('LoanApplicant__r.ExternalId__c in :applicantExternalIds')
        .toSOQL()
    );
  }
}
