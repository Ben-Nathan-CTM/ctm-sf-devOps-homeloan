@IsTest
public class HLA_ApplicationServiceTest {
  //

  @TestSetup
  static void makeData() {
    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    system.debug(uow);
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

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

    //uow.register(mockResi);
    uow.register(mockResi, ResidentialLoanApplication__c.Account__c, testAcc);

    // application related objects
    LoanApplicationAsset__c testLoanApplicationAsset = new LoanApplicationAsset__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationAsset,
      LoanApplicationAsset__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicationExpense__c testLoanApplicationExpense = new LoanApplicationExpense__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationExpense,
      LoanApplicationExpense__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicationIncome__c testLoanApplicationIncome = new LoanApplicationIncome__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationIncome,
      LoanApplicationIncome__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicationLiability__c testLoanApplicationLiability = new LoanApplicationLiability__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationLiability,
      LoanApplicationLiability__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicationProduct__c testLoanApplicationProduct = new LoanApplicationProduct__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationProduct,
      LoanApplicationProduct__c.ResidentialLoanApplication__c,
      mockResi
    );

    ThirdParty__c testLoanApplicationThirdParty = new ThirdParty__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationThirdParty,
      ThirdParty__c.ResidentialLoanApplication__c,
      mockResi
    );

    ResponsibleLending__c testLoanApplicationResponsibleParty = new ResponsibleLending__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationResponsibleParty,
      ResponsibleLending__c.ResidentialLoanApplication__c,
      mockResi
    );

    OtherAddress__c testLoanApplicationOtherAddress = new OtherAddress__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationOtherAddress,
      OtherAddress__c.ResidentialLoanApplication__c,
      mockResi
    );

    // loan applicant
    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      ResidentialLoanApplication__c = mockResi.id
    );
    uow.register(
      testLoanApplicant,
      LoanApplicant__c.ResidentialLoanApplication__c,
      mockResi
    );

    // applicant related objects
    LoanApplicantAsset__c testLoanApplicantAsset = new LoanApplicantAsset__c(
      LoanApplicant__c = testLoanApplicant.id,
      LoanApplicationAsset__c = testLoanApplicationAsset.id
    );

    uow.register(
      testLoanApplicantAsset,
      LoanApplicantAsset__c.LoanApplicant__c,
      testLoanApplicant
    );
    uow.registerRelationship(
      testLoanApplicantAsset,
      LoanApplicantAsset__c.LoanApplicationAsset__c,
      testLoanApplicationAsset
    );

    LoanApplicantExpense__c testLoanApplicantExpense = new LoanApplicantExpense__c(
      LoanApplicant__c = testLoanApplicant.id,
      LoanApplicationExpense__c = testLoanApplicationExpense.id
    );

    uow.register(
      testLoanApplicantExpense,
      LoanApplicantExpense__c.LoanApplicant__c,
      testLoanApplicant
    );
    uow.registerRelationship(
      testLoanApplicantExpense,
      LoanApplicantExpense__c.LoanApplicationExpense__c,
      testLoanApplicationExpense
    );

    LoanApplicantIncome__c testLoanApplicantIncome = new LoanApplicantIncome__c(
      LoanApplicant__c = testLoanApplicant.id,
      LoanApplicationIncome__c = testLoanApplicationIncome.id
    );

    uow.register(
      testLoanApplicantIncome,
      LoanApplicantIncome__c.LoanApplicant__c,
      testLoanApplicant
    );
    uow.registerRelationship(
      testLoanApplicantIncome,
      LoanApplicantIncome__c.LoanApplicationIncome__c,
      testLoanApplicationIncome
    );

    LoanApplicantLiability__c testLoanApplicantLiability = new LoanApplicantLiability__c(
      LoanApplicant__c = testLoanApplicant.id,
      LoanApplicationLiability__c = testLoanApplicationLiability.id
    );

    uow.register(
      testLoanApplicantLiability,
      LoanApplicantLiability__c.LoanApplicant__c,
      testLoanApplicant
    );
    uow.registerRelationship(
      testLoanApplicantLiability,
      LoanApplicantLiability__c.LoanApplicationLiability__c,
      testLoanApplicationLiability
    );

    LoanApplicantEmployment__c testLoanApplicantEmployment = new LoanApplicantEmployment__c(
      LoanApplicant__c = testLoanApplicant.id
    );

    uow.register(
      testLoanApplicantEmployment,
      LoanApplicantEmployment__c.LoanApplicant__c,
      testLoanApplicant
    );

    //  documents & links
    LoanApplicationDocument__c testLoanAppDocument = new LoanApplicationDocument__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanAppDocument,
      LoanApplicationDocument__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicationDocumentLink__c testLoanAppDocumentLink = new LoanApplicationDocumentLink__c(
      LoanApplicationDocument__c = testLoanAppDocument.id
    );

    uow.register(
      testLoanAppDocumentLink,
      LoanApplicationDocumentLink__c.LoanApplicationDocument__c,
      testLoanAppDocument
    );

    //  loan related objects
    Loan__c testLoan = new Loan__c(ResidentialLoanApplication__c = mockResi.id);

    uow.register(testLoan, Loan__c.ResidentialLoanApplication__c, mockResi);

    LoanContribution__c testLoanContribution = new LoanContribution__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanContribution,
      LoanContribution__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanCost__c testLoanCost = new LoanCost__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanCost,
      LoanCost__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanSecurity__c testLoanSecurity = new LoanSecurity__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanSecurity,
      LoanSecurity__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanSplit__c testLoanSplit = new LoanSplit__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanSplit,
      LoanSplit__c.ResidentialLoanApplication__c,
      mockResi
    );

    Identification__c testIdentification = new Identification__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testIdentification,
      Identification__c.ResidentialLoanApplication__c,
      mockResi
    );
    uow.commitwork();
  }

  private static ResidentialLoanApplication__c getResidentialLoanApplication() {
    return [
      SELECT id, name, ApplicationId__c, account__r.CustomerId__c
      FROM ResidentialLoanApplication__c
    ][0];
  }

  @IsTest
  public static void should_submit_application_updates() {
    // Given

    List<ResidentialLoanApplication__c> rlaList = new List<ResidentialLoanApplication__c>{
      getResidentialLoanApplication()
    };

    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Test.startTest();

    HLA_ApplicationService.submitApplicationUpdates(rlaList);

    Test.stopTest();

    system.assert(
      MockHttpResponseGenerator.calloutCounter == 2,
      'should have generated 2 mock callouts'
    );
  }

  @IsTest
  public static void should_correctly_call_eligible_loan_products() {
    // Given
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    HLA_IApplicationService mockApplicationService = (HLA_IApplicationService) mocks.mock(
      HLA_ApplicationServiceImp.class
    );

    Id mockResiLoanId = fflib_IDGenerator.generate(
      ResidentialLoanApplication__c.SObjectType
    );

    List<LoanApplicationProduct__c> loanAppList = new List<LoanApplicationProduct__c>{
      new LoanApplicationProduct__c()
    };

    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    mocks.startStubbing();
    mocks.when(mockApplicationService.getEligibleLoanProducts(mockResiLoanId))
      .thenReturn(loanAppList);

    mocks.stopStubbing();

    Application.Service.setMock(
      HLA_IApplicationService.class,
      mockApplicationService
    );

    // When
    Test.startTest();

    HLA_ApplicationService.getEligibleLoanProducts(mockResiLoanId);

    Test.stopTest();

    // Then

    ((HLA_IApplicationService) mocks.verify(mockApplicationService, 1))
      .getEligibleLoanProducts(mockResiLoanId);
  }

  @IsTest
  public static void should_return_eligible_loan_products() {
    // Given

    ResidentialLoanApplication__c mockResi = getResidentialLoanApplication();
    List<LoanApplicationProduct__c> loanAppList = new List<LoanApplicationProduct__c>{
      new LoanApplicationProduct__c(ResidentialLoanApplication__c = mockResi.id)
    };
    insert loanAppList;

    // mocks.startStubbing();
    // mocks.when(mockApplicationService.getEligibleLoanProducts(mockResiLoanId))
    //   .thenReturn(loanAppList);

    // mocks.stopStubbing();

    // Application.Service.setMock(
    //   HLA_IApplicationService.class,
    //   mockApplicationService
    // );

    // When
    Test.startTest();

    List<LoanApplicationProduct__c> testList = HLA_ApplicationService.getEligibleLoanProducts(
      mockResi.id
    );

    Test.stopTest();

    // Then

    Assert.areEqual(testList[0].ResidentialLoanApplication__c, mockResi.id);
  }

  @IsTest
  public static void should_remove_application_and_related_records() {
    // Given
    Assert.isFalse(
      [
          SELECT id
          FROM ResidentialLoanApplication__c
        ]
        .isEmpty()
    );
    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationAsset__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationExpense__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationIncome__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationLiability__c
        ]
        .isEmpty()
    );

    // applicant related objects
    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicantAsset__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicantExpense__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicantIncome__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicantLiability__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicantEmployment__c
        ]
        .isEmpty()
    );

    //  documents & links
    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationDocument__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationDocumentLink__c
        ]
        .isEmpty()
    );

    //  loan related objects

    Assert.isFalse(
      [
          SELECT id
          FROM LoanApplicationProduct__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanContribution__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanCost__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanSecurity__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM LoanSplit__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM Identification__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM ThirdParty__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM ResponsibleLending__c
        ]
        .isEmpty()
    );

    Assert.isFalse(
      [
          SELECT id
          FROM OtherAddress__c
        ]
        .isEmpty()
    );

    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 200;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    List<Id> rlaIds = new List<id>{ getResidentialLoanApplication().id };
    // When
    Test.startTest();

    HLA_ApplicationService.deleteApplicationAndRelatedrecords(rlaIds);

    Test.stopTest();

    // Then
    Assert.isFalse(
      [
          SELECT id
          FROM ResidentialLoanApplication__c
        ]
        .isEmpty()
    );
    Assert.isTrue(
      [
          SELECT id
          FROM task
        ]
        .isEmpty()
    );
    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationAsset__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationExpense__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationIncome__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationLiability__c
        ]
        .isEmpty()
    );

    // applicant related objects
    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicantAsset__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicantExpense__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicantIncome__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicantLiability__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicantEmployment__c
        ]
        .isEmpty()
    );

    //  documents & links
    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationDocument__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationDocumentLink__c
        ]
        .isEmpty()
    );

    //  loan related objects

    Assert.isTrue(
      [
          SELECT id
          FROM LoanApplicationProduct__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanContribution__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanCost__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanSecurity__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM LoanSplit__c
        ]
        .isEmpty()
    );


    Assert.isTrue(
      [
          SELECT id
          FROM ResponsibleLending__c
        ]
        .isEmpty()
    );

    Assert.isTrue(
      [
          SELECT id
          FROM OtherAddress__c
        ]
        .isEmpty()
    );
  }
}
