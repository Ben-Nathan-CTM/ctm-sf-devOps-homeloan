import { createElement } from "lwc";
import HlaApplicantsList from "c/hlaApplicantsList";

describe("c-hla-applicants-list", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("is accessible when applicants returned", () => {
    const element = createElement("c-hla-applicant-list", {
      is: HlaApplicantsList
    });

    document.body.appendChild(element);
    getProducts.emit(mockGetProducts);

    return Promise.resolve().then(() => expect(element).toBeAccessible());
  });
});
