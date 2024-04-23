public inherited sharing class HLA_EnumsSelector extends ApplicationSObjectSelector implements HLA_IEnumsSelector {
  private String newOrderByField;
  private static String DEFAULT_ORDERBY_FIELD = 'Name';

  public static HLA_IEnumsSelector newInstance() {
    return (HLA_IEnumsSelector) Application.Selector.newInstance(
      Enum__c.SObjectType
    );
  }

  // the list of fields to be included in query
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>{
      Enum__c.Id,
      Enum__c.Name,
      Enum__c.Active__c,
      Enum__c.DisplayName__c,
      Enum__c.Value__c,
      Enum__c.GlobalPicklistAPIName__c,
      Enum__c.EnumType__c
    };
  }

  // SObject type
  public Schema.SObjectType getSObjectType() {
    return Enum__c.sObjectType;
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

  public HLA_EnumsSelector setNewSortOrder(String fieldToOrderBy) {
    this.newOrderByField = fieldToOrderBy;
    return this;
  }

  /**
   * We will return List<Sobjects> and leave it to the caller to instatiate a Map if they need easy access to Id's
   */
  public List<Enum__c> selectAllActiveEnums() {
    return Database.query(
      newQueryFactory().setCondition('Active__c = true').toSOQL()
    );
  }
}
