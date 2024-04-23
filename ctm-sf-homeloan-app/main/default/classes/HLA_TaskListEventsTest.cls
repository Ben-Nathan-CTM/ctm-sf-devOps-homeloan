@IsTest
public class HLA_TaskListEventsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<HLA_TaskListEvent__e> listTLE = new List<HLA_TaskListEvent__e>{
      new HLA_TaskListEvent__e()
    };
    // When
    HLA_ITaskListEvents tle = HLA_TaskListEvents.newInstance(listTLE);

    // Then
    System.assert(tle instanceof HLA_TaskListEvents);
  }
}
