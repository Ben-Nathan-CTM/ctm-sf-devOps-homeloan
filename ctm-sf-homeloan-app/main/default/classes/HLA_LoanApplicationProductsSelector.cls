public inherited sharing class HLA_LoanApplicationProductsSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicationProductsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicationProductsSelector newInstance() {
    return (HLA_ILoanApplicationProductsSelector) Application.Selector.newInstance(
      LoanApplicationProduct__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicationProduct__c.Id,
      LoanApplicationProduct__c.LenderLogo__c,
      LoanApplicationProduct__c.Lender__c,
      LoanApplicationProduct__c.Name,
      LoanApplicationProduct__c.fixedperiod__c,
      LoanApplicationProduct__c.repaymentoption__c,
      LoanApplicationProduct__c.repayment__c,
      LoanApplicationProduct__c.comparisonrate__c,
      LoanApplicationProduct__c.actualcomparisonrate__c,
      LoanApplicationProduct__c.maxcapacity__c,
      LoanApplicationProduct__c.umi__c,
      LoanApplicationProduct__c.umibuffer__c,
      LoanApplicationProduct__c.dscr__c,
      LoanApplicationProduct__c.NDI__c,
      LoanApplicationProduct__c.LTI__c,
      LoanApplicationProduct__c.DTI__c,
      LoanApplicationProduct__c.IDH__c,
      LoanApplicationProduct__c.gearingratio__c,
      LoanApplicationProduct__c.hemratio__c,
      LoanApplicationProduct__c.NewPurchase__c,
      LoanApplicationProduct__c.Refinance__c,
      LoanApplicationProduct__c.FirstHomeBuyer__c,
      LoanApplicationProduct__c.TimetoFilePickUp__c,
      LoanApplicationProduct__c.ConditionalApproval__c,
      LoanApplicationProduct__c.Approval__c,
      LoanApplicationProduct__c.ResidentialLoanApplication__c,
      LoanApplicationProduct__c.rowhash__c,
      LoanApplicationProduct__c.variablerate__c,
      LoanApplicationProduct__c.valuationfees__c,
      LoanApplicationProduct__c.expenses__c,
      LoanApplicationProduct__c.ProductName__c,
      LoanApplicationProduct__c.SelectedProduct__c,
      LoanApplicationProduct__c.RecommendationOrder__c,      
      LoanApplicationProduct__c.PolicyStatus__c

    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicationProduct__c.sObjectType;
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

  public HLA_LoanApplicationProductsSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
  public List<LoanApplicationProduct__c> selectLoanApplicationProductsByApplicationId(
    Set<id> resiLoanIds
  ) {
    return (List<LoanApplicationProduct__c>) Database.query(
      newQueryFactory()
        .selectfield('Lender__r.logoRectangleUrl__c')
        .setCondition('ResidentialLoanApplication__c in :resiLoanIds')
        .toSOQL()
    );
  }

  public List<LoanApplicationProduct__c> selectUsingApplicationExternalIdInWhereClause(
    Set<String> applicationExternalIds
  ) {
    return (List<LoanApplicationProduct__c>) Database.query(
      newQueryFactory()
        .setCondition(
          'residentialloanapplication__c in (SELECT Id FROM residentialloanapplication__c WHERE applicationId__c IN :applicationExternalIds)'
        )
        .toSOQL()
    );
  }

  public List<LoanApplicationProduct__c> selectLoanApplicationProductsByApplicationIdOrderByRAC(
    Set<id> resiLoanIds
  ) {
    return (List<LoanApplicationProduct__c>) Database.query(
      newQueryFactory()
        .selectfield('Lender__r.logoRectangleUrl__c')
        .selectfield('Lender__r.Name')
        .setCondition('ResidentialLoanApplication__c in :resiLoanIds')
        .setOrdering(
          'repayment__c',
          fflib_QueryFactory.SortOrder.ASCENDING,
          true
        )
        .addOrdering(
          'actualcomparisonrate__c',
          fflib_QueryFactory.SortOrder.ASCENDING,
          true
        )
        .addOrdering(
          'comparisonrate__c',
          fflib_QueryFactory.SortOrder.ASCENDING,
          true
        )
        .toSOQL()
        .toLowerCase()
        .replaceFirst('select', 'select toLabel(PolicyCodes__c), ')
    );
  }
}
