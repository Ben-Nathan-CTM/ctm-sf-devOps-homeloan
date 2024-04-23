@isTest
global class HLA_AFGCalloutTest{    
 @isTest
  public static void should_make_callout() {
    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
      
      Account testAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      CustomerId__c = '123',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );
    uow.register(testAcc);

    ResidentialLoanApplication__c mockResi = new ResidentialLoanApplication__c(
      Account__c = testAcc.id,
      name = 'test RLA',
      ApplicationId__c = '123'
    );
     uow.register(mockResi, ResidentialLoanApplication__c.Account__c, testAcc);
     
   Id rlaId = mockResi.id;
   List<Id> residentialLoanAppIds = new List<Id>{ rlaId };
   String correlationId = 'asdasd-asdasd-asdasd-asd';


    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    Test.startTest();
    Integer result = HLA_AFGCallout.requestAFGCallout(residentialLoanAppIds,correlationId);
    Test.stopTest();
	Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      1,
      'should have made a callouts'
    );
  }
}