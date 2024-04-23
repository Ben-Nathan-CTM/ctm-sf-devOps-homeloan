@IsTest
public class HLA_TaskListEventsSelectorTest {
  //

  @IsTest
  public static void should_return_newInstance() {
    // Given
    // When
    HLA_ITaskListEventsSelector selector = HLA_TaskListEventsSelector.newInstance();

    // Then
    System.assert(selector instanceof HLA_TaskListEventsSelector);
  }

  @IsTest
  public static void should_return_sobject_type() {
    // Given
    HLA_ITaskListEventsSelector selector = HLA_TaskListEventsSelector.newInstance();

    // When
    Schema.SObjectType sobjType = selector.getSObjectType();

    // Then
    System.assert(sobjType == HLA_TaskListEvent__e.sObjectType);
  }

  @IsTest
  public static void should_return_additional_field_list() {
    // Given
    HLA_ITaskListEventsSelector selector = HLA_TaskListEventsSelector.newInstance();

    // When
    List<Schema.SObjectField> fields = selector.getAdditionalSObjectFieldList();

    // Then
    System.assert(fields != null, 'should return an instantiated list');
  }
}
