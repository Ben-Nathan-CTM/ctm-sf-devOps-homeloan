public inherited sharing class HLA_TaskListEventsSelector extends ApplicationSObjectSelector implements HLA_ITaskListEventsSelector {
  public static HLA_ITaskListEventsSelector newInstance() {
    return (HLA_ITaskListEventsSelector) Application.Selector.newInstance(
      HLA_TaskListEvent__e.SObjectType
    );
  }

  public List<Schema.SObjectField> getAdditionalSObjectFieldList() {
    return new List<Schema.SObjectField>{};
  }

  public Schema.SObjectType getSObjectType() {
    return HLA_TaskListEvent__e.SObjectType;
  }
}
