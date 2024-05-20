public inherited sharing class HLA_LoanApplicantAssetsSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicantAssetsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicantAssetsSelector newInstance() {
    return (HLA_ILoanApplicantAssetsSelector) Application.Selector.newInstance(
      LoanApplicantAsset__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicantAsset__c.ResidentialLoanApplicationId__c,
      LoanApplicantAsset__c.Id,
      LoanApplicantAsset__c.Name,
      LoanApplicantAsset__c.ReferenceId__c,
      LoanApplicantAsset__c.ExternalId__c,
      LoanApplicantAsset__c.AId__c,
      LoanApplicantAsset__c.BId__c,
      LoanApplicantAsset__c.Percentage__c,
      LoanApplicantAsset__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicantAsset__c.sObjectType;
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

  public HLA_LoanApplicantAssetsSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */

  public List<LoanApplicantAsset__c> selectLoanApplicantAssetsByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicantAsset__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplicationId__c = :applId'
        )
        .toSOQL()
    );
  }
}
