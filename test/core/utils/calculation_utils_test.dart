import 'package:flutter_test/flutter_test.dart';
import 'package:home_loan_advisor/core/utils/calculation_utils.dart';

void main() {
  group('CalculationUtils Tests', () {
    test('EMI calculation should be correct', () {
      // Test standard EMI calculation
      final emi = CalculationUtils.calculateEMI(
        principal: 3500000, // 35 lakhs
        annualRate: 8.65,
        tenureYears: 20,
      );

      // Expected EMI: approximately ₹30,456
      expect(
        emi,
        closeTo(30456, 300),
      ); // Allow ±300 variance for calculation precision
    });

    test('Total interest calculation should be correct', () {
      final emi = 30456.0;
      final totalInterest = CalculationUtils.calculateTotalInterest(
        emi: emi,
        tenureYears: 20,
        principal: 3500000,
      );

      // Expected total interest: approx ₹38,09,440
      expect(totalInterest, closeTo(3809440, 10000)); // Allow ±10k variance
    });

    test('Section 80C tax benefit calculation should be correct', () {
      final taxBenefit = CalculationUtils.calculateSection80CTaxBenefit(
        principalRepayment: 200000, // 2 lakhs
        taxSlabPercentage: 30,
      );

      // Expected benefit: 150000 * 30% = 45000
      expect(taxBenefit, equals(45000));
    });

    test('Section 80C tax benefit should be capped at 1.5L', () {
      final taxBenefit = CalculationUtils.calculateSection80CTaxBenefit(
        principalRepayment: 300000, // 3 lakhs (more than limit)
        taxSlabPercentage: 30,
      );

      // Should be capped at 150000 * 30% = 45000
      expect(taxBenefit, equals(45000));
    });

    test('Section 24B tax benefit calculation should be correct', () {
      final taxBenefit = CalculationUtils.calculateSection24BTaxBenefit(
        interestPayment: 150000,
        taxSlabPercentage: 30,
        isSelfOccupied: true,
      );

      // Expected benefit: 150000 * 30% = 45000
      expect(taxBenefit, equals(45000));
    });

    test('Section 24B tax benefit should be capped for self-occupied', () {
      final taxBenefit = CalculationUtils.calculateSection24BTaxBenefit(
        interestPayment: 300000, // More than 2L limit
        taxSlabPercentage: 30,
        isSelfOccupied: true,
      );

      // Should be capped at 200000 * 30% = 60000
      expect(taxBenefit, equals(60000));
    });

    test('PMAY eligibility should be correctly determined', () {
      final pmayResult = CalculationUtils.calculatePMAYSubsidy(
        annualIncome: 1200000, // 12 lakhs - MIG-I category
        loanAmount: 3500000,
        interestRate: 8.65,
        tenureYears: 20,
      );

      expect(pmayResult['category'], equals('MIG-I'));
      expect(pmayResult['subsidyRate'], equals(4.0));
      expect(pmayResult['maxSubsidy'], equals(235000.0));
      expect(pmayResult['subsidy'], greaterThan(0));
    });

    test('Input validation should work correctly', () {
      final errors = CalculationUtils.validateInputs(
        loanAmount: 50000, // Below minimum
        interestRate: 20.0, // Above maximum
        tenure: 3, // Below minimum
        income: -1000, // Invalid
      );

      expect(errors.length, equals(4));
      expect(errors.containsKey('loanAmount'), isTrue);
      expect(errors.containsKey('interestRate'), isTrue);
      expect(errors.containsKey('tenure'), isTrue);
      expect(errors.containsKey('income'), isTrue);
    });

    test('Valid inputs should pass validation', () {
      final errors = CalculationUtils.validateInputs(
        loanAmount: 3500000,
        interestRate: 8.65,
        tenure: 20,
        income: 1200000,
      );

      expect(errors.isEmpty, isTrue);
    });
  });
}
