import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/calculation_repository.dart';
import '../../domain/usecases/calculate_emi_usecase.dart';
import '../../domain/usecases/get_bank_offers_usecase.dart';
import '../../domain/usecases/get_optimization_strategies_usecase.dart';
import '../../data/repositories/bank_repository_impl.dart';
import '../../data/repositories/calculation_repository_impl.dart';
import '../../data/datasources/local_data_source.dart';

// Core dependencies
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized first');
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(prefs);
});

// Repositories
final bankRepositoryProvider = Provider<BankRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return BankRepositoryImpl(localDataSource);
});

final calculationRepositoryProvider = Provider<CalculationRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return CalculationRepositoryImpl(localDataSource);
});

// Use cases
final calculateEMIUseCaseProvider = Provider<CalculateEMIUseCase>((ref) {
  final repository = ref.watch(calculationRepositoryProvider);
  return CalculateEMIUseCase(repository);
});

final getBankOffersUseCaseProvider = Provider<GetBankOffersUseCase>((ref) {
  final repository = ref.watch(bankRepositoryProvider);
  return GetBankOffersUseCase(repository);
});

final getOptimizationStrategiesUseCaseProvider =
    Provider<GetOptimizationStrategiesUseCase>((ref) {
      final repository = ref.watch(calculationRepositoryProvider);
      return GetOptimizationStrategiesUseCase(repository);
    });
