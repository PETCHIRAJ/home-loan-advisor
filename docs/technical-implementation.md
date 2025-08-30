# Home Loan Advisor - Technical Implementation Document

> Complete production-ready Flutter app architecture for Indian home loan borrowers

**Purpose**: Technical specification for implementing a comprehensive 2-screen Flutter app with EMI calculator and money-saving strategies  
**Target Audience**: Flutter developers, technical architects, product managers  
**Last Updated**: 2024-12-30  
**Version**: 1.0  

---

## 1. Architecture Overview

### 1.1 Clean Architecture with DDD Principles

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │ Calculator      │  │ Strategies      │  │ Shared       │ │
│  │ Screen/Widgets  │  │ Screen/Widgets  │  │ UI Components│ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                   Application Layer                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │ Riverpod        │  │ Use Cases       │  │ State        │ │
│  │ Providers       │  │ Services        │  │ Management   │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │ Business Logic  │  │ Entities        │  │ Repository   │ │
│  │ (Calculations)  │  │ Models          │  │ Interfaces   │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │ Remote Data     │  │ Local Data      │  │ Repository   │ │
│  │ Source (CDN)    │  │ Source (Cache)  │  │ Impl         │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Key Architectural Decisions

- **State Management**: Riverpod 2.0 for reactive, testable state
- **Navigation**: GoRouter for declarative routing with deep linking
- **Dependency Injection**: Riverpod's built-in DI container
- **Error Handling**: Result pattern with Either<Failure, Success>
- **Offline Strategy**: Cache-first with background sync
- **Testing**: Comprehensive unit, widget, and integration tests

---

## 2. Project Structure

```
lib/
├── app/                              # Application configuration
│   ├── app.dart                      # Main MaterialApp setup
│   ├── router/                       # Navigation configuration
│   │   ├── app_router.dart          # GoRouter setup
│   │   └── route_paths.dart         # Route constants
│   └── theme/                        # Application theming
│       ├── app_theme.dart           # Material 3 theme
│       ├── color_scheme.dart        # Colors for financial context
│       └── typography.dart          # Indian-adapted typography
│
├── core/                             # Cross-cutting concerns
│   ├── constants/                    # App-wide constants
│   │   ├── app_constants.dart       # General constants
│   │   ├── api_constants.dart       # CDN URLs, endpoints
│   │   └── calculation_constants.dart # Mathematical constants
│   ├── extensions/                   # Dart extensions
│   │   ├── context_extensions.dart  # BuildContext extensions
│   │   ├── number_extensions.dart   # Indian number formatting
│   │   └── date_extensions.dart     # Date utilities
│   ├── utils/                        # Helper functions
│   │   ├── indian_formatter.dart    # ₹, lakhs, crores formatting
│   │   ├── validation_utils.dart    # Input validation
│   │   └── calculation_utils.dart   # Mathematical helpers
│   ├── errors/                       # Error handling
│   │   ├── failures.dart           # Failure types
│   │   ├── exceptions.dart         # Exception definitions
│   │   └── error_handler.dart      # Global error handling
│   └── network/                      # HTTP client setup
│       ├── dio_client.dart         # Configured Dio instance
│       ├── interceptors.dart       # Request/response interceptors
│       └── network_info.dart       # Connectivity checking
│
├── features/                         # Feature modules
│   ├── calculator/                   # EMI Calculator feature
│   │   ├── data/                    # Data layer
│   │   │   ├── datasources/
│   │   │   │   ├── market_data_remote_source.dart
│   │   │   │   └── calculator_local_source.dart
│   │   │   ├── models/
│   │   │   │   ├── bank_model.dart  # Bank data from JSON
│   │   │   │   ├── loan_model.dart  # Loan calculation data
│   │   │   │   └── tax_benefit_model.dart
│   │   │   └── repositories/
│   │   │       └── calculator_repository_impl.dart
│   │   ├── domain/                  # Business logic
│   │   │   ├── entities/
│   │   │   │   ├── loan_entity.dart # Core business entities
│   │   │   │   ├── bank_entity.dart
│   │   │   │   └── calculation_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── calculator_repository.dart # Interface
│   │   │   └── usecases/
│   │   │       ├── calculate_emi_usecase.dart
│   │   │       ├── calculate_tax_benefits.dart
│   │   │       ├── calculate_prepayment.dart
│   │   │       └── compare_scenarios.dart
│   │   └── presentation/            # UI layer
│   │       ├── screens/
│   │       │   ├── calculator_screen.dart
│   │       │   └── loan_details_screen.dart
│   │       ├── widgets/
│   │       │   ├── hybrid_number_input.dart # Slider + TextField
│   │       │   ├── emi_result_card.dart
│   │       │   ├── tax_benefit_card.dart
│   │       │   ├── bank_comparison_widget.dart
│   │       │   └── chart_widgets/
│   │       │       ├── pie_chart_widget.dart
│   │       │       ├── line_chart_widget.dart
│   │       │       └── amortization_chart.dart
│   │       └── providers/           # Riverpod providers
│   │           ├── calculator_providers.dart
│   │           ├── market_data_providers.dart
│   │           └── loan_state_provider.dart
│   │
│   └── strategies/                   # Money-saving strategies
│       ├── data/
│       │   ├── datasources/
│       │   │   └── strategies_local_source.dart
│       │   ├── models/
│       │   │   ├── strategy_model.dart
│       │   │   └── strategy_result_model.dart
│       │   └── repositories/
│       │       └── strategies_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── strategy_entity.dart
│       │   │   └── strategy_combination.dart
│       │   ├── repositories/
│       │   │   └── strategies_repository.dart
│       │   └── usecases/
│       │       ├── get_strategies_usecase.dart
│       │       ├── calculate_strategy_impact.dart
│       │       └── get_strategy_combinations.dart
│       └── presentation/
│           ├── screens/
│           │   ├── strategies_screen.dart
│           │   └── strategy_detail_screen.dart
│           ├── widgets/
│           │   ├── strategy_card.dart
│           │   ├── strategy_impact_chart.dart
│           │   ├── implementation_guide.dart
│           │   └── combination_widget.dart
│           └── providers/
│               ├── strategies_providers.dart
│               └── user_preferences_provider.dart
│
└── shared/                          # Shared components
    ├── widgets/                     # Reusable widgets
    │   ├── loading_indicator.dart
    │   ├── error_widget.dart
    │   ├── indian_currency_input.dart
    │   ├── percentage_input.dart
    │   └── animated_counter.dart
    ├── models/                      # Shared data models
    │   ├── result.dart             # Result<Success, Failure> type
    │   └── base_model.dart         # Base model class
    └── services/                    # Shared services
        ├── storage_service.dart    # SharedPreferences wrapper
        ├── analytics_service.dart  # Firebase Analytics
        └── crash_service.dart      # Firebase Crashlytics
```

