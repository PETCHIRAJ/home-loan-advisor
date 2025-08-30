import 'dart:convert';
import '../../domain/entities/bank_offer.dart';
import '../models/simple_bank_model.dart';

class MarketDataParser {
  /// Parse the market data JSON and extract bank offers
  static List<BankOffer> parseBankOffers(String jsonString) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> banksData = data['banks'] as List<dynamic>;

      return banksData.map((bankData) {
        return _parseBankOffer(bankData as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to parse bank offers: $e');
    }
  }

  /// Parse government schemes data
  static Map<String, dynamic> parseGovernmentSchemes(String jsonString) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return data['government_schemes'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to parse government schemes: $e');
    }
  }

  /// Parse tax benefits data
  static Map<String, dynamic> parseTaxBenefits(String jsonString) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return data['tax_benefits'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to parse tax benefits: $e');
    }
  }

  /// Parse market trends data
  static Map<String, dynamic> parseMarketTrends(String jsonString) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return {
        'market_rates': data['market_rates'],
        'market_trends': data['market_trends'],
        'prepayment_strategies': data['prepayment_strategies'],
      };
    } catch (e) {
      throw Exception('Failed to parse market trends: $e');
    }
  }

  // Private helper methods
  static BankOffer _parseBankOffer(Map<String, dynamic> bankData) {
    return SimpleBankModel.fromMap(bankData);
  }
}
