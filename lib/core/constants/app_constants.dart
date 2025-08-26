/// Application-wide constants for the Home Loan Advisor
///
/// Contains configuration values, dimensions, durations, and other
/// constants used throughout the application.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'Home Loan Advisor';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Save lakhs on your home loan with 20 proven strategies';

  // Analytics Configuration
  static const bool analyticsOptInDefault = true;

  // Loan Defaults (Smart defaults for Indian users)
  static const double defaultLoanAmount = 3000000.0;  // ₹30 lakhs
  static const double defaultInterestRate = 8.5;      // 8.5% annual
  static const int defaultTenureYears = 20;          // 20 years

  // UI Dimensions
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double inputBorderRadius = 8.0;
  
  // Padding & Margins
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Chart Configuration
  static const int maxTimelinePoints = 240;  // Performance optimization
  static const double chartAnimationDuration = 300.0; // milliseconds

  // File Export
  static const String csvFileName = 'loan_analysis';
  static const String pdfFileName = 'home_loan_report';

  // Validation Limits
  static const double minLoanAmount = 100000.0;      // ₹1 lakh minimum
  static const double maxLoanAmount = 100000000.0;   // ₹10 crore maximum
  static const double minInterestRate = 1.0;         // 1% minimum
  static const double maxInterestRate = 30.0;        // 30% maximum
  static const int minTenureYears = 1;               // 1 year minimum
  static const int maxTenureYears = 50;              // 50 years maximum

  // Navigation
  static const Duration navigationAnimationDuration = Duration(milliseconds: 300);
  
  // Performance
  static const Duration calculationDebounce = Duration(milliseconds: 500);
}