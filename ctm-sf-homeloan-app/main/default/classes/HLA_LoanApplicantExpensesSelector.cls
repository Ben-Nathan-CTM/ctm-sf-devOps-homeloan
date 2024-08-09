public inherited sharing class HLA_LoanApplicantExpensesSelector extends ApplicationSObjectSelector implements HLA_ILoanApplicantExpensesSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_ILoanApplicantExpensesSelector newInstance() {
    return (HLA_ILoanApplicantExpensesSelector) Application.Selector.newInstance(
      LoanApplicantExpense__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      LoanApplicantExpense__c.ResidentialLoanApplication__c,
      LoanApplicantExpense__c.Id,
      LoanApplicantExpense__c.Name,
      LoanApplicantExpense__c.ReferenceId__c,
      LoanApplicantExpense__c.ExternalId__c,
      LoanApplicantExpense__c.AId__c,
      LoanApplicantExpense__c.BId__c,
      LoanApplicantExpense__c.Percentage__c,
      LoanApplicantExpense__c.ExpenseType__c,
      LoanApplicantExpense__c.ExpenseSubType__c,
      LoanApplicantExpense__c.Frequency__c,
      LoanApplicantExpense__c.OutstandingAmt__c,
      LoanApplicantExpense__c.Amount__c,
      LoanApplicantExpense__c.isDirty__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return LoanApplicantExpense__c.sObjectType;
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

  public HLA_LoanApplicantExpensesSelector setNewSortOrder(
    String fieldToOrderBy
  ) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */

  public List<LoanApplicantExpense__c> selectLoanApplicantExpensesByReferenceId(
    String referenceId,
    String applId
  ) {
    return (List<LoanApplicantExpense__c>) Database.query(
      newQueryFactory()
        .selectfield('Name')
        .setCondition(
          'ReferenceId__c = :referenceId AND ResidentialLoanApplication__c = :applId'
        )
        .toSOQL()
    );
  }
}
