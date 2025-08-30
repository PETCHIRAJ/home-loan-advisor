import 'package:fpdart/fpdart.dart';
import '../../domain/entities/loan_parameters.dart';
import '../../domain/entities/emi_result.dart';
import '../../domain/entities/optimization_strategy.dart';
import '../../domain/repositories/calculation_repository.dart';
import '../../core/utils/calculation_utils.dart';
import '../datasources/local_data_source.dart';

class CalculationRepositoryImpl implements CalculationRepository {
  final LocalDataSource _localDataSource;

  CalculationRepositoryImpl(this._localDataSource);

  @override
  Future<Either<String, EMIResult>> calculateEMI(
    LoanParameters parameters,
  ) async {
    try {
      // Validate parameters first
      final validationResult = await validateParameters(parameters);
      final isValid = validationResult.fold((error) => false, (valid) => valid);

      if (!isValid) {
        return Left(
          validationResult.fold(
            (error) => error,
            (valid) => 'Invalid parameters',
          ),
        );
      }

      // Calculate basic EMI
      final monthlyEMI = CalculationUtils.calculateEMI(
        principal: parameters.loanAmount,
        annualRate: parameters.interestRate,
        tenureYears: parameters.tenureYears,
      );

      final totalInterest = CalculationUtils.calculateTotalInterest(
        emi: monthlyEMI,
        tenureYears: parameters.tenureYears,
        principal: parameters.loanAmount,
      );

      // Calculate tax benefits
      final taxBenefitsResult = await calculateTaxBenefits(
        principalPayment:
            parameters.loanAmount /
            parameters.tenureYears, // Approx yearly principal
        interestPayment:
            totalInterest / parameters.tenureYears, // Approx yearly interest
        taxSlabPercentage: parameters.taxSlabPercentage,
        isSelfOccupied: parameters.isSelfOccupied,
        isFirstTimeHomeBuyer: parameters.isFirstTimeHomeBuyer,
      );

      final taxBenefits = taxBenefitsResult.fold(
        (error) => const TaxBenefits(
          section80C: 0,
          section24B: 0,
          section80EEA: 0,
          totalAnnualSavings: 0,
        ),
        (benefits) => benefits,
      );

      // Calculate PMAY benefits
      final pmayResult = await calculatePMAYBenefit(
        annualIncome: parameters.annualIncome,
        loanAmount: parameters.loanAmount,
        interestRate: parameters.interestRate,
        tenureYears: parameters.tenureYears,
      );

      final pmayBenefit = pmayResult.fold(
        (error) => null,
        (benefit) => benefit.isEligible ? benefit : null,
      );

      // Generate yearly breakdown
      final breakdown = _generateLoanBreakdown(
        principal: parameters.loanAmount,
        monthlyEMI: monthlyEMI,
        annualRate: parameters.interestRate,
        tenureYears: parameters.tenureYears,
        taxSlabPercentage: parameters.taxSlabPercentage,
      );

      final result = EMIResult(
        monthlyEMI: monthlyEMI,
        totalInterest: totalInterest,
        totalAmount: parameters.loanAmount + totalInterest,
        principalAmount: parameters.loanAmount,
        taxBenefits: taxBenefits,
        pmayBenefit: pmayBenefit,
        breakdown: breakdown,
      );

      return Right(result);
    } catch (e) {
      return Left('Failed to calculate EMI: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<OptimizationStrategy>>> getOptimizationStrategies(
    LoanParameters parameters,
    EMIResult currentResult,
  ) async {
    try {
      List<OptimizationStrategy> strategies = [];

      // Prepayment strategies
      strategies.addAll(
        _generatePrepaymentStrategies(parameters, currentResult),
      );

      // Rate negotiation strategy
      strategies.add(
        _generateRateNegotiationStrategy(parameters, currentResult),
      );

      // Tax optimization strategy
      strategies.add(
        _generateTaxOptimizationStrategy(parameters, currentResult),
      );

      // Tenure optimization strategy
      strategies.add(
        _generateTenureOptimizationStrategy(parameters, currentResult),
      );

      // Sort by impact score (highest first)
      strategies.sort((a, b) => b.impactScore.compareTo(a.impactScore));

      return Right(strategies);
    } catch (e) {
      return Left(
        'Failed to generate optimization strategies: ${e.toString()}',
      );
    }
  }

  @override
  Future<Either<String, PrepaymentStrategy>> calculatePrepayment({
    required LoanParameters parameters,
    required double prepaymentAmount,
    required int afterMonths,
    required PrepaymentType type,
  }) async {
    try {
      final prepaymentResult = CalculationUtils.calculatePrepaymentBenefit(
        principal: parameters.loanAmount,
        annualRate: parameters.interestRate,
        tenureYears: parameters.tenureYears,
        prepaymentAmount: prepaymentAmount,
        prepaymentAfterMonths: afterMonths,
      );

      final result = PrepaymentResult(
        interestSaved: prepaymentResult['interestSaved'] as double,
        tenureReduced: prepaymentResult['tenureReduced'] as int,
        newEMI: prepaymentResult['newEMI'] as double,
        newTenure: prepaymentResult['newTenure'] as int,
        totalSavings: prepaymentResult['interestSaved'] as double,
      );

      final strategy = PrepaymentStrategy(
        strategyId: 'prepayment_${type.name}_$afterMonths',
        type: type,
        amount: prepaymentAmount,
        afterMonths: afterMonths,
        result: result,
      );

      return Right(strategy);
    } catch (e) {
      return Left('Failed to calculate prepayment strategy: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<RefinancingStrategy>>> calculateRefinancing({
    required LoanParameters currentLoan,
    required List<String> targetBankIds,
  }) async {
    try {
      List<RefinancingStrategy> strategies = [];

      // For demonstration, create sample refinancing strategies
      // In a real implementation, this would fetch actual bank rates
      for (final bankId in targetBankIds) {
        final newRate =
            currentLoan.interestRate - 0.5; // Assume 0.5% better rate
        if (newRate > 0) {
          final currentEMI = CalculationUtils.calculateEMI(
            principal: currentLoan.loanAmount,
            annualRate: currentLoan.interestRate,
            tenureYears: currentLoan.tenureYears,
          );

          final newEMI = CalculationUtils.calculateEMI(
            principal: currentLoan.loanAmount,
            annualRate: newRate,
            tenureYears: currentLoan.tenureYears,
          );

          final monthlySavings = currentEMI - newEMI;
          final totalSavings = monthlySavings * currentLoan.tenureYears * 12;
          final switchingCost =
              currentLoan.loanAmount * 0.005; // 0.5% switching cost
          const breakEvenMonths = 24; // Sample break-even period

          final strategy = RefinancingStrategy(
            currentBankId: 'current',
            newBankId: bankId,
            currentRate: currentLoan.interestRate,
            newRate: newRate,
            switchingCost: switchingCost,
            monthlySavings: monthlySavings,
            totalSavings: totalSavings,
            breakEvenMonths: breakEvenMonths,
            isWorthwhile: totalSavings > switchingCost,
          );

          strategies.add(strategy);
        }
      }

      return Right(strategies);
    } catch (e) {
      return Left(
        'Failed to calculate refinancing strategies: ${e.toString()}',
      );
    }
  }

  @override
  Future<Either<String, TaxBenefits>> calculateTaxBenefits({
    required double principalPayment,
    required double interestPayment,
    required int taxSlabPercentage,
    required bool isSelfOccupied,
    required bool isFirstTimeHomeBuyer,
  }) async {
    try {
      final section80C = CalculationUtils.calculateSection80CTaxBenefit(
        principalRepayment: principalPayment,
        taxSlabPercentage: taxSlabPercentage,
      );

      final section24B = CalculationUtils.calculateSection24BTaxBenefit(
        interestPayment: interestPayment,
        taxSlabPercentage: taxSlabPercentage,
        isSelfOccupied: isSelfOccupied,
      );

      // Section 80EEA is currently not active, but keeping for future use
      final section80EEA = isFirstTimeHomeBuyer ? 0.0 : 0.0;

      final totalSavings = section80C + section24B + section80EEA;

      final taxBenefits = TaxBenefits(
        section80C: section80C,
        section24B: section24B,
        section80EEA: section80EEA,
        totalAnnualSavings: totalSavings,
      );

      return Right(taxBenefits);
    } catch (e) {
      return Left('Failed to calculate tax benefits: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, PMAYBenefit>> calculatePMAYBenefit({
    required double annualIncome,
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
  }) async {
    try {
      final pmayData = CalculationUtils.calculatePMAYSubsidy(
        annualIncome: annualIncome,
        loanAmount: loanAmount,
        interestRate: interestRate,
        tenureYears: tenureYears,
      );

      final benefit = PMAYBenefit(
        category: pmayData['category'] as String,
        subsidyAmount: pmayData['subsidy'] as double,
        subsidyRate: pmayData['subsidyRate'] as double,
        maxSubsidy: pmayData['maxSubsidy'] as double,
        isEligible: pmayData['category'] != 'Not Eligible',
      );

      return Right(benefit);
    } catch (e) {
      return Left('Failed to calculate PMAY benefit: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> saveCalculation({
    required LoanParameters parameters,
    required EMIResult result,
    required String userId,
  }) async {
    try {
      final calculationData = {
        'userId': userId,
        'loanAmount': parameters.loanAmount,
        'interestRate': parameters.interestRate,
        'tenureYears': parameters.tenureYears,
        'annualIncome': parameters.annualIncome,
        'monthlyEMI': result.monthlyEMI,
        'totalInterest': result.totalInterest,
        'taxSavings': result.taxBenefits.totalAnnualSavings,
        'pmaySubsidy': result.pmayBenefit?.subsidyAmount ?? 0,
      };

      await _localDataSource.saveCalculationHistory(calculationData);
      return const Right(true);
    } catch (e) {
      return Left('Failed to save calculation: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getCalculationHistory(
    String userId,
  ) async {
    try {
      final history = await _localDataSource.getCalculationHistory();

      // Filter by user ID
      final userHistory = history
          .where((calc) => calc['userId'] == userId)
          .toList();

      return Right(userHistory);
    } catch (e) {
      return Left('Failed to load calculation history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> validateParameters(
    LoanParameters parameters,
  ) async {
    try {
      final errors = CalculationUtils.validateInputs(
        loanAmount: parameters.loanAmount,
        interestRate: parameters.interestRate,
        tenure: parameters.tenureYears,
        income: parameters.annualIncome,
      );

      if (errors.isNotEmpty) {
        final errorMessage = errors.values.join(', ');
        return Left(errorMessage);
      }

      return const Right(true);
    } catch (e) {
      return Left('Failed to validate parameters: ${e.toString()}');
    }
  }

  // Private helper methods
  LoanBreakdown _generateLoanBreakdown({
    required double principal,
    required double monthlyEMI,
    required double annualRate,
    required int tenureYears,
    required int taxSlabPercentage,
  }) {
    List<YearlyBreakdown> yearlyBreakdown = [];
    double remainingPrincipal = principal;
    final monthlyRate = annualRate / 100 / 12;

    for (int year = 1; year <= tenureYears; year++) {
      double yearlyPrincipal = 0;
      double yearlyInterest = 0;

      // Calculate for 12 months of this year
      for (int month = 1; month <= 12; month++) {
        final monthlyInterestAmount = remainingPrincipal * monthlyRate;
        final monthlyPrincipalAmount = monthlyEMI - monthlyInterestAmount;

        yearlyInterest += monthlyInterestAmount;
        yearlyPrincipal += monthlyPrincipalAmount;
        remainingPrincipal -= monthlyPrincipalAmount;

        if (remainingPrincipal <= 0) break;
      }

      // Calculate tax savings for this year
      final section80C = CalculationUtils.calculateSection80CTaxBenefit(
        principalRepayment: yearlyPrincipal,
        taxSlabPercentage: taxSlabPercentage,
      );

      final section24B = CalculationUtils.calculateSection24BTaxBenefit(
        interestPayment: yearlyInterest,
        taxSlabPercentage: taxSlabPercentage,
        isSelfOccupied: true,
      );

      yearlyBreakdown.add(
        YearlyBreakdown(
          year: year,
          principalPaid: yearlyPrincipal,
          interestPaid: yearlyInterest,
          outstandingBalance: remainingPrincipal.clamp(0, double.infinity),
          taxSavings: section80C + section24B,
        ),
      );

      if (remainingPrincipal <= 0) break;
    }

    return LoanBreakdown(
      yearlyBreakdown: yearlyBreakdown,
      totalPrincipalPaid: principal,
      totalInterestPaid: yearlyBreakdown.fold(
        0,
        (sum, item) => sum + item.interestPaid,
      ),
    );
  }

  List<OptimizationStrategy> _generatePrepaymentStrategies(
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    // Generate common prepayment strategies
    return [
      OptimizationStrategy(
        id: 'extra_emi_10',
        title: 'Pay 10% Extra EMI',
        description: 'Increase your EMI by 10% to save on interest',
        type: StrategyType.prepayment,
        difficulty: DifficultyLevel.easy,
        potentialSavings: currentResult.totalInterest * 0.15,
        impactScore: 75,
        implementationTimeWeeks: 1,
        steps: [
          'Contact your bank',
          'Increase EMI amount',
          'Set up auto-debit',
        ],
        requirements: ['Stable income', 'Emergency fund in place'],
        benefits: [
          'Reduce total interest',
          'Finish loan early',
          'Debt-free sooner',
        ],
        risks: [
          'Reduced monthly cash flow',
          'Financial strain if income drops',
        ],
      ),
      OptimizationStrategy(
        id: 'lumpsum_prepayment',
        title: 'Annual Lump Sum Prepayment',
        description: 'Use yearly bonus for loan prepayment',
        type: StrategyType.prepayment,
        difficulty: DifficultyLevel.medium,
        potentialSavings: currentResult.totalInterest * 0.20,
        impactScore: 80,
        implementationTimeWeeks: 2,
        steps: [
          'Calculate optimal amount',
          'Save throughout the year',
          'Make annual prepayment',
        ],
        requirements: ['Annual bonus/windfall', 'Tax planning'],
        benefits: [
          'Significant interest savings',
          'Flexible timing',
          'Tax benefits',
        ],
        risks: ['Opportunity cost', 'Liquidity reduction'],
      ),
    ];
  }

  OptimizationStrategy _generateRateNegotiationStrategy(
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    final potentialSavings =
        currentResult.totalInterest * 0.10; // 10% savings potential

    return OptimizationStrategy(
      id: 'rate_negotiation',
      title: 'Negotiate Interest Rate',
      description: 'Request rate reduction based on improved profile',
      type: StrategyType.rateNegotiation,
      difficulty: DifficultyLevel.medium,
      potentialSavings: potentialSavings,
      impactScore: 70,
      implementationTimeWeeks: 3,
      steps: [
        'Check current market rates',
        'Gather income proofs',
        'Schedule bank meeting',
        'Present negotiation case',
      ],
      requirements: [
        'Good payment history',
        'Improved credit score',
        'Market research',
      ],
      benefits: [
        'Lower monthly EMI',
        'Significant total savings',
        'No prepayment needed',
      ],
      risks: ['Bank may reject', 'Time investment', 'Documentation effort'],
    );
  }

  OptimizationStrategy _generateTaxOptimizationStrategy(
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    return OptimizationStrategy(
      id: 'tax_optimization',
      title: 'Maximize Tax Benefits',
      description: 'Optimize loan structure for maximum tax savings',
      type: StrategyType.taxOptimization,
      difficulty: DifficultyLevel.medium,
      potentialSavings: currentResult.taxBenefits.totalAnnualSavings * 0.2,
      impactScore: 65,
      implementationTimeWeeks: 4,
      steps: [
        'Review current tax planning',
        'Consider joint ownership',
        'Plan prepayments for tax benefits',
        'Consult tax advisor',
      ],
      requirements: ['Tax planning knowledge', 'Professional consultation'],
      benefits: [
        'Maximum tax deductions',
        'Better cash flow',
        'Tax efficiency',
      ],
      risks: ['Complex compliance', 'Professional fees'],
    );
  }

  OptimizationStrategy _generateTenureOptimizationStrategy(
    LoanParameters parameters,
    EMIResult currentResult,
  ) {
    return OptimizationStrategy(
      id: 'tenure_optimization',
      title: 'Optimize Loan Tenure',
      description: 'Balance EMI affordability with total interest',
      type: StrategyType.tenureOptimization,
      difficulty: DifficultyLevel.easy,
      potentialSavings: currentResult.totalInterest * 0.05,
      impactScore: 50,
      implementationTimeWeeks: 2,
      steps: [
        'Analyze income stability',
        'Calculate optimal tenure',
        'Request tenure modification',
        'Update EMI instructions',
      ],
      requirements: ['Stable income projection', 'Bank approval'],
      benefits: ['Optimized monthly outflow', 'Better cash flow management'],
      risks: ['Higher total interest if extended', 'Approval uncertainty'],
    );
  }
}
