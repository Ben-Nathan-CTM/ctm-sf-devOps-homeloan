public inherited sharing class HLA_LoanApplicantLiabilitiesSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicantLiabilitiesSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicantLiabilitiesSelector newInstance() {
    return (HLA_ILoanApplicantLiabilitiesSelector) Application.Selector.newInstance(
      LoanApplicantLiability__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicantLiability__c.ResidentialLoanApplicationId__c,
      LoanApplicantLiability__c.Id,
      LoanApplicantLiability__c.AId__c,
      LoanApplicantLiability__c.BId__c,
      LoanApplicantLiability__c.Name,
      LoanApplicantLiability__c.ExternalId__c,
      LoanApplicantLiability__c.ReferenceId__c,
      LoanApplicantLiability__c.Percentage__c,
      LoanApplicantLiability__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicantLiability__c.sObjectType;
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

  public HLA_LoanApplicantLiabilitiesSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */

  public List<LoanApplicantLiability__c> selectLoanApplicantLiabilitiesByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicantLiability__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplicationId__c = :applId'
        )
        .toSOQL()
    );
  }
}