---

## 3. Data Layer Implementation

### 3.1 Repository Pattern with Offline-First Strategy

```dart
abstract class MarketDataRepository {
  Future<Either<Failure, MarketData>> getMarketData();
  Future<Either<Failure, void>> refreshMarketData();
  Stream<MarketData> watchMarketData();
}

class MarketDataRepositoryImpl implements MarketDataRepository {
  final MarketDataRemoteSource _remoteSource;
  final MarketDataLocalSource _localSource;
  final NetworkInfo _networkInfo;
  
  MarketDataRepositoryImpl(
    this._remoteSource,
    this._localSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, MarketData>> getMarketData() async {
    try {
      // Always return cached data first for instant UI
      final cachedData = await _localSource.getCachedMarketData();
      if (cachedData != null && !_isDataStale(cachedData)) {
        // Background refresh if connected
        if (await _networkInfo.isConnected) {
          _backgroundRefresh();
        }
        return Right(cachedData);
      }

      // If no cache or stale data, fetch from remote
      if (await _networkInfo.isConnected) {
        final remoteData = await _remoteSource.getMarketData();
        await _localSource.cacheMarketData(remoteData);
        return Right(remoteData);
      }

      // Fallback to bundled data if no internet
      final bundledData = await _localSource.getBundledData();
      return Right(bundledData);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  bool _isDataStale(MarketData data) {
    final now = DateTime.now();
    final lastUpdate = DateTime.parse(data.metadata.lastUpdated);
    return now.difference(lastUpdate).inHours > 24;
  }

  void _backgroundRefresh() {
    // Non-blocking background refresh
    _remoteSource.getMarketData().then((data) {
      _localSource.cacheMarketData(data);
    }).catchError((e) {
      // Log error but don't affect UI
      debugPrint('Background refresh failed: $e');
    });
  }
}
```

### 3.2 CDN Data Fetching Strategy

```dart
class MarketDataRemoteSource {
  final DioClient _dioClient;
  
  static const String _primaryCdnUrl = 
      'https://cdn.homeloanadvisor.com/market-data.json';
  static const String _backupCdnUrl = 
      'https://backup-cdn.homeloanadvisor.com/market-data.json';
  
  MarketDataRemoteSource(this._dioClient);

  Future<MarketData> getMarketData() async {
    try {
      // Try primary CDN first
      final response = await _dioClient.get(_primaryCdnUrl);
      return MarketData.fromJson(response.data);
    } catch (e) {
      debugPrint('Primary CDN failed, trying backup: $e');
      
      try {
        // Fallback to backup CDN
        final response = await _dioClient.get(_backupCdnUrl);
        return MarketData.fromJson(response.data);
      } catch (backupError) {
        throw NetworkException('Both CDN sources failed');
      }
    }
  }
}
```

### 3.3 Local Caching with Hive

```dart
@HiveType(typeId: 0)
class MarketDataCache extends HiveObject {
  @HiveField(0)
  final String jsonData;
  
  @HiveField(1)
  final DateTime cachedAt;
  
  @HiveField(2)
  final String version;

  MarketDataCache({
    required this.jsonData,
    required this.cachedAt,
    required this.version,
  });
}

class MarketDataLocalSource {
  final Box<MarketDataCache> _cacheBox;
  
  MarketDataLocalSource(this._cacheBox);

  Future<MarketData?> getCachedMarketData() async {
    try {
      final cached = _cacheBox.get('market_data');
      if (cached == null) return null;
      
      final jsonMap = jsonDecode(cached.jsonData);
      return MarketData.fromJson(jsonMap);
    } catch (e) {
      debugPrint('Cache read error: $e');
      return null;
    }
  }

  Future<void> cacheMarketData(MarketData data) async {
    try {
      final cache = MarketDataCache(
        jsonData: jsonEncode(data.toJson()),
        cachedAt: DateTime.now(),
        version: data.metadata.version,
      );
      await _cacheBox.put('market_data', cache);
    } catch (e) {
      debugPrint('Cache write error: $e');
    }
  }

  Future<MarketData> getBundledData() async {
    // Read from assets as ultimate fallback
    final jsonString = await rootBundle.loadString(
      'assets/data/fallback-market-data.json'
    );
    final jsonMap = jsonDecode(jsonString);
    return MarketData.fromJson(jsonMap);
  }
}
```

