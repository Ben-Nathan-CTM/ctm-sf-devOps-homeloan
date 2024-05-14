public inherited sharing class HLA_LoanApplicationAssetsSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicationAssetsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicationAssetsSelector newInstance() {
    return (HLA_ILoanApplicationAssetsSelector) Application.Selector.newInstance(
      LoanApplicationAsset__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicationAsset__c.ResidentialLoanApplication__c,
      LoanApplicationAsset__c.Id,
      LoanApplicationAsset__c.Name,
      LoanApplicationAsset__c.ReferenceId__c,
      LoanApplicationAsset__c.ExternalId__c,
      LoanApplicationAsset__c.AssetSavingsAndDepositsType__c,
      LoanApplicationAsset__c.AssetSuperannuationType__c,
      LoanApplicationAsset__c.AssetType__c,
      LoanApplicationAsset__c.AssetVehicleType__c,
      LoanApplicationAsset__c.CommercialPropertyType__c,
      LoanApplicationAsset__c.Description__c,
      LoanApplicationAsset__c.EstimatedValue__c,
      LoanApplicationAsset__c.Motorcycles__c,
      LoanApplicationAsset__c.Vehicle__c,
      LoanApplicationAsset__c.isSecurityForLoanFinancingIt__c,
      LoanApplicationAsset__c.PropertyAddress__Street__s,
      LoanApplicationAsset__c.PropertyAddress__City__s,
      LoanApplicationAsset__c.PropertyAddress__PostalCode__s,
      LoanApplicationAsset__c.PropertyAddress__StateCode__s,
      LoanApplicationAsset__c.PropertyAddress__CountryCode__s,
      LoanApplicationAsset__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicationAsset__c.sObjectType;
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

  public HLA_LoanApplicationAssetsSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
  public List<LoanApplicationAsset__c> selectLoanApplicationAssetsByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicationAsset__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplication__c = :applId'
        )
        .toSOQL()
    );
  }
}
