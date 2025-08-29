# Technical Foundation & Development Specifications
## Home Loan Advisor Flutter App

**Final technical decisions confirmed with user preferences and ready for immediate development.**

---

## 🎯 Confirmed Technical Decisions

### **State Management: Riverpod** ✅
- **Choice**: flutter_riverpod ^2.4.9 with code generation
- **Rationale**: User has existing Riverpod experience, better for reactive calculator architecture
- **Benefits**: Compile-time safety, granular rebuilds, easier testing, better performance

### **Platform Strategy: Android-First** ✅
- **Initial Target**: Android-only (API 21+ / Android 5.0+)
- **Future**: iOS can be added later based on success
- **Market Fit**: Indian market is 80%+ Android-dominated

### **Business Logic Configurations** ✅
- **Currency Format**: ₹50,00,000 (no decimals, Indian lakhs format)
- **Interest Rate**: Annual percentage input (8.5% format)
- **Analytics**: Opt-in by default (user choice, privacy-first)

---

## 📦 Complete Dependencies List

### **pubspec.yaml**
```yaml
name: home_loan_advisor
description: Save lakhs on your home loan with 20 proven strategies
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management (Riverpod)
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Charts & Visualizations
  fl_chart: ^0.68.0

  # Local Storage (Offline-First)
  shared_preferences: ^2.2.2

  # File Operations (Export)
  csv: ^6.0.0
  pdf: ^3.10.7
  path_provider: ^2.1.2
  share_plus: ^7.2.2

  # Analytics (Opt-in)
  firebase_analytics: ^10.8.0
  firebase_core: ^2.24.2

  # Utilities
  intl: ^0.19.0          # Indian currency formatting
  equatable: ^2.0.5      # Value equality
  freezed_annotation: ^2.4.1  # Immutable models

  # UI
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Quality
  flutter_lints: ^3.0.0
  
  # Code Generation (Riverpod + Freezed)
  riverpod_generator: ^2.3.9
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/fonts/
    - assets/images/
  
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

---

## 🏗️ Project Structure with Riverpod

```
lib/
├── main.dart                          # App entry point with ProviderScope
├── app.dart                           # MaterialApp configuration
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   ├── color_constants.dart       # Material 3 colors
│   │   └── text_styles.dart           # Typography system
│   ├── theme/
│   │   ├── app_theme.dart             # Material 3 theme
│   │   └── chart_theme.dart           # fl_chart styling
│   ├── utils/
│   │   ├── currency_formatter.dart    # ₹50,00,000 formatting
│   │   ├── loan_calculations.dart     # EMI formulas
│   │   └── export_utils.dart          # CSV/PDF utilities
│   └── services/
│       ├── analytics_service.dart     # Firebase Analytics (opt-in)
│       ├── storage_service.dart       # SharedPreferences wrapper
│       └── export_service.dart        # File operations
├── models/                            # Freezed data models
│   ├── loan_model.dart               # @freezed Loan parameters
│   ├── loan_model.freezed.dart       # Generated
│   ├── strategy_model.dart           # @freezed Strategy data
│   ├── progress_model.dart           # @freezed Progress tracking
│   └── amortization_model.dart       # @freezed Payment schedule
├── providers/                         # Riverpod providers
│   ├── loan_provider.dart            # @riverpod LoanNotifier
│   ├── strategy_provider.dart        # @riverpod StrategyNotifier  
│   ├── progress_provider.dart        # @riverpod ProgressNotifier
│   ├── settings_provider.dart        # @riverpod SettingsNotifier
│   └── providers.dart                # Generated provider exports
├── screens/                          # UI screens with ConsumerWidget
│   ├── onboarding/
│   │   └── onboarding_screen.dart    # First-time user welcome
│   ├── dashboard/
│   │   ├── dashboard_screen.dart     # Daily burn counter
│   │   └── widgets/
│   │       ├── daily_burn_counter.dart
│   │       ├── loan_health_card.dart
│   │       └── quick_insights.dart
│   ├── calculator/
│   │   ├── calculator_screen.dart    # EMI calculations
│   │   └── widgets/
│   │       ├── loan_input_form.dart
│   │       ├── emi_breakdown.dart
│   │       ├── chart_container.dart
│   │       └── amortization_table.dart
│   ├── strategies/
│   │   ├── strategies_screen.dart    # 20 strategies list
│   │   ├── strategy_detail_screen.dart
│   │   └── widgets/
│   │       ├── strategy_card.dart
│   │       └── strategy_calculator.dart
│   └── progress/
│       ├── progress_screen.dart      # Achievement tracking
│       └── widgets/
│           ├── milestone_tracker.dart
│           └── achievement_badge.dart
├── widgets/                          # Shared UI components
│   ├── common/
│   │   ├── app_button.dart           # Material 3 buttons
│   │   ├── app_card.dart             # Consistent cards
│   │   ├── currency_display.dart     # ₹ formatting
│   │   └── loading_indicator.dart    # Loading states
│   ├── charts/
│   │   ├── pie_chart_widget.dart     # Principal vs Interest
│   │   ├── timeline_chart_widget.dart # Balance over time
│   │   └── chart_legend.dart         # Chart legends
│   └── navigation/
│       └── bottom_navigation.dart    # 4-tab navigation
└── data/                             # Static data
    ├── strategies_data.dart          # 20 strategy definitions
    └── default_values.dart          # Smart defaults (₹30L, 8.5%, 20y)