### 3.4 Data Models with Freezed

```dart
@freezed
class MarketData with _$MarketData {
  const factory MarketData({
    required MarketMetadata metadata,
    required MarketRates marketRates,
    required List<Bank> banks,
    required TaxBenefits taxBenefits,
    required GovernmentSchemes governmentSchemes,
    required Map<String, StampDutyRate> stampDutyRegistration,
    required InsuranceRates insuranceRates,
    required MarketTrends marketTrends,
  }) = _MarketData;

  factory MarketData.fromJson(Map<String, dynamic> json) =>
      _$MarketDataFromJson(json);
}

@freezed
class Bank with _$Bank {
  const factory Bank({
    required String bankId,
    required String bankName,
    required BankType bankType,
    required double marketShare,
    required DateTime lastUpdated,
    required InterestRates interestRates,
    required ProcessingFees processingFees,
    required Eligibility eligibility,
  }) = _Bank;

  factory Bank.fromJson(Map<String, dynamic> json) => 
      _$BankFromJson(json);
}

enum BankType { 
  @JsonValue('public') public, 
  @JsonValue('private') private, 
  @JsonValue('nbfc') nbfc 
}
```

---

## 4. Domain Layer - Business Logic

### 4.1 EMI Calculation Engine

```dart
class EMICalculationUseCase {
  Future<Either<Failure, EMIResult>> calculate(
    EMICalculationParams params,
  ) async {
    try {
      return Right(_performCalculation(params));
    } catch (e) {
      return Left(CalculationFailure(e.toString()));
    }
  }

  EMIResult _performCalculation(EMICalculationParams params) {
    // Standard EMI calculation: P[r(1+r)^n]/[(1+r)^n-1]
    final principal = params.loanAmount;
    final rate = params.interestRate / 100 / 12; // Monthly rate
    final tenure = params.tenureYears * 12; // Total months
    
    final emiAmount = _calculateEMI(principal, rate, tenure);
    final totalAmount = emiAmount * tenure;
    final totalInterest = totalAmount - principal;
    
    // Calculate with processing fees
    final processingFee = _calculateProcessingFee(
      principal, 
      params.processingFeePercentage,
    );
    
    final totalCostWithFees = totalAmount + processingFee;
    
    // Calculate tax benefits
    final taxBenefits = _calculateTaxBenefits(
      params.loanAmount,
      totalInterest / params.tenureYears, // Annual interest
      params.taxBracket,
    );
    
    // Generate amortization schedule
    final amortizationSchedule = _generateAmortizationSchedule(
      principal,
      rate,
      tenure,
      emiAmount,
    );
    
    return EMIResult(
      emiAmount: emiAmount,
      totalAmount: totalAmount,
      totalInterest: totalInterest,
      processingFee: processingFee,
      totalCostWithFees: totalCostWithFees,
      taxBenefits: taxBenefits,
      effectiveEMI: emiAmount - (taxBenefits.monthlyBenefit),
      payoffDate: _calculatePayoffDate(params.startDate, tenure),
      amortizationSchedule: amortizationSchedule,
    );
  }

  double _calculateEMI(double principal, double rate, int tenure) {
    if (rate == 0) return principal / tenure;
    
    final numerator = principal * rate * math.pow(1 + rate, tenure);
    final denominator = math.pow(1 + rate, tenure) - 1;
    
    return numerator / denominator;
  }

  List<AmortizationEntry> _generateAmortizationSchedule(
    double principal,
    double rate,
    int tenure,
    double emiAmount,
  ) {
    final schedule = <AmortizationEntry>[];
    double remainingPrincipal = principal;
    
    for (int month = 1; month <= tenure; month++) {
      final interestComponent = remainingPrincipal * rate;
      final principalComponent = emiAmount - interestComponent;
      remainingPrincipal -= principalComponent;
      
      schedule.add(AmortizationEntry(
        month: month,
        emiAmount: emiAmount,
        principalComponent: principalComponent,
        interestComponent: interestComponent,
        remainingPrincipal: math.max(0, remainingPrincipal),
      ));
    }
    
    return schedule;
  }
}
```

### 4.2 Tax Benefits Calculator

```dart
class TaxBenefitCalculationUseCase {
  TaxBenefits calculateTaxBenefits(
    double loanAmount,
    double annualInterest,
    TaxBracket taxBracket,
  ) {
    // Section 80C - Principal repayment benefit
    final annualPrincipal = _calculateAnnualPrincipal(loanAmount);
    final section80cDeduction = math.min(annualPrincipal, 150000); // ₹1.5L limit
    final section80cSaving = section80cDeduction * _getTaxRate(taxBracket);
    
    // Section 24(b) - Interest payment benefit
    final section24bDeduction = math.min(annualInterest, 200000); // ₹2L limit
    final section24bSaving = section24bDeduction * _getTaxRate(taxBracket);
    
    // Section 80EEA - Additional interest benefit (if applicable)
    final section80eeaDeduction = _calculateSection80EEA(
      annualInterest,
      loanAmount,
    );
    final section80eeaSaving = section80eeaDeduction * _getTaxRate(taxBracket);
    
    final totalAnnualSaving = section80cSaving + section24bSaving + section80eeaSaving;
    
    return TaxBenefits(
      section80cDeduction: section80cDeduction,
      section80cSaving: section80cSaving,
      section24bDeduction: section24bDeduction,
      section24bSaving: section24bSaving,
      section80eeaDeduction: section80eeaDeduction,
      section80eeaSaving: section80eeaSaving,
      totalAnnualSaving: totalAnnualSaving,
      monthlyBenefit: totalAnnualSaving / 12,
    );
  }

  double _getTaxRate(TaxBracket bracket) {
    switch (bracket) {
      case TaxBracket.fivePercent:
        return 0.05;
      case TaxBracket.tenPercent:
        return 0.10;
      case TaxBracket.twentyPercent:
        return 0.20;
      case TaxBracket.thirtyPercent:
        return 0.30;
    }
  }
}
```

