import { createElement } from "lwc";
import HlaProductEligibilityTable from "c/hlaProductEligibilityTable";
import HlaSNoteFlowModal from "c/hlaSNoteFlowModal";
import getEligibleLoanProducts from "@salesforce/apex/HLA_ApplicationService.getEligibleLoanProducts";
//import deleteProducts from "@salesforce/apex/HLA_ProductRecommendations.deleteExistingProductRecommendations";
//import requestNewProductsCallout from "@salesforce/apex/HLA_ProductRecommendations.requestNewProductsCallout";

const mockProducts = require("./data/getEligibleLoanProducts.json");

// create mocks
jest.mock(
  "@salesforce/apex/HLA_ApplicationService.getEligibleLoanProducts",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

jest.mock(
  "@salesforce/apex/HLA_ProductRecommendations.deleteExistingProductRecommendations",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);
jest.mock(
  "@salesforce/apex/HLA_ProductRecommendations.requestNewProductsCallout",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-hla-product-eligibility-table", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  it("should launch the flow", async () => {
    // Arrange
    const element = createElement("c-hla-product-eligibility-table", {
      is: HlaProductEligibilityTable
    });
    document.body.appendChild(element);

    const buttonEle = element.shadowRoot.querySelector("lightning-button");

    HlaSNoteFlowModal.open = jest.fn().mockResolvedValue(Promise.resolve());

    // Act

    buttonEle.click();

    // Assert

    return Promise.resolve().then(() => {
      // Select elements for validation
      expect(HlaSNoteFlowModal.open.mock.calls).toHaveLength(1);
    });
  });

  it("should return Eligible Loan Products", () => {
    // Arrange
    const element = createElement("c-hla-product-eligibility-table", {
      is: HlaProductEligibilityTable
    });
    document.body.appendChild(element);

    // Act

    getEligibleLoanProducts.emit(mockProducts);

    // Assert

    return Promise.resolve().then(() => {
      // Select elements for validation
      const datatableEl = element.shadowRoot.querySelector(
        "c-hla-custom-product-table"
      );
      expect(datatableEl.textContent).not.toBeNull();
    });
  });

  it("should handleRowSelect", () => {
    // Arrange
    const element = createElement("c-hla-product-eligibility-table", {
      is: HlaProductEligibilityTable
    });

    document.body.appendChild(element);
    getEligibleLoanProducts.emit(mockProducts);

    // Mock handler for event
    const handler = jest.fn();
    // Add event listener to catch toast event
    element.addEventListener("rowselection", handler);

    // Act

    element.dispatchEvent(
      new CustomEvent("rowselection", {
        detail: { selectedRows: [mockProducts] }
      })
    );

    // Assert

    return Promise.resolve().then(() => {
      expect(handler).toHaveBeenCalledTimes(1);
    });
  });
});
