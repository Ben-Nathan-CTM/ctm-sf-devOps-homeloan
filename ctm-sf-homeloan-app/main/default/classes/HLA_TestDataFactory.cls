public class HLA_TestDataFactory {
  public static void makeData() {
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

    LoanApplicationAsset__c testLoanApplicationAsset = new LoanApplicationAsset__c(
      ResidentialLoanApplication__c = mockResi.id
    );

    uow.register(
      testLoanApplicationAsset,
      LoanApplicationAsset__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      ResidentialLoanApplication__c = mockResi.id
    );
    uow.register(
      testLoanApplicant,
      LoanApplicant__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicantAsset__c testLoanApplicantAsset = new LoanApplicantAsset__c(
      Name = 'LoanApplicant Test',
      ResidentialLoanApplicationId__c = mockResi.id,
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

    LoanApplicationLiability__c testLoanApplicationLiability = new LoanApplicationLiability__c(
      ResidentialLoanApplication__c = mockResi.id,
      ReferenceId__c = '123Abc-456def'
    );

    uow.register(
      testLoanApplicationLiability,
      LoanApplicationLiability__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicantLiability__c testLoanApplicantLiability = new LoanApplicantLiability__c(
      Name = 'LoanApplicant Test',
      ResidentialLoanApplicationId__c = mockResi.id,
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

    LoanApplicationIncome__c testLoanApplicationIncome = new LoanApplicationIncome__c(
      ResidentialLoanApplication__c = mockResi.id,
      ReferenceId__c = '123Abc-456def'
    );

    uow.register(
      testLoanApplicationIncome,
      LoanApplicationIncome__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicantIncome__c testLoanApplicantIncome = new LoanApplicantIncome__c(
      ResidentialLoanApplication__c = mockResi.id,
      LoanApplicationIncome__c = testLoanApplicationIncome.id
    );

    uow.register(
      testLoanApplicantIncome,
      LoanApplicantIncome__c.LoanApplicationIncome__c,
      testLoanApplicationIncome
    );

    uow.registerRelationship(
      testLoanApplicantIncome,
      LoanApplicantIncome__c.LoanApplicationIncome__c,
      testLoanApplicationIncome
    );

    LoanApplicationExpense__c testLoanApplicationExpense = new LoanApplicationExpense__c(
      ResidentialLoanApplication__c = mockResi.id,
      ReferenceId__c = '123Abc-456def'
    );
    uow.register(
      testLoanApplicationExpense,
      LoanApplicationExpense__c.ResidentialLoanApplication__c,
      mockResi
    );

    LoanApplicantExpense__c testLoanApplicantExpense = new LoanApplicantExpense__c(
      ResidentialLoanApplication__c = mockResi.id,
      LoanApplicationExpense__c = testLoanApplicationExpense.id
    );

    uow.register(
      testLoanApplicantExpense,
      LoanApplicantExpense__c.LoanApplicationExpense__c,
      testLoanApplicationExpense
    );

    uow.registerRelationship(
      testLoanApplicantExpense,
      LoanApplicantExpense__c.LoanApplicationExpense__c,
      testLoanApplicationExpense
    );

    uow.commitwork();
  }
}