### 4.3 Prepayment Impact Calculator

```dart
class PrepaymentCalculationUseCase {
  PrepaymentResult calculatePrepaymentImpact(
    PrepaymentParams params,
  ) {
    final originalResult = _calculateOriginalLoan(params);
    final prepaidResult = _calculateWithPrepayment(params);
    
    return PrepaymentResult(
      originalTotalInterest: originalResult.totalInterest,
      prepaidTotalInterest: prepaidResult.totalInterest,
      interestSaved: originalResult.totalInterest - prepaidResult.totalInterest,
      originalTenure: originalResult.tenureMonths,
      prepaidTenure: prepaidResult.tenureMonths,
      tenureReduced: originalResult.tenureMonths - prepaidResult.tenureMonths,
      prepaymentAmount: params.prepaymentAmount,
      roi: _calculateROI(
        params.prepaymentAmount,
        originalResult.totalInterest - prepaidResult.totalInterest,
      ),
    );
  }

  double _calculateROI(double investment, double returns) {
    return (returns / investment) * 100;
  }
}
```

---

## 5. Presentation Layer - State Management

### 5.1 Riverpod 2.0 Providers Structure

```dart
// Market Data Provider
@riverpod
class MarketData extends _$MarketData {
  @override
  Future<MarketDataEntity> build() async {
    final repository = ref.read(marketDataRepositoryProvider);
    final result = await repository.getMarketData();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(marketDataRepositoryProvider);
    final result = await repository.refreshMarketData();
    
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}

// Calculator State Provider
@riverpod
class CalculatorState extends _$CalculatorState {
  @override
  LoanCalculationState build() {
    return const LoanCalculationState.initial();
  }

  void updateLoanAmount(double amount) {
    final currentState = state;
    if (currentState is LoanCalculationLoaded) {
      state = currentState.copyWith(loanAmount: amount);
      _recalculate();
    }
  }

  void updateInterestRate(double rate) {
    final currentState = state;
    if (currentState is LoanCalculationLoaded) {
      state = currentState.copyWith(interestRate: rate);
      _recalculate();
    }
  }

  void updateTenure(int years) {
    final currentState = state;
    if (currentState is LoanCalculationLoaded) {
      state = currentState.copyWith(tenureYears: years);
      _recalculate();
    }
  }

  Future<void> _recalculate() async {
    final useCase = ref.read(emiCalculationUseCaseProvider);
    final params = _buildCalculationParams();
    
    final result = await useCase.calculate(params);
    
    result.fold(
      (failure) => state = LoanCalculationState.error(failure.message),
      (emiResult) => state = LoanCalculationState.loaded(
        loanAmount: params.loanAmount,
        interestRate: params.interestRate,
        tenureYears: params.tenureYears,
        result: emiResult,
      ),
    );
  }
}

// Strategies Provider
@riverpod
class StrategiesNotifier extends _$StrategiesNotifier {
  @override
  Future<List<StrategyEntity>> build() async {
    final useCase = ref.read(getStrategiesUseCaseProvider);
    final calculatorState = ref.read(calculatorStateProvider);
    
    if (calculatorState is! LoanCalculationLoaded) {
      return [];
    }
    
    final result = await useCase.execute(
      loanAmount: calculatorState.loanAmount,
      interestRate: calculatorState.interestRate,
      tenureYears: calculatorState.tenureYears,
    );
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (strategies) => strategies,
    );
  }
}

// User Preferences Provider
@riverpod
class UserPreferences extends _$UserPreferences {
  @override
  UserPreferencesState build() {
    return const UserPreferencesState();
  }

  void updateTaxBracket(TaxBracket bracket) {
    state = state.copyWith(taxBracket: bracket);
  }

  void updateRiskProfile(RiskProfile profile) {
    state = state.copyWith(riskProfile: profile);
  }

  void markStrategyAsInterested(String strategyId) {
    final interestedStrategies = Set<String>.from(state.interestedStrategies);
    interestedStrategies.add(strategyId);
    state = state.copyWith(interestedStrategies: interestedStrategies);
  }
}
```

### 5.2 State Classes with Freezed

```dart
@freezed
class LoanCalculationState with _$LoanCalculationState {
  const factory LoanCalculationState.initial() = LoanCalculationInitial;
  
  const factory LoanCalculationState.loading() = LoanCalculationLoading;
  
  const factory LoanCalculationState.loaded({
    required double loanAmount,
    required double interestRate,
    required int tenureYears,
    required EMIResult result,
    ProcessingFeeParams? processingFees,
    TaxBracket? taxBracket,
  }) = LoanCalculationLoaded;
  
  const factory LoanCalculationState.error(String message) = LoanCalculationError;
}

@freezed
class UserPreferencesState with _$UserPreferencesState {
  const factory UserPreferencesState({
    @Default(TaxBracket.twentyPercent) TaxBracket taxBracket,
    @Default(RiskProfile.moderate) RiskProfile riskProfile,
    @Default({}) Set<String> interestedStrategies,
    @Default(true) bool showTaxBenefits,
    @Default(true) bool enableNotifications,
    String? preferredBank,
  }) = _UserPreferencesState;
}
```

