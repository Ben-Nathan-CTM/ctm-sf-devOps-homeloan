public with sharing class HLA_AccountService implements HLA_IAccountService {
  //

  private static HLA_IAccountService service() {
    return (HLA_IAccountService) Application.Service.newInstance(
      HLA_IAccountService.class
    );
  }

  public static Account parseAndCreateNewAccount(String requestBody) {
    return service().parseAndCreateNewAccount(requestBody);
  }
}