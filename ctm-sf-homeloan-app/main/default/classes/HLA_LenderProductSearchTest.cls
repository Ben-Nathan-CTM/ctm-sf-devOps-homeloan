@IsTest
public class HLA_LenderProductSearchTest {
  //

  @IsTest
  public static void should_get_product_list() {
    // Given
    String lender = 'Westpac';
    // LenderProductSearch lps = new LenderProductSearch();

    // When
    String responseBody = HLA_LenderProductSearch.getProductList(lender);

    // Then
    System.AssertEquals(
      responseBody,
      '{"example":"test"}',
      'should have set the body to the MockHttpResponseGenerator response'
    );
  }
}