---

## 6. Navigation with GoRouter

### 6.1 Router Configuration

```dart
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: RoutePaths.calculator,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.calculator,
            name: RouteNames.calculator,
            builder: (context, state) => const CalculatorScreen(),
            routes: [
              GoRoute(
                path: '/details',
                name: RouteNames.loanDetails,
                builder: (context, state) => const LoanDetailsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.strategies,
            name: RouteNames.strategies,
            builder: (context, state) => const StrategiesScreen(),
            routes: [
              GoRoute(
                path: '/strategy/:id',
                name: RouteNames.strategyDetail,
                builder: (context, state) {
                  final strategyId = state.pathParameters['id']!;
                  return StrategyDetailScreen(strategyId: strategyId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  static GoRouter get router => _router;
}

class RoutePaths {
  static const String calculator = '/calculator';
  static const String strategies = '/strategies';
}

class RouteNames {
  static const String calculator = 'calculator';
  static const String strategies = 'strategies';
  static const String loanDetails = 'loan-details';
  static const String strategyDetail = 'strategy-detail';
}
```

### 6.2 Main Shell with Bottom Navigation

```dart
class MainShell extends ConsumerWidget {
  final Widget child;
  
  const MainShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(currentLocation),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.calculate),
            icon: Icon(Icons.calculate_outlined),
            label: 'Calculator',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.lightbulb),
            icon: Icon(Icons.lightbulb_outline),
            label: 'Strategies',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/calculator')) return 0;
    if (location.startsWith('/strategies')) return 1;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.calculator);
        break;
      case 1:
        context.goNamed(RouteNames.strategies);
        break;
    }
  }
}
```

---

## 7. External Data Strategy

### 7.1 Daily Data Update Service

```dart
class MarketDataUpdateService {
  final MarketDataRepository _repository;
  final StorageService _storage;
  
  static const String _lastUpdateKey = 'last_market_data_update';
  
  MarketDataUpdateService(this._repository, this._storage);

  Future<void> checkAndUpdateMarketData() async {
    try {
      final lastUpdate = await _getLastUpdateTime();
      final now = DateTime.now();
      
      // Check if data is older than 24 hours
      if (_shouldUpdate(lastUpdate, now)) {
        await _performUpdate();
        await _storage.setString(_lastUpdateKey, now.toIso8601String());
      }
    } catch (e) {
      // Log error but don't throw - app should work offline
      debugPrint('Market data update failed: $e');
    }
  }

  bool _shouldUpdate(DateTime? lastUpdate, DateTime now) {
    if (lastUpdate == null) return true;
    return now.difference(lastUpdate).inHours >= 24;
  }

  Future<void> _performUpdate() async {
    final result = await _repository.refreshMarketData();
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => debugPrint('Market data updated successfully'),
    );
  }

  Future<DateTime?> _getLastUpdateTime() async {
    final lastUpdateStr = await _storage.getString(_lastUpdateKey);
    if (lastUpdateStr == null) return null;
    return DateTime.tryParse(lastUpdateStr);
  }
}

// Background task registration
class BackgroundTaskService {
  static Future<void> initializeBackgroundTasks() async {
    // Register background fetch for iOS/Android
    if (Platform.isIOS) {
      await _registerIOSBackgroundFetch();
    } else if (Platform.isAndroid) {
      await _registerAndroidWorkManager();
    }
  }

  static Future<void> _registerIOSBackgroundFetch() async {
    // iOS Background App Refresh implementation
  }

  static Future<void> _registerAndroidWorkManager() async {
    // Android WorkManager implementation
  }
}
```

### 7.2 Fallback Strategy

```dart
class FallbackDataProvider {
  static const String _bundledDataPath = 'assets/data/market-data-fallback.json';
  
  Future<MarketData> getBundledMarketData() async {
    try {
      final jsonString = await rootBundle.loadString(_bundledDataPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return MarketData.fromJson(jsonMap);
    } catch (e) {
      // Return hardcoded minimum viable data as last resort
      return _getMinimumViableData();
    }
  }

  MarketData _getMinimumViableData() {
    return MarketData(
      metadata: MarketMetadata(
        version: '1.0.0-fallback',
        lastUpdated: DateTime.now().toIso8601String(),
        dataProvider: 'Bundled Fallback',
      ),
      marketRates: const MarketRates(
        repoRate: RepoRate(current: 6.50),
        averageHomeLoanRate: 8.65,
        rateTrend: 'stable',
      ),
      banks: _getDefaultBanks(),
      taxBenefits: _getDefaultTaxBenefits(),
      governmentSchemes: _getDefaultSchemes(),
      stampDutyRegistration: _getDefaultStampDuty(),
      insuranceRates: _getDefaultInsurance(),
      marketTrends: _getDefaultTrends(),
    );
  }
}
```

---

## 8. Package Dependencies

### 8.1 Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & Architecture
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Navigation
  go_router: ^13.0.1

  # HTTP & Network
  dio: ^5.4.0
  connectivity_plus: ^5.0.2

  # Local Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # JSON & Data Serialization
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1

  # UI & Charts
  fl_chart: ^0.66.0
  shimmer: ^3.0.0
  lottie: ^2.7.0

  # Indian Localization
  intl: ^0.19.0

  # Fonts
  google_fonts: ^6.1.0

  # Firebase (Optional)
  firebase_core: ^2.24.2
  firebase_analytics: ^10.8.0
  firebase_crashlytics: ^3.4.8

  # Platform Integration
  path_provider: ^2.1.2
  url_launcher: ^6.2.2

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  hive_generator: ^2.0.1

  # Testing
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.2
  integration_test:
    sdk: flutter

  # Linting
  flutter_lints: ^3.0.1
  very_good_analysis: ^5.1.0
