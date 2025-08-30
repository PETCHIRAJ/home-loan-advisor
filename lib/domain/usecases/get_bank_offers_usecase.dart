import 'package:fpdart/fpdart.dart';
import '../entities/bank_offer.dart';
import '../entities/loan_parameters.dart';
import '../repositories/bank_repository.dart';

class GetBankOffersUseCase {
  final BankRepository _repository;

  GetBankOffersUseCase(this._repository);

  /// Get all bank offers
  Future<Either<String, List<BankOffer>>> getAllOffers() async {
    return await _repository.getAllBankOffers();
  }

  /// Get eligible offers for user profile
  Future<Either<String, List<BankOffer>>> getEligibleOffers(
    LoanParameters parameters,
  ) async {
    // Estimate credit score based on income and employment type
    final creditScore = _estimateCreditScore(
      parameters.annualIncome,
      parameters.employmentType,
    );

    return await _repository.getEligibleOffers(
      age: parameters.age,
      income: parameters.annualIncome,
      employmentType: parameters.employmentType,
      creditScore: creditScore,
    );
  }

  /// Get best rates for user profile
  Future<Either<String, List<BankOffer>>> getBestRates(
    LoanParameters parameters,
  ) async {
    final creditCategory = _getCreditCategory(
      parameters.annualIncome,
      parameters.employmentType,
    );

    return await _repository.getBestRates(
      employmentType: parameters.employmentType,
      creditCategory: creditCategory,
      gender: parameters.gender,
    );
  }

  /// Compare offers and rank them
  Future<Either<String, List<RankedBankOffer>>> getRankedOffers(
    LoanParameters parameters,
  ) async {
    final offersResult = await getEligibleOffers(parameters);

    return offersResult.fold((error) => Left(error), (offers) {
      final rankedOffers = offers.map((offer) {
        final effectiveRate = _getEffectiveRate(offer, parameters);
        final processingFee = offer.processingFee.calculateTotalFee(
          parameters.loanAmount,
        );
        final totalCost = _calculateTotalCost(
          loanAmount: parameters.loanAmount,
          interestRate: effectiveRate,
          tenureYears: parameters.tenureYears,
          processingFee: processingFee,
        );

        return RankedBankOffer(
          bankOffer: offer,
          effectiveRate: effectiveRate,
          processingFee: processingFee,
          totalCost: totalCost,
          rank: 0, // Will be set after sorting
        );
      }).toList();

      // Sort by total cost (lower is better)
      rankedOffers.sort((a, b) => a.totalCost.compareTo(b.totalCost));

      // Assign ranks
      for (int i = 0; i < rankedOffers.length; i++) {
        rankedOffers[i] = rankedOffers[i].copyWith(rank: i + 1);
      }

      return Right(rankedOffers);
    });
  }

  /// Search banks by name or type
  Future<Either<String, List<BankOffer>>> searchBanks({
    String? query,
    BankType? type,
  }) async {
    if (query != null && query.isNotEmpty) {
      return await _repository.searchBanks(query);
    } else if (type != null) {
      return await _repository.getBanksByType(type);
    } else {
      return await _repository.getAllBankOffers();
    }
  }

  /// Get market insights and trends
  Future<Either<String, Map<String, dynamic>>> getMarketInsights() async {
    return await _repository.getMarketData();
  }

  // Private helper methods
  int _estimateCreditScore(double income, String employmentType) {
    // Simple credit score estimation logic
    // In real app, this would come from credit bureau integration
    int baseScore = 650;

    if (income >= 1000000) {
      baseScore += 100; // 10L+ income
    } else if (income >= 500000) {
      baseScore += 50; // 5L+ income
    } else if (income >= 300000) {
      baseScore += 25; // 3L+ income
    }

    if (employmentType == 'salaried') {
      baseScore += 50;
    }

    return baseScore.clamp(300, 850);
  }

  String _getCreditCategory(double income, String employmentType) {
    final estimatedScore = _estimateCreditScore(income, employmentType);

    if (estimatedScore >= 750) return 'excellent';
    if (estimatedScore >= 650) return 'good';
    return 'average';
  }

  double _getEffectiveRate(BankOffer offer, LoanParameters parameters) {
    final rates = parameters.employmentType == 'salaried'
        ? offer.interestRates.salaried
        : offer.interestRates.selfEmployed;

    final creditCategory = _getCreditCategory(
      parameters.annualIncome,
      parameters.employmentType,
    );

    CreditRates categoryRates;
    switch (creditCategory) {
      case 'excellent':
        categoryRates = rates.excellentCredit;
        break;
      case 'good':
        categoryRates = rates.goodCredit;
        break;
      default:
        categoryRates = rates.averageCredit;
    }

    double effectiveRate = categoryRates.effectiveRate;

    // Apply women's discount if applicable
    if (parameters.gender == 'female' &&
        offer.interestRates.womenSpecial != null) {
      effectiveRate =
          (effectiveRate - offer.interestRates.womenSpecial!.discount).clamp(
            offer.interestRates.womenSpecial!.minRate,
            effectiveRate,
          );
    }

    return effectiveRate;
  }

  double _calculateTotalCost({
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
    required double processingFee,
  }) {
    // Simple EMI calculation for cost comparison
    final monthlyRate = interestRate / 100 / 12;
    final totalMonths = tenureYears * 12;

    if (monthlyRate == 0) {
      return loanAmount + processingFee;
    }

    final emi =
        loanAmount *
        monthlyRate *
        (1 + monthlyRate).pow(totalMonths) /
        ((1 + monthlyRate).pow(totalMonths) - 1);

    return (emi * totalMonths) + processingFee;
  }
}

/// Extension for power calculation
extension NumExtension on num {
  num pow(num exponent) {
    num result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
}

/// Represents a ranked bank offer
class RankedBankOffer {
  final BankOffer bankOffer;
  final double effectiveRate;
  final double processingFee;
  final double totalCost;
  final int rank;

  const RankedBankOffer({
    required this.bankOffer,
    required this.effectiveRate,
    required this.processingFee,
    required this.totalCost,
    required this.rank,
  });

  RankedBankOffer copyWith({
    BankOffer? bankOffer,
    double? effectiveRate,
    double? processingFee,
    double? totalCost,
    int? rank,
  }) {
    return RankedBankOffer(
      bankOffer: bankOffer ?? this.bankOffer,
      effectiveRate: effectiveRate ?? this.effectiveRate,
      processingFee: processingFee ?? this.processingFee,
      totalCost: totalCost ?? this.totalCost,
      rank: rank ?? this.rank,
    );
  }
}
