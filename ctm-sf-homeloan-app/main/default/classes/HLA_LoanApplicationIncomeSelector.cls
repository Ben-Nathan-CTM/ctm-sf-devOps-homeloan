public inherited sharing class HLA_LoanApplicationIncomeSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicationIncomeSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicationIncomeSelector newInstance() {
    return (HLA_ILoanApplicationIncomeSelector) Application.Selector.newInstance(
      LoanApplicationIncome__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicationIncome__c.ResidentialLoanApplication__c,
      LoanApplicationIncome__c.Id,
      LoanApplicationIncome__c.ExternalId__c,
      LoanApplicationIncome__c.ReferenceId__c,
      LoanApplicationIncome__c.Name,
      LoanApplicationIncome__c.Amount__c,
      LoanApplicationIncome__c.Frequency__c,
      LoanApplicationIncome__c.isDirty__c,
      LoanApplicationIncome__c.OwnershipPercentage__c,
      LoanApplicationIncome__c.IncomeGovernmentBenefitsType__c,
      LoanApplicationIncome__c.IncomeMaintenanceChildSupportType__c,
      LoanApplicationIncome__c.IncomeOtherType__c,
      LoanApplicationIncome__c.IncomeRentalType__c,
      LoanApplicationIncome__c.IncomeRetirementType__c,
      LoanApplicationIncome__c.TaxType__c,
      LoanApplicationIncome__c.Type__c,
      LoanApplicationIncome__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicationIncome__c.sObjectType;
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

  public HLA_LoanApplicationIncomeSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */

  public List<LoanApplicationIncome__c> selectLoanApplicationIncomesByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicationIncome__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplication__c = :applId'
        )
        .toSOQL()
    );
  }
}
