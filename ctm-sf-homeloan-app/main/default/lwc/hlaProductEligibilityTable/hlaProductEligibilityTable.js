import { LightningElement, wire, api, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { subscribe, onError, unsubscribe } from "lightning/empApi";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { updateRecord } from "lightning/uiRecordApi";
import getEligibleLoanProducts from "@salesforce/apex/HLA_ApplicationService.getEligibleLoanProducts";
import deleteProducts from "@salesforce/apex/HLA_ProductRecommendations.deleteExistingProductRecommendations";
import requestNewProductsCallout from "@salesforce/apex/HLA_ProductRecommendations.requestNewProductsCallout";
import HlaSNoteFlowModal from "c/hlaSNoteFlowModal";
import PR_ID_FIELD from  '@salesforce/schema/LoanApplicationProduct__c.Id';
import PR_RECOMMENDATION_ORDER from '@salesforce/schema/LoanApplicationProduct__c.RecommendationOrder__c';
import RLA_ID_FIELD from "@salesforce/schema/ResidentialLoanApplication__c.Id";
import RLA_PRODUCT_ROWHASH from "@salesforce/schema/ResidentialLoanApplication__c.ProductHash__c";
import RLA_LOGOURL from "@salesforce/schema/ResidentialLoanApplication__c.LogoURL__c";
import RLA_LENDER from "@salesforce/schema/ResidentialLoanApplication__c.Lender__c";
import RLA_LENDER_NAME from "@salesforce/schema/ResidentialLoanApplication__c.LenderName__c";

// Custom Labels Imports
import labelRecommendedProducts from "@salesforce/label/c.Recommended_Products";

const LENDER_ELIGIBILITY = "Lender Eligibility";
const SUCCESS_TITLE = "Success";
const SUCCESS_SAVED_MESSAGE = "Product selection has been saved";
const SUCCESS_PRODUCTS_REQUESTED_MESSAGE = "New Products have been requested";
const SUCCESS_PRODUCTS_DELETED_MESSAGE = "Exisitng Products have been removed";
const SUCCESS_VARIANT = "success";
const WARNING_TITLE = "Warning";
const WARNING_VARIANT = "warning";
const WARNING_MESSAGE = "Product change not saved";
const ERROR_TITLE = "Error";
const ERROR_VARIANT = "error";
const PRODUCTS_REQUESTED =
  "New Products Requested, hopefully they won't take long...";

export default class HlaProductEligibilityTable extends NavigationMixin(
  LightningElement
) {

  draftValues = [];

  isLoading = true;
  error;
  witheldLoanProducts=[];
  eligibleLoanProducts = [];
  ineligibleLoanProducts = [];
  cachedResult;
  selectedRow = [];
  originalSelectedRowHash = "none selected";
  selectedRowHash;
  lender;
  lenderLogo;
  lenderName;
  label = { labelRecommendedProducts };
  productsRequested = false;
  showRefreshButton = true;
  productRequestMessage = PRODUCTS_REQUESTED;
  saveDisabled = true;
  refreshDisabled = true;
  channelName = "/event/HLA_ProductRecommendationsReceived__e";
  subscription = null;
  productLoadMessage = "Retrieving Products...";

  get hasProductsLoaded() {
    return (
      this.eligibleLoanProducts?.length + this.ineligibleLoanProducts?.length >
      0
    );
  }

  @track inputVariables = [];

  @api recordId;

  columns = [
    {
      label: "Lender",
      fieldName: "comparisonrate__c",
      type: "imageColumn",
      initialWidth: 150,
      typeAttributes: {
        lenderImageUrl: {
          fieldName: "logoURL"
        },
        productId: {
          fieldName: "Id"
        },
        title: {
          fieldName: "ProductName__c"
        },
        selected: {
          fieldName: "selected"
        },
        imageclicked: this.handleImageClick
      }
    },
    {
      label: "Monthly Repayment",
      fieldName: "repayment__c",
      type: "currency",
      hideDefaultActions: "true",
      cellAttributes: {
        alignment: "left",
        class: { fieldName: "selectedClass" }
      }
    },
    {
      label: "Comparison",
      fieldName: "comparisonrate__c",
      type: "percent",
      hideDefaultActions: "true",
      typeAttributes: {
        minimumFractionDigits: "2",
        maximumFractionDigits: "2"
      },
      cellAttributes: {
        alignment: "left",
        class: { fieldName: "selectedClass" }
      }
    },
    {
      label: "Actual Comparison",
      fieldName: "actualcomparisonrate__c",
      type: "percent",
      hideDefaultActions: "true",
      typeAttributes: {
        minimumFractionDigits: "2",
        maximumFractionDigits: "2"
      },
      cellAttributes: {
        alignment: "left",
        class: { fieldName: "selectedClass" }
      }
    },
    {
      label: "Variable",
      fieldName: "variablerate__c",
      type: "percent",
      hideDefaultActions: "true",
      typeAttributes: {
        minimumFractionDigits: "2",
        maximumFractionDigits: "2"
      },
      cellAttributes: {
        alignment: "left",
        class: { fieldName: "selectedClass" }
      }
    },
    {
      label: "Max Capacity",
      fieldName: "maxcapacity__c",
      type: "currency",
      hideDefaultActions: "true",
      cellAttributes: {
        alignment: "left",
        class: { fieldName: "selectedClass" }
      }
    },
    {
      label: "UMI",
      fieldName: "umi__c",
      type: "currency",
      iconname: "utility:help",
      hideDefaultActions: "true",
      cellAttributes: {
        alignment: "left",
        class: { fieldName: "selectedClass" }
      }
    },
    {
      label: "Policy Codes",
      fieldName: "PolicyCodes__c",
      type: "dotpointColumn",
      typeAttributes: {
        points: {
          fieldName: "policyCodePoints"
        }
      }
    },
        {
      label: "Order",
      fieldName: "RecommendationOrder__c",
      type: "number",
      editable: true,
      cellAttributes: {
      alignment: "center",
      class: { fieldName: "selectedClass" }
          }
      }
  
  ];

  @wire(getEligibleLoanProducts, { resiLoanId: "$recordId" })
  wiredEligibleLoanProducts(result) {
    this.cachedResult = result;
    this.isLoading = true;
    this.disasbleAllButtons();
    if (result.data) {
      this.processProducts(result.data);
      this.productLoadMessage = `${
        this.eligibleLoanProducts.length + this.ineligibleLoanProducts.length
      } Products Loaded`;
    } else if (result.error) {
      this.error = result.error;
      this.productLoadMessage = "Error Loading Products";
    }
    this.refreshDisabled = false;
    this.isLoading = false;
  }

  processProducts(products) {
    this.productsRequested = false;
    this.eligibleLoanProducts = products
      .filter((product) => product.PolicyStatus__c === 'Eligible')
      .map((product) => {
        let selected = product.SelectedProduct__c === true;
        if (selected) {
          this.originalSelectedRowHash = product.rowhash__c;
          this.selectedRow.push(product.Id);
        }
        return {
          ...product,
          ...{
            comparisonrate__c: product.comparisonrate__c / 100.0 ?? 0,
            actualcomparisonrate__c:
              product.actualcomparisonrate__c / 100.0 ?? 0,
            variablerate__c: product.variablerate__c / 100.0 ?? 0,
            logoURL: product.Lender__r?.logoRectangleUrl__c,
            productLink: "/lightning/r/" + product.Id + "/view",
            selected: selected,
            selectedClass: selected ? "slds-text-color_success" : "",
            policyCodePoints: product?.PolicyCodes__c?.split(";").map(
              (value, index) => Object.assign({}, { id: index, value: value })
            )
          }
        };
      });
    this.ineligibleLoanProducts = products
      .filter((product) => product.PolicyStatus__c === 'Ineligible')
      .map((product) => {
        return {
          ...product,
          ...{
            comparisonrate__c: product.comparisonrate__c / 100.0 ?? 0,
            actualcomparisonrate__c:
              product.actualcomparisonrate__c / 100.0 ?? 0,
            variablerate__c: product.variablerate__c / 100.0 ?? 0,
            logoURL: product.Lender__r?.logoRectangleUrl__c,
            productLink: "/lightning/r/" + product.Id + "/view",
            policyCodePoints: product?.PolicyCodes__c?.split(";").map(
              (value, index) => Object.assign({}, { id: index, value: value })
            ),
          }
        };
      });
    this.witheldLoanProducts = products
      .filter((product) => product.PolicyStatus__c === 'Withheld')
      .map((product) =>
      {
        return {
          ...product,
          ...{
            comparisonrate__c: product.comparisonrate__c / 100.0 ?? 0,
            actualcomparisonrate__c:
              product.actualcomparisonrate__c / 100.0 ?? 0,
            variablerate__c: product.variablerate__c / 100.0 ?? 0,
            logoURL: product.Lender__r?.logoRectangleUrl__c,
            productLink: "/lightning/r/" + product.Id + "/view",
            policyCodePoints: product?.PolicyCodes__c?.split(";").map(
              (value, index) => Object.assign({}, { id: index, value: value })
            ),
          }
        };
      });
      this.setColumns();
  }

  setColNonEligible;
  setColumns(){
    this.setColNonEligible = [...this.columns].filter(col => col.fieldName !== 'RecommendationOrder__c');
    this.setColEligible = [...this.columns].filter(col => col.fieldName !== 'PolicyCodes__c');

  }

  handleRowSelect(event) {
    const productRowHash = event.detail.selectedRows[0].rowhash__c;
    const lender = event.detail.selectedRows[0].Lender__c;
    const lenderLogo =
      event.detail.selectedRows[0].Lender__r.logoRectangleUrl__c;
    const lenderName = event.detail.selectedRows[0].Lender__r.Name;
    this.selectedRowHash = productRowHash;
    this.lender = lender;
    this.lenderLogo = lenderLogo;
    this.lenderName = lenderName;

    if (this.originalSelectedRowHash === productRowHash) {
      this.saveDisabled = true;
    } else {
      if (this.saveDisabled) {
        this.saveDisabled = false;
      }
    }
  }

  handleSave() {
    this.disasbleAllButtons();
    //this.updateRecommendationOrder();    
    this.launchSnoteFlow()
      .then((result) => {
        if (result === "finished") {
          const fields = {};
          fields[RLA_PRODUCT_ROWHASH.fieldApiName] = this?.selectedRowHash;
          fields[RLA_ID_FIELD.fieldApiName] = this?.recordId;
          fields[RLA_LENDER.fieldApiName] = this?.lender;
          fields[RLA_LOGOURL.fieldApiName] = this?.lenderLogo;
          fields[RLA_LENDER_NAME.fieldApiName] = this?.lenderName;
          const recordInput = { fields };
          updateRecord(recordInput)
          .then(()=>{
              this.updateRecommendationOrder(); 
            });
        } else {
          this.showToast(WARNING_TITLE, WARNING_MESSAGE, WARNING_VARIANT);
          this.enableAllButtons();
        }
      })
      .catch((error) => {
        this.showToast(ERROR_TITLE, error.message, ERROR_VARIANT);
        this.refreshDisabled = false;
      });
  }


  getDraftValues(){
      this.enableAllButtons();
      this.draftValues.push.apply(this.draftValues,this.template.querySelector('c-hla-custom-product-table').draftValues);
  }

  updateRecommendationOrder(){
    console.log(JSON.stringify(this.draftValues));
    const inputsItems = this.draftValues.slice().map(element => {
          const fields = {};
          fields[PR_ID_FIELD.fieldApiName] = element?.Id;
          fields[PR_RECOMMENDATION_ORDER.fieldApiName] = element?.RecommendationOrder__c;
          return { fields };
    });

    const promises = inputsItems.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
          refreshApex(this.cachedResult);
          this.draftValues = [];
          
        }).catch(error => {
          console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        });  
        }

  disasbleAllButtons() {
    this.refreshDisabled = true;
    this.saveDisabled = true;
  }

  enableAllButtons() {
    this.refreshDisabled = false;
    this.saveDisabled = false;
  }

  getLatestProducts() {
    this.disasbleAllButtons();
    deleteProducts({ residentialLoanAppIds: [this.recordId] })
      .then(() => {
        this.eligibleLoanProducts = undefined;
        this.showToast(
          SUCCESS_TITLE,
          SUCCESS_PRODUCTS_DELETED_MESSAGE,
          SUCCESS_VARIANT
        );
      })
      .then(
        requestNewProductsCallout({
          residentialLoanAppIds: [this.recordId]
        })
      )
      .then(() => {
        this.productsRequested = true;
        this.showRefreshButton = false;
        this.showToast(
          SUCCESS_TITLE,
          SUCCESS_PRODUCTS_REQUESTED_MESSAGE,
          SUCCESS_VARIANT
        );
      })
      .catch((error) => {
        console.error(error);
        console.log(JSON.stringify(error));
        this.productsRequested = true;
        this.productRequestMessage =
          "An error occured requesting new products: " + error.message;
        this.showToast(ERROR_TITLE, error.message, ERROR_VARIANT);
      });
  }

  async launchSnoteFlow() {
    this.inputVariables = [
      {
        name: "recordId",
        type: "String",
        value: this.recordId
      },
      {
        name: "relatedTabFromButton",
        type: "String",
        value: LENDER_ELIGIBILITY
      }
    ];

    const result = HlaSNoteFlowModal.open({
      size: "medium",
      inputVariables: this.inputVariables
    });
    return result;
  }

  connectedCallback() {
    this.registerErrorListener();
    this.subscribePRE();
  }

  registerErrorListener() {
    onError((error) => {
      console.error("Received error from server: ", JSON.stringify(error));
    });
  }

  subscribePRE() {
    if (this.subscription) {
      return;
    }
    subscribe(this.channelName, -1, (response) => {
      if (
        response.data.payload.ResidentialLoanApplication__c === this.recordId
      ) {
        this.productsRequested = false;
        this.productRequestMessage = PRODUCTS_REQUESTED;
        this.showRefreshButton = true;
        refreshApex(this.cachedResult);
      }
    }).then((response) => {
      this.subscription = response;
    });
  }

  disconnectedCallback() {
    this.unsubscribeFromMessageChannel();
  }

  unsubscribeFromMessageChannel() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  showToast(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
      })
    );
  }

  handleImageClick(event) {
    event.stopPropagation();
    const productId = event.detail.recordId;
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: productId,
        objectApiName: "LoanApplicationProduct__c",
        actionName: "view"
      }
    });
  }
}