```

### 8.2 Package Justifications

- **Riverpod 2.0**: Type-safe, testable state management with code generation
- **GoRouter**: Declarative routing with deep linking support
- **Dio**: Feature-rich HTTP client with interceptors and error handling
- **Hive**: Fast, lightweight local database for caching
- **fl_chart**: Beautiful, customizable charts for financial data
- **Freezed**: Immutable classes with copyWith and pattern matching
- **Firebase**: Analytics and crash reporting for production insights
- **Google Fonts**: Inter & Roboto Mono for financial UI readability

---

## 9. Implementation Phases

### 9.1 Phase 1: Core Calculator (Week 1)

**Priority**: MVP Foundation  
**Duration**: 7 days  
**Goal**: Functional EMI calculator with basic UI

#### Tasks
1. **Project Setup** (Day 1)
   ```bash
   flutter create home_loan_advisor
   cd home_loan_advisor
   flutter pub add flutter_riverpod go_router dio hive
   ```

2. **Core Architecture** (Days 1-2)
   - Set up folder structure
   - Implement base data models
   - Create repository interfaces
   - Set up dependency injection

3. **Basic Calculator Logic** (Days 2-3)
   - EMI calculation algorithm
   - Basic input validation
   - Simple state management

4. **UI Foundation** (Days 3-4)
   - Material 3 theme setup
   - Basic calculator screen
   - Input widgets (sliders, text fields)
   - Results display

5. **Data Integration** (Days 4-5)
   - Market data models
   - JSON parsing
   - Basic caching
   - Fallback data

6. **Testing & Polish** (Days 6-7)
   - Unit tests for calculations
   - Widget tests for UI
   - Bug fixes and optimizations

#### Deliverables
- Functional EMI calculator
- Basic 2-screen navigation
- Market data integration
- Test coverage >70%

### 9.2 Phase 2: Tax Integration (Week 2)

**Priority**: Tax-Aware Calculations  
**Duration**: 7 days  
**Goal**: Complete tax benefit calculations

#### Tasks
1. **Tax Calculation Engine** (Days 1-2)
   - Section 80C implementation
   - Section 24(b) implementation
   - Tax bracket integration

2. **Advanced Calculator Features** (Days 2-3)
   - Processing fee calculation
   - Total cost transparency
   - Effective EMI after tax benefits

3. **Enhanced UI** (Days 3-4)
   - Tax benefit cards
   - Advanced options panel
   - Results breakdown visualization

4. **PMAY Integration** (Days 4-5)
   - PMAY eligibility checker
   - Subsidy calculation
   - Integration with tax benefits

5. **Validation & Testing** (Days 6-7)
   - Edge case testing
   - Tax calculation validation
   - Performance optimization

### 9.3 Phase 3: Strategies Implementation (Week 3)

**Priority**: Money-Saving Features  
**Duration**: 7 days  
**Goal**: Complete strategies screen with calculations

#### Tasks
1. **Strategies Data Structure** (Days 1-2)
   - Strategy models and entities
   - Calculation algorithms
   - Personalization engine

2. **Strategy Calculations** (Days 2-3)
   - Extra EMI impact
   - Step-up EMI calculations
   - Prepayment scenarios

3. **Strategies UI** (Days 3-4)
   - Strategy cards
   - Impact visualizations
   - Implementation guides

4. **Advanced Strategies** (Days 4-5)
   - Balance transfer calculator
   - PF withdrawal analysis
   - Combination recommendations

5. **Integration & Polish** (Days 6-7)
   - Integration testing
   - Content refinement
   - Performance optimization

### 9.4 Phase 4: Polish & Production (Week 4)

**Priority**: Production Readiness  
**Duration**: 7 days  
**Goal**: Production-ready app with all features

#### Tasks
1. **Charts & Visualizations** (Days 1-2)
   - Amortization charts
   - Pie charts for interest/principal
   - Strategy impact graphs

2. **Advanced Features** (Days 2-3)
   - Bank comparison
   - Scenario planning
   - Calculation history

3. **Performance Optimization** (Days 3-4)
   - App size optimization
   - Memory usage optimization
   - Smooth animations

4. **Production Setup** (Days 4-5)
   - Firebase integration
   - Error tracking
   - Analytics setup

5. **Final Testing & Release** (Days 6-7)
   - Integration testing
   - Performance testing
   - App store preparation

---

## 10. Testing Strategy

### 10.1 Unit Testing (Target: >80% Coverage)

```dart
// Example: EMI Calculation Tests
class EMICalculationTest {
  late EMICalculationUseCase useCase;

  setUp(() {
    useCase = EMICalculationUseCase();
  });

  group('EMI Calculation Tests', () {
    test('should calculate EMI correctly for standard loan', () async {
      // Arrange
      final params = EMICalculationParams(
        loanAmount: 5000000, // ₹50L
        interestRate: 8.5,
        tenureYears: 20,
      );

      // Act
      final result = await useCase.calculate(params);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (emiResult) {
          expect(emiResult.emiAmount, closeTo(43391, 1));
          expect(emiResult.totalInterest, closeTo(5413840, 1000));
        },
      );
    });

    test('should handle zero interest rate', () async {
      // Edge case testing
      final params = EMICalculationParams(
        loanAmount: 1000000,
        interestRate: 0.0,
        tenureYears: 10,
      );

      final result = await useCase.calculate(params);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (emiResult) {
          expect(emiResult.emiAmount, closeTo(8333.33, 0.01));
          expect(emiResult.totalInterest, 0);
        },
      );
    });
  });
}

