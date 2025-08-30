import 'package:fpdart/fpdart.dart';
import '../../domain/entities/bank_offer.dart';
import '../../domain/repositories/bank_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/market_data_parser.dart';

class BankRepositoryImpl implements BankRepository {
  final LocalDataSource _localDataSource;

  BankRepositoryImpl(this._localDataSource);

  @override
  Future<Either<String, List<BankOffer>>> getAllBankOffers() async {
    try {
      final jsonData = await _localDataSource.loadMarketData();
      final bankOffers = MarketDataParser.parseBankOffers(jsonData);
      return Right(bankOffers);
    } catch (e) {
      return Left('Failed to load bank offers: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, BankOffer>> getBankOfferById(String bankId) async {
    try {
      final allOffersResult = await getAllBankOffers();

      return allOffersResult.fold((error) => Left(error), (offers) {
        final offer = offers.firstWhere(
          (offer) => offer.bankId == bankId,
          orElse: () => throw Exception('Bank not found'),
        );
        return Right(offer);
      });
    } catch (e) {
      return Left('Bank with ID $bankId not found');
    }
  }

  @override
  Future<Either<String, List<BankOffer>>> getEligibleOffers({
    required int age,
    required double income,
    required String employmentType,
    required int creditScore,
  }) async {
    try {
      final allOffersResult = await getAllBankOffers();

      return allOffersResult.fold((error) => Left(error), (offers) {
        final eligibleOffers = offers.where((offer) {
          return offer.eligibility.isEligible(
            age: age,
            income: income,
            employmentType: employmentType,
            creditScore: creditScore,
          );
        }).toList();

        return Right(eligibleOffers);
      });
    } catch (e) {
      return Left('Failed to filter eligible offers: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<BankOffer>>> getBanksByType(BankType type) async {
    try {
      final allOffersResult = await getAllBankOffers();

      return allOffersResult.fold((error) => Left(error), (offers) {
        final filteredOffers = offers
            .where((offer) => offer.bankType == type)
            .toList();
        return Right(filteredOffers);
      });
    } catch (e) {
      return Left('Failed to filter banks by type: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<BankOffer>>> getBestRates({
    required String employmentType,
    required String creditCategory,
    required String? gender,
  }) async {
    try {
      final allOffersResult = await getAllBankOffers();

      return allOffersResult.fold((error) => Left(error), (offers) {
        // Create a list with effective rates for sorting
        final offersWithRates = offers.map((offer) {
          final rate = _getEffectiveRateForOffer(
            offer,
            employmentType,
            creditCategory,
            gender,
          );
          return _OfferWithRate(offer, rate);
        }).toList();

        // Sort by effective rate (ascending - lower rates first)
        offersWithRates.sort((a, b) => a.rate.compareTo(b.rate));

        // Return sorted bank offers
        final sortedOffers = offersWithRates.map((item) => item.offer).toList();
        return Right(sortedOffers);
      });
    } catch (e) {
      return Left('Failed to get best rates: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<BankOffer>>> searchBanks(String query) async {
    try {
      final allOffersResult = await getAllBankOffers();

      return allOffersResult.fold((error) => Left(error), (offers) {
        final searchResults = offers.where((offer) {
          final bankName = offer.bankName.toLowerCase();
          final bankId = offer.bankId.toLowerCase();
          final searchQuery = query.toLowerCase();

          return bankName.contains(searchQuery) || bankId.contains(searchQuery);
        }).toList();

        return Right(searchResults);
      });
    } catch (e) {
      return Left('Failed to search banks: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getMarketData() async {
    try {
      final jsonData = await _localDataSource.loadMarketData();
      final marketData = MarketDataParser.parseMarketTrends(jsonData);
      return Right(marketData);
    } catch (e) {
      return Left('Failed to load market data: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> updateBankData() async {
    try {
      // Clear cache to force fresh data load
      if (_localDataSource is LocalDataSourceImpl) {
        await _localDataSource.clearCache();
      }

      // Load fresh data
      await _localDataSource.loadMarketData();
      return const Right(true);
    } catch (e) {
      return Left('Failed to update bank data: ${e.toString()}');
    }
  }

  // Private helper methods
  double _getEffectiveRateForOffer(
    BankOffer offer,
    String employmentType,
    String creditCategory,
    String? gender,
  ) {
    final rates = employmentType == 'salaried'
        ? offer.interestRates.salaried
        : offer.interestRates.selfEmployed;

    CreditRates categoryRates;
    switch (creditCategory.toLowerCase()) {
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
    if (gender == 'female' && offer.interestRates.womenSpecial != null) {
      final discount = offer.interestRates.womenSpecial!.discount;
      final minRate = offer.interestRates.womenSpecial!.minRate;
      effectiveRate = (effectiveRate - discount).clamp(minRate, effectiveRate);
    }

    return effectiveRate;
  }
}

// Helper class for sorting offers with rates
class _OfferWithRate {
  final BankOffer offer;
  final double rate;

  _OfferWithRate(this.offer, this.rate);
}
