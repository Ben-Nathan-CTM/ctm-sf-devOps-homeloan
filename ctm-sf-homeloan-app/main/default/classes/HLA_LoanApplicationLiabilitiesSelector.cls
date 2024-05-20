public inherited sharing class HLA_LoanApplicationLiabilitiesSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicationLiabilitiesSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicationLiabilitiesSelector newInstance() {
    return (HLA_ILoanApplicationLiabilitiesSelector) Application.Selector.newInstance(
      LoanApplicationLiability__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicationLiability__c.ResidentialLoanApplication__c,
      LoanApplicationLiability__c.Id,
      LoanApplicationLiability__c.Name,
      LoanApplicationLiability__c.ExternalId__c,
      LoanApplicationLiability__c.ReferenceId__c,
      LoanApplicationLiability__c.Description__c,
      LoanApplicationLiability__c.InitialLoanAmount__c,
      LoanApplicationLiability__c.Institution__c,
      LoanApplicationLiability__c.InterestCapitalised__c,
      LoanApplicationLiability__c.InterestRate__c,
      LoanApplicationLiability__c.LoanLimit__c,
      LoanApplicationLiability__c.OutstandingBalance__c,
      LoanApplicationLiability__c.RepaymentAmount__c,
      LoanApplicationLiability__c.Type__c,
      LoanApplicationLiability__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicationLiability__c.sObjectType;
  }

  @TestVisible
  private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
    return new List<Schema.SObjectField>{};
  }

  public override String getOrderBy() {
    if (newOrderByField != null) {
      DEFAULT_ORDERBY_FIELD = newOrderByField;
    }
    return DEFAULT_ORDERBY_FIELD;
  }

  public HLA_LoanApplicationLiabilitiesSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
  public List<LoanApplicationLiability__c> selectLoanApplicationLiabilitiesByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicationLiability__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplication__c = :applId'
        )
        .toSOQL()
    );
  }
}
