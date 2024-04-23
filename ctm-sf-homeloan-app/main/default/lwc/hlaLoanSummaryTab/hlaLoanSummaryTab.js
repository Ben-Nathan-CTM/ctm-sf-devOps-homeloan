import { LightningElement, api, wire } from "lwc";
import { formattedRecord } from "c/utils";
import { getRelatedListRecordsBatch } from "lightning/uiRelatedListApi";
import {
  getRecord,
  getFieldValue,
  getFieldDisplayValue
} from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";

import RLA_FIRST_HOME_BUYER from "@salesforce/schema/ResidentialLoanApplication__c.FirstHomeBuyers__c";
import RLA_LOAN_PURPOSE from "@salesforce/schema/ResidentialLoanApplication__c.LoanPurpose__c";
import RLA_REFERENCE_NUMBER from "@salesforce/schema/ResidentialLoanApplication__c.ReferenceNumber__c";
import RLA_EXPECTED_SETTLEMENT_DATE from "@salesforce/schema/ResidentialLoanApplication__c.ExpectedSettlementDate__c";
import RLA_AUCTION_DATE from "@salesforce/schema/ResidentialLoanApplication__c.AuctionDate__c";
import RLA_REASON_FOR_REFINANCE from "@salesforce/schema/ResidentialLoanApplication__c.Reasonsforrefinancing__c";
import RLA_REASON_FOR_REFINANCE_SPECIFIC from "@salesforce/schema/ResidentialLoanApplication__c.SpecificRefinanceGoal__c";
import RLA_LENDER_NAME from "@salesforce/schema/ResidentialLoanApplication__c.LenderName__c";
import RLA_LOGO_URL from "@salesforce/schema/ResidentialLoanApplication__c.LogoURL__c";

const LOAN_API = "Loan__c";
const LOAN_APPLICANT_API = "LoanApplicant__c";
const LOAN_APPLICATION_ASSET_API = "LoanApplicationAsset__c";
const LOAN_APPLICATION_PRODUCT_API = "LoanApplicationProduct__c";

const LOAN_EQUITY_RELEASE_API = "LoanEquityRelease__c";
const LOAN_SECURITY_API = "LoanSecurity__c";
const LOAN_CONTRIBUTIONS_API = "LoanContribution__c";
const LOAN_COSTS_API = "LoanCost__c";

/* RLApplication Lists */
const LOAN_RELATEDLIST_API = "Loans__r";
const LOAN_APPLICANT_RELATEDLIST_API = "Loan_Applicants__r";
const LOAN_APPLICATION_ASSET_RELATEDLIST_API = "Loan_Application_Assets__r";
const LOAN_APPLICATION_PRODUCT_RELATEDLIST_API = "Loan_Application_Products__r";

/* Loan Lists */
const LOAN_EQUITY_RELEASE_RELATEDLIST_API = "Loan_Equity_Release__r";
const LOAN_SECURITY_RELATEDLIST_API = "Loan_Security__r";
const LOAN_CONTRIBUTIONS_RELATEDLIST_API = "Loan_Contributions__r";
const LOAN_COSTS_RELATEDLIST_API = "Loan_Costs__r";

const NO_RECORDS_MESSAGE = "No records To Display";

