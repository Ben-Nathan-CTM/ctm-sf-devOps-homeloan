import { createElement } from "lwc";
import HlaSnoteWithFocusedTab from "c/hlaSnoteWithFocusedTab";
import getFilteredSNotes from "@salesforce/apex/HLA_SNotesService.getFilteredSNoteData";
import HlaSNoteFlowModal from "c/hlaSNoteFlowModal";

const mockFilteredSnotes = require("./data/getFilteredSNotes.json");

// create mocks
jest.mock(
  "@salesforce/apex/HLA_SNotesService.getFilteredSNoteData",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

jest.mock("c/hlaSNoteFlowModal");

describe("c-hla-snote-with-focused-tab", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  it("should launch the flow", async () => {
    // Arrange
    const element = createElement("c-hla-snote-with-focused-tab", {
      is: HlaSnoteWithFocusedTab
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

  it("should return Snote Data", () => {
    // Arrange
    const element = createElement("c-hla-snote-with-focused-tab", {
      is: HlaSnoteWithFocusedTab
    });
    document.body.appendChild(element);

    // Act

    getFilteredSNotes.emit(mockFilteredSnotes);

    // Assert

    return Promise.resolve().then(() => {
      // Select elements for validation
      const datatableEl = element.shadowRoot.querySelector(
        "lightning-datatable"
      );
      expect(datatableEl.textContent).not.toBeNull();
    });
  });
});
