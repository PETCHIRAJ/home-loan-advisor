class AppConstants {
  static const String appName = 'Home Loan Advisor';
  static const String appDescription =
      "India's only tax-aware EMI calculator with PMAY benefits";

  // Tax Limits (FY 2024-25)
  static const double section80CLimit = 150000;
  static const double section24BLimitSelfOccupied = 200000;
  static const double section80EEALimit = 150000;

  // EMI Calculation Constants
  static const int minTenureYears = 5;
  static const int maxTenureYears = 30;
  static const double minLoanAmount = 100000;
  static const double maxLoanAmount = 50000000; // 5 Crore
  static const double minInterestRate = 6.0;
  static const double maxInterestRate = 15.0;

  // PMAY Income Limits (Annual)
  static const double pmayEWSLIGLimit = 600000;
  static const double pmayMIG1Limit = 1200000;
  static const double pmayMIG2Limit = 1800000;

  // Default Values
  static const double defaultLoanAmount = 3500000; // 35 Lakhs
  static const double defaultInterestRate = 8.65;
  static const int defaultTenureYears = 20;
  static const double defaultAnnualIncome = 1200000; // 12 Lakhs
  static const int defaultTaxSlab = 20; // 20% tax bracket

  // Currency formatting
  static const String currencySymbol = '₹';
  static const String locale = 'hi_IN';
}

class ValidationConstants {
  static const String emptyFieldError = 'This field cannot be empty';
  static const String invalidAmountError = 'Please enter a valid amount';
  static const String invalidRateError =
      'Interest rate should be between ${AppConstants.minInterestRate}% and ${AppConstants.maxInterestRate}%';
  static const String invalidTenureError =
      'Loan tenure should be between ${AppConstants.minTenureYears} and ${AppConstants.maxTenureYears} years';
  static const String invalidIncomeError = 'Please enter a valid annual income';
}
