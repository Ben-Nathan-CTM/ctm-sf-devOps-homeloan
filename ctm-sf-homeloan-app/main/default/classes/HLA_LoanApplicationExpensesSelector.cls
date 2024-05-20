public inherited sharing class HLA_LoanApplicationExpensesSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicationExpensesSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicationExpensesSelector newInstance() {
    return (HLA_ILoanApplicationExpensesSelector) Application.Selector.newInstance(
      LoanApplicationExpense__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicationExpense__c.ResidentialLoanApplication__c,
      LoanApplicationExpense__c.Id,
      LoanApplicationExpense__c.Name,
      LoanApplicationExpense__c.ExternalId__c,
      LoanApplicationExpense__c.ReferenceId__c,
      LoanApplicationExpense__c.Amount__c,
      LoanApplicationExpense__c.OutstandingAmount__c,
      LoanApplicationExpense__c.Frequency__c,
      LoanApplicationExpense__c.ExpenseDebtType__c,
      LoanApplicationExpense__c.ExpenseType__c,
      LoanApplicationExpense__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicationExpense__c.sObjectType;
  }

  @TestVisible private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
    return new List<Schema.SObjectField>{};
  }

  public override String getOrderBy() {
    if (newOrderByField != null) {
      DEFAULT_ORDERBY_FIELD = newOrderByField;
    }
    return DEFAULT_ORDERBY_FIELD;
  }

  public HLA_LoanApplicationExpensesSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
  public List<LoanApplicationExpense__c> selectLoanApplicationExpensesByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicationExpense__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplication__c = :applId'
        )
        .toSOQL()
    );
  }
}