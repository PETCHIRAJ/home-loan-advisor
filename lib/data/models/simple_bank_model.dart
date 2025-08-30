// Simple data model without code generation for now
// This will be replaced with proper JSON serialization later

import '../../domain/entities/bank_offer.dart';

class SimpleBankModel {
  static BankOffer fromMap(Map<String, dynamic> json) {
    return BankOffer(
      bankId: json['bank_id'] as String,
      bankName: json['bank_name'] as String,
      bankType: _parseBankType(json['bank_type'] as String),
      marketShare: (json['market_share'] as num).toDouble(),
      interestRates: _parseInterestRates(
        json['interest_rates'] as Map<String, dynamic>,
      ),
      processingFee: _parseProcessingFee(
        json['processing_fees'] as Map<String, dynamic>,
      ),
      eligibility: _parseEligibility(
        json['eligibility'] as Map<String, dynamic>,
      ),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  static BankType _parseBankType(String type) {
    switch (type.toLowerCase()) {
      case 'public':
        return BankType.public;
      case 'private':
        return BankType.private;
      case 'nbfc':
        return BankType.nbfc;
      default:
        return BankType.private;
    }
  }

  static InterestRates _parseInterestRates(Map<String, dynamic> data) {
    return InterestRates(
      salaried: _parseCategoryRates(data['salaried'] as Map<String, dynamic>),
      selfEmployed: _parseCategoryRates(
        data['self_employed'] as Map<String, dynamic>,
      ),
      womenSpecial: data['women_special'] != null
          ? _parseWomenSpecialRates(
              data['women_special'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static CategoryRates _parseCategoryRates(Map<String, dynamic> data) {
    return CategoryRates(
      excellentCredit: _parseCreditRates(
        data['excellent_credit'] as Map<String, dynamic>,
      ),
      goodCredit: _parseCreditRates(
        data['good_credit'] as Map<String, dynamic>,
      ),
      averageCredit: _parseCreditRates(
        data['average_credit'] as Map<String, dynamic>,
      ),
    );
  }

  static CreditRates _parseCreditRates(Map<String, dynamic> data) {
    return CreditRates(
      minRate: (data['min_rate'] as num).toDouble(),
      maxRate: (data['max_rate'] as num).toDouble(),
      effectiveRate: (data['effective_rate'] as num).toDouble(),
    );
  }

  static WomenSpecialRates _parseWomenSpecialRates(Map<String, dynamic> data) {
    return WomenSpecialRates(
      discount: (data['discount'] as num).toDouble(),
      minRate: (data['min_rate'] as num).toDouble(),
    );
  }

  static ProcessingFee _parseProcessingFee(Map<String, dynamic> data) {
    return ProcessingFee(
      percentage: (data['percentage'] as num).toDouble(),
      minimum: (data['minimum'] as num).toDouble(),
      maximum: (data['maximum'] as num).toDouble(),
      gstApplicable: data['gst_applicable'] as bool,
      gstRate: (data['gst_rate'] as num).toDouble(),
    );
  }

  static Eligibility _parseEligibility(Map<String, dynamic> data) {
    return Eligibility(
      minAge: data['min_age'] as int,
      maxAge: data['max_age'] as int,
      minIncomeSalaried: (data['min_income_salaried'] as num).toDouble(),
      minIncomeSelfEmployed: (data['min_income_self_employed'] as num)
          .toDouble(),
      creditScoreMinimum: data['credit_score_minimum'] as int,
    );
  }
}
