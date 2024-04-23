public interface HLA_ITaskListEventsSelector {
  Schema.SObjectType getSObjectType();
  List<Schema.SObjectField> getAdditionalSObjectFieldList();
}
