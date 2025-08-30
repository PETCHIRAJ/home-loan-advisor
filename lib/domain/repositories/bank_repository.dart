import 'package:fpdart/fpdart.dart';
import '../entities/bank_offer.dart';

abstract class BankRepository {
  /// Get all available bank offers
  Future<Either<String, List<BankOffer>>> getAllBankOffers();

  /// Get bank offer by ID
  Future<Either<String, BankOffer>> getBankOfferById(String bankId);

  /// Get eligible bank offers based on user profile
  Future<Either<String, List<BankOffer>>> getEligibleOffers({
    required int age,
    required double income,
    required String employmentType,
    required int creditScore,
  });

  /// Get banks by type (public, private, nbfc)
  Future<Either<String, List<BankOffer>>> getBanksByType(BankType type);

  /// Get best interest rates for user profile
  Future<Either<String, List<BankOffer>>> getBestRates({
    required String employmentType,
    required String creditCategory, // excellent, good, average
    required String? gender,
  });

  /// Search banks by name
  Future<Either<String, List<BankOffer>>> searchBanks(String query);

  /// Get market data (rates, trends, etc.)
  Future<Either<String, Map<String, dynamic>>> getMarketData();

  /// Update bank data (for admin/data refresh)
  Future<Either<String, bool>> updateBankData();
}
