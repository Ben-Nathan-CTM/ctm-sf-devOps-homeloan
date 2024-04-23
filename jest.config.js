const { jestConfig } = require("@salesforce/sfdx-lwc-jest/config");

module.exports = {
  ...jestConfig,
  modulePathIgnorePatterns: ["<rootDir>/.localdevserver"],
  moduleNameMapper: {
    // Jest mocks
    "^lightning/modal*":
      "<rootDir>/ctm-sf-homeloan-app/test/jest-mocks/lightning/modal"
  }
};