// Tax Calculation Tests
class TaxBenefitTest {
  late TaxBenefitCalculationUseCase useCase;

  setUp(() {
    useCase = TaxBenefitCalculationUseCase();
  });

  test('should calculate maximum tax benefits correctly', () {
    // Test maximum Section 80C and 24(b) benefits
    final benefits = useCase.calculateTaxBenefits(
      5000000, // ₹50L loan
      400000,  // ₹4L annual interest
      TaxBracket.thirtyPercent,
    );

    expect(benefits.section80cDeduction, 150000); // ₹1.5L max
    expect(benefits.section24bDeduction, 200000); // ₹2L max
    expect(benefits.section80cSaving, 45000);     // 30% of 1.5L
    expect(benefits.section24bSaving, 60000);     // 30% of 2L
  });
}
```

### 10.2 Widget Testing

```dart
class CalculatorScreenTest {
  testWidgets('should update EMI when loan amount changes', (tester) async {
    // Setup
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          marketDataProvider.overrideWith((ref) => 
            AsyncValue.data(mockMarketData)),
        ],
        child: const MaterialApp(home: CalculatorScreen()),
      ),
    );

    // Find loan amount slider
    final slider = find.byType(Slider).first;
    expect(slider, findsOneWidget);

    // Change loan amount
    await tester.drag(slider, const Offset(100, 0));
    await tester.pump();

    // Verify EMI updated
    expect(find.textContaining('₹'), findsAtLeastNWidgets(1));
  });

  testWidgets('should show tax benefits when enabled', (tester) async {
    await tester.pumpWidget(testApp());

    // Enable tax benefits
    final taxSwitch = find.byType(Switch);
    await tester.tap(taxSwitch);
    await tester.pump();

    // Verify tax benefit card is shown
    expect(find.text('Tax Benefits'), findsOneWidget);
    expect(find.textContaining('Section 80C'), findsOneWidget);
  });
}
```

### 10.3 Integration Testing

```dart
class AppIntegrationTest {
  testWidgets('complete user flow test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to calculator
    expect(find.byType(CalculatorScreen), findsOneWidget);

    // Input loan details
    await tester.enterText(
      find.byKey(const Key('loan_amount_input')), 
      '5000000'
    );
    await tester.enterText(
      find.byKey(const Key('interest_rate_input')), 
      '8.5'
    );
    
    // Wait for calculation
    await tester.pump(const Duration(milliseconds: 500));

    // Verify results
    expect(find.textContaining('₹43,391'), findsOneWidget);

    // Navigate to strategies
    await tester.tap(find.text('Strategies'));
    await tester.pumpAndSettle();

    // Verify strategies screen
    expect(find.byType(StrategiesScreen), findsOneWidget);
    expect(find.text('Extra EMI Strategy'), findsOneWidget);

    // Tap on strategy
    await tester.tap(find.text('Extra EMI Strategy'));
    await tester.pumpAndSettle();

    // Verify strategy detail
    expect(find.byType(StrategyDetailScreen), findsOneWidget);
    expect(find.textContaining('₹8.2L'), findsOneWidget);
  });
}
```

### 10.4 Golden Testing

```dart
class GoldenTest {
  testWidgets('calculator screen golden test', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CalculatorScreen),
      matchesGoldenFile('calculator_screen.png'),
    );
  });

  testWidgets('emi result card golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EMIResultCard(
            emiAmount: 43391,
            totalInterest: 5413840,
            taxSavings: 50000,
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(EMIResultCard),
      matchesGoldenFile('emi_result_card.png'),
    );
  });
}
```

---

## 11. Performance Considerations

### 11.1 App Size Optimization

```dart
// Tree-shake icons
import 'package:flutter/material.dart' show Icons;

// Use only required icons
class AppIcons {
  static const calculate = Icons.calculate_outlined;
  static const strategies = Icons.lightbulb_outline;
  // ... only icons used in app
}

// Compress images
flutter build apk --tree-shake-icons --shrink

// Android App Bundle for optimal size
flutter build appbundle --release
```

### 11.2 Memory Management

```dart
class CalculationService {
  // Use weak references for callbacks
  final List<WeakReference<VoidCallback>> _listeners = [];

  void addListener(VoidCallback callback) {
    _listeners.add(WeakReference(callback));
  }

  void _notifyListeners() {
    _listeners.removeWhere((ref) => ref.target == null);
    for (final ref in _listeners) {
      ref.target?.call();
    }
  }

  @override
  void dispose() {
    _listeners.clear();
    super.dispose();
  }
}
```

### 11.3 Computation Optimization

```dart
class EMICalculator {
  // Memoize expensive calculations
  final Map<String, double> _calculationCache = {};

  double calculateEMI(double principal, double rate, int tenure) {
    final key = '${principal}_${rate}_$tenure';
    
    return _calculationCache[key] ??= _computeEMI(principal, rate, tenure);
  }

  // Use isolates for heavy computations
  Future<List<AmortizationEntry>> generateAmortizationSchedule(
    EMIParams params,
  ) async {
    return compute(_computeAmortizationSchedule, params);
  }

