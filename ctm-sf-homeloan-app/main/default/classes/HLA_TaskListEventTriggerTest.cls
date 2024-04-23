@IsTest
public class HLA_TaskListEventTriggerTest {
  //

  @IsTest
  public static void should_handle_trigger_after_insert() {
    // Given
    Account mockAcct = new Account(
      Id = fflib_IDgenerator.generate(Account.sObjectType),
      name = 'Test'
    );
    ResidentialLoanApplication__c mockLoanApp = new ResidentialLoanApplication__c(
      Id = fflib_IDgenerator.generate(
        ResidentialLoanApplication__c.sObjectType
      ),
      Account__c = mockAcct.id
    );

    HLA_TaskListEvent__e mockEventInternal = new HLA_TaskListEvent__e();
    mockEventInternal.OriginatedInternally__c = true;
    mockEventInternal.RelatedRecordId__c = mockLoanApp.id;
    mockEventInternal.OriginatedInternally__c = true;

    List<HLA_TaskListEvent__e> taskListEvents = new List<HLA_TaskListEvent__e>{
      mockEventInternal
    };

    fflib_ApexMocks mocks = new fflib_ApexMocks();
    HLA_ITaskListEventService mockService = (HLA_ITaskListEventService) mocks.mock(
      HLA_ITaskListEventService.class
    );

    Application.Service.setMock(HLA_ITaskListEventService.class, mockService);
    // When

    Test.startTest();
    Database.SaveResult result = EventBus.publish(mockEventInternal);
    Test.stopTest();

    // Then
    //(HLA_ITaskListEventService) mocks.verify(mockService, 1)
    //  .processEvents(taskListEvents);
  }
}
