@IsTest
public class HLA_TaskListEventServiceTest {
  static String taskListJSON = '[{\"attributes\":{\"type\":\"Task\",\"url\":\"/services/data/v56.0/sobjects/Task/00T8s000001hNaSEAU\"},\"WhatId\":\"a2P8s0000001fVlEAI\",\"Id\":\"00T8s000001hNaSEAU\",\"Status\":\"Completed\",\"Subject\":\"Time to move in. Housewarming party at your place. Whoop Whoop!\",\"ActivityDate\":\"2022-12-12\"}]';

  @IsTest
  public static void should_process_the_events() {
    // Given
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    IApplicationSObjectUnitOfWork mockUoW = (IApplicationSObjectUnitOfWork) mocks.mock(
      ApplicationSObjectUnitOfWork.class
    );
    Application.UnitOfWork.setMock(mockUoW);

    HLA_IResidentialLoanApplicationsSelector mockRLASelector = (HLA_IResidentialLoanApplicationsSelector) mocks.mock(
      HLA_ResidentialLoanApplicationsSelector.class
    );

    Account mockAcct = new Account(
      Id = fflib_IDgenerator.generate(Account.sObjectType),
      name = 'Test',
      CustomerId__c = '123'
    );
    ResidentialLoanApplication__c mockLoanApp = new ResidentialLoanApplication__c(
      Id = fflib_IDgenerator.generate(
        ResidentialLoanApplication__c.sObjectType
      ),
      Account__c = mockAcct.id,
      ApplicationId__c = 'appid123'
    );
    mockLoanApp = (ResidentialLoanApplication__c) fflib_ApexMocksUtils.setReadOnlyFields(
      mockLoanApp,
      ResidentialLoanApplication__c.class,
      new Map<String, Object>{ 'Account__r' => mockAcct }
    );

    Task mockTask = new Task(
      Id = fflib_IDgenerator.generate(Task.sObjectType),
      whatId = mockLoanApp.id
    );

    List<ResidentialLoanApplication__c> listRLA = new List<ResidentialLoanApplication__c>{
      mockLoanApp
    };

    listRLA = (List<ResidentialLoanApplication__c>) fflib_ApexMocksUtils.makeRelationship(
      'ResidentialLoanApplication__c',
      'Task',
      listRLA,
      'whatId',
      new List<List<Task>>{ new List<Task>{ mockTask } }
    );

    HLA_TaskListEvent__e mockEventInternal = new HLA_TaskListEvent__e();
    mockEventInternal.OriginatedInternally__c = true;
    mockEventInternal.RelatedRecordId__c = mockLoanApp.id;
    mockEventInternal.OriginatedInternally__c = true;

    HLA_TaskListEvent__e mockEventExternal = new HLA_TaskListEvent__e();
    mockEventExternal.OriginatedInternally__c = false;
    mockEventExternal.RelatedRecordId__c = mockLoanApp.id;
    mockEventExternal.TaskListJSON__c = taskListJSON;

    List<HLA_TaskListEvent__e> taskListEvents = new List<HLA_TaskListEvent__e>{
      mockEventInternal,
      mockEventExternal
    };

    mocks.startStubbing();
    mocks.when(mockRLASelector.sObjectType())
      .thenReturn(ResidentialLoanApplication__c.SObjectType);
    mocks.when(
        mockRLASelector
          .selectByIdWithTaskListWithLoanTracking(new Set<id>{ mockLoanApp.id })
      )
      .thenReturn(listRLA);

    mocks.stopStubbing();

    Application.Selector.setMock(mockRLASelector);
    test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    // When
    test.startTest();
    HLA_TaskListEventService.processEvents(taskListEvents);
    test.stopTest();

    // Then
    ((IApplicationSObjectUnitOfWork) mocks.verify(mockUoW, 1)).commitwork();
  }
}