  static List<AmortizationEntry> _computeAmortizationSchedule(
    EMIParams params,
  ) {
    // Heavy computation in isolate
    // This won't block the UI thread
  }
}
```

### 11.4 UI Performance

```dart
class OptimizedCalculatorScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        // Use slivers for better performance
        slivers: [
          const SliverAppBar(
            title: Text('EMI Calculator'),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: RepaintBoundary(
              // Isolate expensive widgets
              child: Consumer(
                builder: (context, ref, child) {
                  final result = ref.watch(calculatorProvider);
                  return EMIResultCard(result: result);
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const InputWidget(),
              childCount: 3, // Known count
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 12. Platform Specific Setup

### 12.1 Android Configuration

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Material 3 theme -->
    <application
        android:label="Home Loan Advisor"
        android:icon="@mipmap/ic_launcher"
        android:theme="@style/LaunchTheme">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/LaunchTheme"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https"
                      android:host="homeloanadvisor.com" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
        
        // Proguard for release builds
        proguardFiles getDefaultProguardFile('proguard-android.txt')
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 12.2 iOS Configuration

```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <key>CFBundleDisplayName</key>
    <string>Home Loan Advisor</string>
    
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>homeloanadvisor.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
            </dict>
        </dict>
    </dict>
    
    <!-- Deep linking -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>homeloanadvisor.com</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>https</string>
            </array>
        </dict>
    </array>
    
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <key>UIInterfaceOrientationPortrait</key>
    </array>
</dict>
```

### 12.3 Required Permissions

- **Internet Access**: For CDN data fetching
- **Network State**: For offline detection
- **Storage**: For local caching (automatically granted)

No sensitive permissions required - maintains user privacy.

---

## 13. Development Commands & Scripts

### 13.1 Essential Commands

```bash
# Development
flutter run --flavor dev

# Code generation
dart run build_runner build --delete-conflicting-outputs

# Testing
flutter test --coverage
flutter test integration_test/

# Build release
flutter build apk --release --tree-shake-icons
flutter build ios --release

# Analysis
flutter analyze
dart format .
```

### 13.2 Build Scripts

```bash
#!/bin/bash
# scripts/build_release.sh

echo "Building Home Loan Advisor for release..."

# Clean
flutter clean
flutter pub get

# Code generation
dart run build_runner build --delete-conflicting-outputs

# Tests
flutter test --coverage

# Build Android
flutter build appbundle --release --tree-shake-icons --shrink

# Build iOS (requires macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    flutter build ios --release --no-codesign
fi

echo "Build complete!"
```

### 13.3 Performance Profiling

```bash
# Profile app performance
flutter run --profile --trace-startup

# Memory analysis
flutter run --profile --dart-vm-service-port=8181

# Build size analysis
flutter build apk --analyze-size
```

---

## 14. Production Deployment Checklist

### 14.1 Pre-Release Validation

- [ ] All calculations validated against manual calculations
- [ ] 15 major bank rates tested
- [ ] Tax benefit calculations verified
- [ ] Offline functionality tested
- [ ] Performance benchmarks met (<2s startup)
- [ ] Memory usage <100MB during normal operation
- [ ] Battery impact minimal
- [ ] Accessibility features tested

### 14.2 App Store Requirements

**Android (Play Store)**
- [ ] Target SDK 34 (Android 14)
- [ ] App Bundle format
- [ ] 64-bit support
- [ ] Privacy policy link
- [ ] App content rating

**iOS (App Store)**
- [ ] iOS 12.0+ compatibility
- [ ] Privacy nutrition labels
- [ ] App Store screenshots
- [ ] App description & keywords

### 14.3 Monitoring Setup

```dart
// Firebase integration for production insights
class MonitoringService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    
    // Set up crash reporting
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    // Set up analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    
    // Set up performance monitoring
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }

  static void logCalculation(double loanAmount, double interestRate) {
    FirebaseAnalytics.instance.logEvent(
      name: 'emi_calculated',
      parameters: {
        'loan_amount_range': _getLoanAmountRange(loanAmount),
        'interest_rate_range': _getInterestRateRange(interestRate),
      },
    );
  }

  static void logStrategyViewed(String strategyId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'strategy_viewed',
      parameters: {'strategy_id': strategyId},
    );
  }
}
```

---

## Summary

This technical implementation document provides a complete roadmap for building a production-ready Home Loan Advisor Flutter app with the following key features:

### ✅ **Complete Architecture**
- Clean Architecture with Domain-Driven Design
- Riverpod 2.0 for reactive state management
- GoRouter for navigation with deep linking
- Offline-first data strategy with CDN integration

### ✅ **Production Features**
- Tax-aware EMI calculations (80C, 24B, PMAY)
- 15 major Indian bank rates integration
- 7 comprehensive money-saving strategies
- Real-time market data with 24-hour caching
- Material 3 design with Indian adaptations

### ✅ **Performance Optimized**
- <2s startup time target
- <100MB memory usage
- Tree-shaken icons and optimized builds
- Smooth 60fps animations
- Efficient calculation caching

### ✅ **Developer Experience**
- Comprehensive testing strategy (unit, widget, integration)
- Code generation with Freezed and Riverpod
- Type-safe API with proper error handling
- Clear project structure and documentation

### ✅ **Indian Market Specific**
- ₹, lakhs, crores number formatting
- Indian tax law integration
- Festival bonus strategies
- Cultural context in financial advice

The implementation follows Flutter 3.x best practices and modern architecture patterns, ensuring the app is maintainable, scalable, and ready for production deployment to both Android and iOS app stores.

**Next Steps**: Follow the 4-week implementation phases, starting with Phase 1 (Core Calculator) to deliver a functional MVP within 7 days.