```

---

## 🎯 Riverpod Architecture Pattern

### **Provider Types Used**
```dart
// Notifier pattern for complex state
@riverpod
class LoanNotifier extends _$LoanNotifier {
  @override
  LoanModel build() => LoanModel.initial();
  
  void updateLoanAmount(double amount) {
    state = state.copyWith(loanAmount: amount);
  }
  
  void calculateEMI() {
    // Reactive calculations
  }
}

// Simple providers for derived state
@riverpod
double monthlyEMI(MonthlyEMIRef ref) {
  final loan = ref.watch(loanNotifierProvider);
  return LoanCalculations.calculateEMI(loan);
}

// Async providers for file operations
@riverpod
Future<String> exportToPDF(ExportToPDFRef ref) async {
  final loan = ref.watch(loanNotifierProvider);
  return ExportService.generatePDF(loan);
}
```

### **Consumer Widgets**
```dart
class CalculatorScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(loanNotifierProvider);
    final emi = ref.watch(monthlyEMIProvider);
    
    return Scaffold(
      body: Column(
        children: [
          LoanInputForm(),
          EMIBreakdown(emi: emi),
          ChartContainer(),
        ],
      ),
    );
  }
}
```

---

## 📱 Android Configuration

### **android/app/build.gradle**
```gradle
android {
    namespace 'com.homeloadadvisor.app'
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.homeloadadvisor.app"
        minSdkVersion 21        // Android 5.0+
        targetSdkVersion 34     // Latest
        versionCode 1
        versionName "1.0.0"
        
        // Indian market optimization
        resConfigs "en", "hi"   // English, Hindi support
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### **Required Permissions**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
                 android:maxSdkVersion="28" />
```

---

## 🔄 Development Workflow

### **Code Generation Commands**
```bash
# Generate Riverpod providers and Freezed models
dart run build_runner build

# Watch for changes during development
dart run build_runner watch

# Clean generated files
dart run build_runner clean
```

### **Development Phases (6-8 Weeks)**

#### **Phase 1: Foundation (Weeks 1-2)**
- [ ] Flutter project initialization
- [ ] Riverpod setup with code generation
- [ ] Material 3 theme implementation
- [ ] Bottom navigation (4 tabs)
- [ ] Basic loan model and calculator logic
- [ ] Core EMI calculation with reactive updates

#### **Phase 2: MVP Features (Weeks 3-4)**
- [ ] Dashboard with daily burn counter
- [ ] fl_chart integration (pie + timeline)
- [ ] SharedPreferences for loan persistence
- [ ] Top 5 strategies implementation
- [ ] Strategy detail pages
- [ ] Basic progress tracking

#### **Phase 3: Complete Feature Set (Weeks 5-6)**
- [ ] All 20 strategies with calculators
- [ ] Amortization schedule table
- [ ] CSV/PDF export functionality
- [ ] Achievement system and gamification
- [ ] Firebase Analytics integration (opt-in)
- [ ] Complete UI states (loading, error, empty)

#### **Phase 4: Polish & Launch (Weeks 7-8)**
- [ ] Animations and micro-interactions
- [ ] Comprehensive testing (unit, widget, integration)
- [ ] Performance optimization
- [ ] Play Store assets and listing
- [ ] Release build and deployment

---

## ⚡ Performance Optimizations

### **Chart Performance**
- Data sampling for timeline charts (max 240 points)
- Lazy loading for amortization table
- Chart caching with Riverpod

### **State Management**
- Granular providers to minimize rebuilds
- `select` for specific field watching
- Async providers for heavy calculations

### **App Size**
- Font subset optimization (Inter Regular, Medium, Bold only)
- Asset compression
- Tree shaking for unused Firebase features

---

## 🧪 Testing Strategy

### **Unit Tests**
- Loan calculation formulas
- Currency formatting utilities
- Strategy calculations
- Riverpod provider testing

### **Widget Tests**
- Calculator input validation
- Chart rendering
- Navigation flow
- Button interactions

### **Integration Tests**
- Complete user journeys
- Export functionality
- Progress tracking
- Analytics events (opt-in flow)

---

## 📊 Success Metrics & Monitoring

### **Business Metrics**
- Calculator completion rate (target: >90%)
- Strategy exploration rate (target: >60%)
- Export usage (target: >30%)
- User retention (target: >50% 7-day)

### **Technical Metrics**
- App startup time (<3 seconds)
- Calculation performance (<100ms)
- Chart rendering (<500ms)
- Crash-free sessions (>99.5%)

---

## 🎯 Next Steps

1. **Initialize Flutter project**: `flutter create .`
2. **Set up Riverpod**: Add dependencies and configure
3. **Create base models**: Loan, Strategy, Progress with Freezed
4. **Implement Material 3 theme**: Inter fonts and color system
5. **Start with Calculator screen**: Core EMI calculations with reactive UI

---

**The Home Loan Advisor project is now 100% ready for Flutter development with a solid technical foundation, clear architecture, and proven patterns!** 🚀

**Estimated Delivery**: 6-8 weeks to fully-featured app helping users save ₹2-8 lakhs on home loans.