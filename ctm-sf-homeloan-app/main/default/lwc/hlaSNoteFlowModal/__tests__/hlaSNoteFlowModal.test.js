import { createElement } from "lwc";
import HlaSNoteFlowModal from "c/hlaSNoteFlowModal";

describe("c-hla-s-note-flow-modal", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("modal header value", () => {
    // Arrange
    const element = createElement("c-hla-s-note-flow-modal", {
      is: HlaSNoteFlowModal
    });
    document.body.appendChild(element);

    const headerEl = element.shadowRoot.querySelector("lightning-modal-header");
    // Act

    // Assert
    expect(headerEl).not.toBeNull();
    expect(headerEl.textContent).toBe("");
    expect(headerEl.getAttributeNames()).toBeDefined();
  });

  it("modal body value", () => {
    // Arrange
    const element = createElement("c-hla-s-note-flow-modal", {
      is: HlaSNoteFlowModal
    });
    document.body.appendChild(element);

    const bodyEl = element.shadowRoot.querySelector("lightning-modal-body");
    // Act

    // Assert
    expect(bodyEl).not.toBeNull();
    expect(bodyEl.textContent).toBe("");
    expect(bodyEl.getAttributeNames()).toBeDefined();
  });
});