export default class HlaLoanSummaryTab extends NavigationMixin(
  LightningElement
) {
  @api recordId;

  isLoading;

  cachedApplicationRelatedLists;
  cachedLoanRelatedLists;
  relatedListRecords;

  loan;
  loanSecurity;
  selectedProduct;

  loanRecords;
  loanApplicantRecords;
  loanApplicationAssetRecords;
  loanApplicationProductRecords;
  loanEquityReleaseRecords;
  loanSecurityRecords;
  loanContributionRecords;
  loanCostRecords;

  hasLoanAndSecurity;
  hasApplicant;
  hasApplicationAsset;
  hasApplicationProduct;
  hasEquityRelease;
  hasSecurity;
  hasContributions;
  hasLoanCosts;
  hasFundingDetails;
  hasSelectedProduct;

  costs = [];
  contributions = [];
  totalCosts = 0;
  totalContributions = 0;
  netSurplus = 0;

  NO_RECORDS_MESSAGE = NO_RECORDS_MESSAGE;

  applicationRelatedListAPIs = new Map([
    [LOAN_API, new Array()],
    [LOAN_APPLICANT_API, new Array()],
    [LOAN_APPLICATION_ASSET_API, new Array()],
    [LOAN_APPLICATION_PRODUCT_API, new Array()]
  ]);

  loanRelatedListAPIs = new Map([
    [LOAN_EQUITY_RELEASE_API, new Array()],
    [LOAN_SECURITY_API, new Array()],
    [LOAN_CONTRIBUTIONS_API, new Array()],
    [LOAN_COSTS_API, new Array()]
  ]);

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [
      RLA_FIRST_HOME_BUYER,
      RLA_LOAN_PURPOSE,
      RLA_REFERENCE_NUMBER,
      RLA_EXPECTED_SETTLEMENT_DATE,
      RLA_AUCTION_DATE,
      RLA_REASON_FOR_REFINANCE,
      RLA_REASON_FOR_REFINANCE_SPECIFIC,
      RLA_LENDER_NAME,
      RLA_LOGO_URL
    ]
  })
  RLApplication;

  get loanPurpose() {
    return getFieldValue(this.RLApplication.data, RLA_LOAN_PURPOSE);
  }
  get referenceNumber() {
    return getFieldValue(this.RLApplication.data, RLA_REFERENCE_NUMBER);
  }
  get expectedSettlementDate() {
    return getFieldValue(this.RLApplication.data, RLA_EXPECTED_SETTLEMENT_DATE);
  }
  get firsthomeBuyer() {
    return getFieldValue(this.RLApplication.data, RLA_FIRST_HOME_BUYER);
  }
  get auctionDate() {
    return getFieldValue(this.RLApplication.data, RLA_AUCTION_DATE);
  }

  get LogoURL() {
    return getFieldValue(this.RLApplication.data, RLA_LOGO_URL);
  }

  get reasonForRefinance() {
    return getFieldDisplayValue(
      this.RLApplication.data,
      RLA_REASON_FOR_REFINANCE
    );
  }
  get reasonForRefinanceSpecific() {
    return getFieldDisplayValue(
      this.RLApplication.data,
      RLA_REASON_FOR_REFINANCE_SPECIFIC
    );
  }

  get lenderName() {
    return getFieldValue(this.RLApplication.data, RLA_LENDER_NAME);
  }

  @wire(getRelatedListRecordsBatch, {
    parentRecordId: "$recordId",
    relatedListParameters: [
      {
        relatedListId: LOAN_RELATEDLIST_API,
        fields: [
          "Loan__c.estimatedLoanAmount__c",
          "Loan__c.loanAmount__c",
          "Loan__c.loanPurpose__c",
          "Loan__c.LoanTerminYears__c",
          "Loan__c.RepaymentType__c",
          "Loan__c.RepaymentFrequency__c",
          "Loan__c.Offset__c",
          "Loan__c.Redraw__c",
          "Loan__c.loanType__c",
          "Loan__c.lvrPreLmi__c",
          "Loan__c.lvr__c",
          "Loan__c.totalContributions__c",
          "Loan__c.SourceofContribution__c"
        ]
      },
      {
        relatedListId: LOAN_APPLICANT_RELATEDLIST_API,
        fields: ["LoanApplicant__c.PostSettlementAddress__c"]
      },
      {
        relatedListId: LOAN_APPLICATION_ASSET_RELATEDLIST_API,
        fields: ["LoanApplicationAsset__c.Ownership__c"]
      },
      {
        relatedListId: LOAN_APPLICATION_PRODUCT_RELATEDLIST_API,
        fields: [
          "LoanApplicationProduct__c.ProductName__c",
          "LoanApplicationProduct__c.AssessmentRate__c",
          "LoanApplicationProduct__c.repayment__c",
          "LoanApplicationProduct__c.repaymentoption__c",
          "LoanApplicationProduct__c.Lender__r.Name",
          "LoanApplicationProduct__c.usedrate__c"
        ],
        where: "{ SelectedProduct__c: { eq: true }}"
      }
    ]
  })
  ApplicationRelatedLists(result) {
    this.cachedResult = result;
    if (result.data) {
      this.loading(true);
      this.processRelatedLists(result.data.results);
      this.setApplicationFields();
      //this.calculateTotals();
      console.dir(this.relatedListRecords);
      this.error = undefined;
    } else if (result.error) {
      console.log(JSON.stringify(result.error));
      this.error = result.error;
      this.relatedListRecords = undefined;
    }
    this.loading(false);
  }

  @wire(getRelatedListRecordsBatch, {
    parentRecordId: "$loan.id",
    relatedListParameters: [
      {
        relatedListId: LOAN_EQUITY_RELEASE_RELATEDLIST_API,
        fields: ["LoanEquityRelease__c.Amount__c"]
      },
      {
        relatedListId: LOAN_SECURITY_RELATEDLIST_API,
        fields: [
          "LoanSecurity__c.SecurityResidentialPropertyType__c",
          "LoanSecurity__c.PropertyDetails__c",
          "LoanSecurity__c.PropertyAddress__Street__s",
          "LoanSecurity__c.PropertyAddress__City__s",
          "LoanSecurity__c.PropertyAddress__PostalCode__s",
          "LoanSecurity__c.PropertyAddress__StateCode__s",
          "LoanSecurity__c.PropertyAddress__CountryCode__s",
          "LoanSecurity__c.EstimatedValue__c"
        ]
      },
      {
        relatedListId: LOAN_CONTRIBUTIONS_RELATEDLIST_API,
        fields: [
          "LoanContribution__c.Type__c",
          "LoanContribution__c.Name",
          "LoanContribution__c.amount__c"
        ]
      },
      {
        relatedListId: LOAN_COSTS_RELATEDLIST_API,
        fields: [
          "LoanCost__c.Type__c",
          "LoanCost__c.Amount__c",
          "LoanCost__c.Name"
        ]
      }
    ]
  })
  LoanRelatedLists(result) {
    this.cachedResult = result;
    console.log("LoanRelatedLists = " + JSON.stringify(result));
    if (result.data) {
      this.loading(true);
      this.processRelatedLists(result.data.results);
      this.setLoanFields();
      this.processLoanCosts(this.loanCostRecords);
      this.processLoanContributions(this.loanContributionRecords);
      this.error = undefined;
    } else if (result.error) {
      console.log(JSON.stringify(result.error));
      this.error = result.error;
      this.relatedListRecords = undefined;
    }
    this.loading(false);
  }

  loading(isLoading) {
    this.isLoading = isLoading;
  }

  processRelatedLists(relatedLists) {
    for (let relatedList of relatedLists) {
      if (relatedList.statusCode !== 200) {
        continue;
      }
      const records = relatedList.result.records;
      for (let record of records) {
        console.log("record " + JSON.stringify(record));
        let recordApiName = record.apiName;
        let fRecord = new formattedRecord(record.id);
        const fields = record.fields;
        const ownProps = Object.getOwnPropertyNames(fields);
        for (let field in fields) {
          if (ownProps.includes(field)) {
            let currentValue = fields[field].value;
            let displayValue = fields[field].displayValue;
            fRecord[field] = displayValue
              ? displayValue
              : currentValue
              ? currentValue
              : "not provided";
          }
        }
        this.relatedListRecords[recordApiName].push(fRecord);
      }
    }
  }

  setApplicationFields() {
    this.loanRecords = this.relatedListRecords[LOAN_API];
    this.loanApplicantRecords = this.relatedListRecords[LOAN_APPLICANT_API];
    this.loanApplicationAssetRecords =
      this.relatedListRecords[LOAN_APPLICATION_ASSET_API];
    this.loanApplicationProductRecords =
      this.relatedListRecords[LOAN_APPLICATION_PRODUCT_API];

    this.loan = this.loanRecords ? this.loanRecords[0] : null;
    this.selectedProduct = this.loanApplicationProductRecords
      ? this.loanApplicationProductRecords[0]
      : null;

    this.hasLoan = !!this.loan;
    this.productURL = "/" + this.selectedProduct?.id;
    this.hasSelectedProduct = !!this.selectedProduct;

    this.hasApplicant = this.loanApplicantRecords.length > 0;
    this.hasApplicationAsset = this.loanApplicationAssetRecords.length > 0;
    this.hasApplicationProduct = this.loanApplicationProductRecords.length > 0;
  }

  setLoanFields() {
    this.loanEquityReleaseRecords =
      this.relatedListRecords[LOAN_EQUITY_RELEASE_API];
    this.loanSecurityRecords = this.relatedListRecords[LOAN_SECURITY_API];
    this.loanContributionRecords =
      this.relatedListRecords[LOAN_CONTRIBUTIONS_API];
    this.loanCostRecords = this.relatedListRecords[LOAN_COSTS_API];
    this.loanSecurity = this.loanSecurityRecords
      ? this.loanSecurityRecords[0]
      : null;
    this.hasLoanAndSecurity = !!this.loanSecurity;

    this.hasEquityRelease = this.loanEquityReleaseRecords.length > 0;
    this.hasSecurity = this.loanSecurityRecords.length > 0;
    this.hasContributions = this.loanContributionRecords.length > 0;
    this.hasLoanCosts = this.loanCostRecords.length > 0;
    this.hasFundingDetails = !!this.hasLoanCosts || !!this.hasContributions;
  }

  processLoanCosts(loanCosts) {
    this.costs = loanCosts.map((cost) => {
      let amount = parseFloat(cost.Amount__c.replace(/\$/g, ""));
      this.totalCosts += amount;
      this.netSurplus -= amount;
      return Object.assign(
        {},
        { Id: cost.id, Type: cost.Type__c, Value: cost.Amount__c }
      );
    });
    this.totalCosts = this.totalCosts.toFixed(2);
  }

  processLoanContributions(loanContributions) {
    this.contributions = loanContributions.map((contribution) => {
      let amount = parseFloat(contribution.amount__c.replace(/\$/g, ""));
      this.totalContributions += amount;
      this.netSurplus += amount;
      return Object.assign(
        {},
        {
          Id: contribution.id,
          Type: contribution.Type__c,
          Value: contribution.amount__c
        }
      );
    });
    this.totalContributions = this.totalContributions.toFixed(2);
  }

  handleProductNameClick(event) {
    event.preventDefault();
    //const productId = event.detail.recordId;
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.selectedProduct.id,
        objectApiName: "LoanApplicationProduct__c",
        actionName: "view"
      }
    });
  }

  connectedCallback() {
    this.relatedListRecords = Object.assign(
      {},
      Object.fromEntries(this.applicationRelatedListAPIs),
      Object.fromEntries(this.loanRelatedListAPIs)
    );
  }
}
