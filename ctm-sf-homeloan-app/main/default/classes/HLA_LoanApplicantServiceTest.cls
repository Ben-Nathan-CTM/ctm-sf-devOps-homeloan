@IsTest
public class HLA_LoanApplicantServiceTest {
  @TestSetup
  static void makeData() {
    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account testAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      PersonEmail = 'test@gmail.com',
      CustomerId__c = '123',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );

    uow.register(testAcc);

    Contact testContact = new Contact(
      firstName = 'Test',
      lastName = 'Contact',
      Email = 'test@gmail.com',
      MobilePhone = '0400111222'
    );
    uow.register(testContact);

    ResidentialLoanApplication__c mockResi = new ResidentialLoanApplication__c(
      Account__c = testAcc.id,
      name = 'test RLA',
      ApplicationId__c = '123'
    );

    uow.register(mockResi, ResidentialLoanApplication__c.Account__c, testAcc);
    uow.commitwork();
  }

  @IsTest
  public static void should_not_attach_contacts_to_applicants_because_of_personType() {
    // Given

    fflib_ApexMocks mocks = new fflib_ApexMocks();

    IApplicationSObjectUnitOfWork mockUoW = (IApplicationSObjectUnitOfWork) mocks.mock(
      ApplicationSObjectUnitOfWork.class
    );
    Application.UnitOfWork.setMock(mockUoW);

    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      ResidentialLoanApplication__c = fflib_IDGenerator.generate(
        ResidentialLoanApplication__c.SObjectType
      ),
      id = fflib_IDGenerator.generate(LoanApplicant__c.SObjectType),
      EmailAddress__c = 'test@gmail.com'
    );

    List<LoanApplicant__c> applicantList = new List<LoanApplicant__c>{
      testLoanApplicant
    };

    // When

    HLA_LoanApplicantService.attachContactsToApplicants(applicantList);

    // Then
    ((IApplicationSObjectUnitOfWork) mocks.verify(mockUoW, 0)).commitwork();
  }

  @IsTest
  public static void should_correctly_attach_contacts_to_applicants() {
    // Given

    fflib_ApexMocks mocks = new fflib_ApexMocks();

    IApplicationSObjectUnitOfWork mockUoW = (IApplicationSObjectUnitOfWork) mocks.mock(
      ApplicationSObjectUnitOfWork.class
    );
    Application.UnitOfWork.setMock(mockUoW);

    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      ResidentialLoanApplication__c = fflib_IDGenerator.generate(
        ResidentialLoanApplication__c.SObjectType
      ),
      EmailAddress__c = 'test@gmail.com',
      PersonType__c = '831'
    );

    List<LoanApplicant__c> applicantList = new List<LoanApplicant__c>{
      testLoanApplicant
    };

    // When

    HLA_LoanApplicantService.attachContactsToApplicants(applicantList);

    // Then
    ((IApplicationSObjectUnitOfWork) mocks.verify(mockUoW, 1)).commitwork();
  }

  @IsTest
  public static void should_correctly_attach_new_contacts_to_applicants() {
    // Given

    fflib_ApexMocks mocks = new fflib_ApexMocks();

    IApplicationSObjectUnitOfWork mockUoW = (IApplicationSObjectUnitOfWork) mocks.mock(
      ApplicationSObjectUnitOfWork.class
    );
    Application.UnitOfWork.setMock(mockUoW);

    // test applicant with an email address that doesn't exists on any contacts - should create new
    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      ResidentialLoanApplication__c = fflib_IDGenerator.generate(
        ResidentialLoanApplication__c.SObjectType
      ),
      EmailAddress__c = 'unknown@gmail.com',
      PersonType__c = '831'
    );

    List<LoanApplicant__c> applicantList = new List<LoanApplicant__c>{
      testLoanApplicant
    };

    // When
    Test.startTest();
    HLA_LoanApplicantService.attachContactsToApplicants(applicantList);
    Test.stopTest();

    // Then
    ((IApplicationSObjectUnitOfWork) mocks.verify(mockUoW, 1)).commitwork();
  }
}
