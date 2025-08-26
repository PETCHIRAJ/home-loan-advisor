import 'package:freezed_annotation/freezed_annotation.dart';

part 'strategy_model.freezed.dart';
part 'strategy_model.g.dart';

/// Immutable model representing a loan optimization strategy
///
/// Each strategy provides specific methods to reduce loan cost or tenure,
/// with calculated savings and implementation details.
@freezed
class StrategyModel with _$StrategyModel {
  const factory StrategyModel({
    /// Unique identifier for the strategy
    required String id,

    /// Strategy title (e.g., "Extra EMI Payment")
    required String title,

    /// Brief description of the strategy
    required String description,

    /// Detailed explanation of how the strategy works
    required String explanation,

    /// Strategy category for grouping
    required StrategyCategory category,

    /// Difficulty level for implementation
    required StrategyDifficulty difficulty,

    /// Potential savings range (for display)
    required String savingsRange,

    /// Implementation time required
    required String timeToImplement,

    /// Whether this strategy is recommended for most users
    @Default(false) bool isRecommended,

    /// Whether this strategy is suitable for beginners
    @Default(true) bool isBeginner,

    /// List of pros for this strategy
    required List<String> pros,

    /// List of cons for this strategy
    required List<String> cons,

    /// Requirements to implement this strategy
    required List<String> requirements,

    /// Step-by-step implementation guide
    required List<String> implementationSteps,

    /// Related strategy IDs that work well together
    @Default([]) List<String> relatedStrategies,

    /// Tags for search and filtering
    @Default([]) List<String> tags,

    /// When strategy was last updated
    DateTime? lastUpdated,

    /// Whether strategy is currently active/enabled
    @Default(false) bool isActive,
  }) = _StrategyModel;

  /// Creates StrategyModel from JSON
  factory StrategyModel.fromJson(Map<String, dynamic> json) =>
      _$StrategyModelFromJson(json);
}

/// Calculated results for a strategy applied to a specific loan
@freezed
class StrategyResult with _$StrategyResult {
  const factory StrategyResult({
    /// Strategy that was applied
    required StrategyModel strategy,

    /// Original loan details
    required Map<String, dynamic> originalLoan,

    /// Modified loan details after strategy
    required Map<String, dynamic> modifiedLoan,

    /// Total interest saved
    required double interestSaved,

    /// Time saved in years
    required double timeSaved,

    /// Monthly payment change (positive = increase, negative = decrease)
    required double monthlyPaymentChange,

    /// Total cost of implementing strategy
    @Default(0.0) double implementationCost,

    /// Net savings (interest saved - implementation cost)
    required double netSavings,

    /// Break-even point in months
    double? breakEvenMonths,

    /// Whether this strategy is recommended for this loan
    required bool isRecommended,

    /// Recommendation reason/explanation
    String? recommendationReason,

    /// Risk level of implementing this strategy
    required StrategyRisk riskLevel,

    /// Additional parameters specific to strategy
    @Default({}) Map<String, dynamic> parameters,

    /// When this result was calculated
    required DateTime calculatedAt,
  }) = _StrategyResult;

  /// Creates StrategyResult from JSON
  factory StrategyResult.fromJson(Map<String, dynamic> json) =>
      _$StrategyResultFromJson(json);
}

/// Categories for organizing strategies
enum StrategyCategory {
  @JsonValue('prepayment')
  prepayment,

  @JsonValue('refinancing')
  refinancing,

  @JsonValue('structure_optimization')
  structureOptimization,

  @JsonValue('tax_planning')
  taxPlanning,

  @JsonValue('alternative_approach')
  alternativeApproach,

  @JsonValue('negotiation')
  negotiation,
}

/// Extension for StrategyCategory display
extension StrategyCategoryExtension on StrategyCategory {
  String get displayName {
    switch (this) {
      case StrategyCategory.prepayment:
        return 'Prepayment Strategies';
      case StrategyCategory.refinancing:
        return 'Refinancing Options';
      case StrategyCategory.structureOptimization:
        return 'Loan Structure';
      case StrategyCategory.taxPlanning:
        return 'Tax Planning';
      case StrategyCategory.alternativeApproach:
        return 'Alternative Approaches';
      case StrategyCategory.negotiation:
        return 'Negotiation Tactics';
    }
  }

  String get description {
    switch (this) {
      case StrategyCategory.prepayment:
        return 'Strategies involving extra payments to reduce principal';
      case StrategyCategory.refinancing:
        return 'Switching to better loan terms or lenders';
      case StrategyCategory.structureOptimization:
        return 'Optimizing loan structure and tenure';
      case StrategyCategory.taxPlanning:
        return 'Maximizing tax benefits and deductions';
      case StrategyCategory.alternativeApproach:
        return 'Non-traditional approaches to home buying';
      case StrategyCategory.negotiation:
        return 'Negotiating better terms with current lender';
    }
  }

  String get icon {
    switch (this) {
      case StrategyCategory.prepayment:
        return '💰';
      case StrategyCategory.refinancing:
        return '🔄';
      case StrategyCategory.structureOptimization:
        return '⚡';
      case StrategyCategory.taxPlanning:
        return '📊';
      case StrategyCategory.alternativeApproach:
        return '🎯';
      case StrategyCategory.negotiation:
        return '🤝';
    }
  }
}

/// Difficulty levels for strategy implementation
enum StrategyDifficulty {
  @JsonValue('easy')
  easy,

  @JsonValue('medium')
  medium,

  @JsonValue('hard')
  hard,
}

/// Extension for StrategyDifficulty display
extension StrategyDifficultyExtension on StrategyDifficulty {
  String get displayName {
    switch (this) {
      case StrategyDifficulty.easy:
        return 'Easy';
      case StrategyDifficulty.medium:
        return 'Medium';
      case StrategyDifficulty.hard:
        return 'Hard';
    }
  }

  String get description {
    switch (this) {
      case StrategyDifficulty.easy:
        return 'Can be implemented quickly with minimal effort';
      case StrategyDifficulty.medium:
        return 'Requires some planning and paperwork';
      case StrategyDifficulty.hard:
        return 'Complex implementation requiring expert guidance';
    }
  }

  String get color {
    switch (this) {
      case StrategyDifficulty.easy:
        return '#4CAF50'; // Green
      case StrategyDifficulty.medium:
        return '#FF8F00'; // Amber
      case StrategyDifficulty.hard:
        return '#D32F2F'; // Red
    }
  }

  int get level {
    switch (this) {
      case StrategyDifficulty.easy:
        return 1;
      case StrategyDifficulty.medium:
        return 2;
      case StrategyDifficulty.hard:
        return 3;
    }
  }
}

/// Risk levels for strategy implementation
enum StrategyRisk {
  @JsonValue('low')
  low,

  @JsonValue('medium')
  medium,

  @JsonValue('high')
  high,
}

/// Extension for StrategyRisk display
extension StrategyRiskExtension on StrategyRisk {
  String get displayName {
    switch (this) {
      case StrategyRisk.low:
        return 'Low Risk';
      case StrategyRisk.medium:
        return 'Medium Risk';
      case StrategyRisk.high:
        return 'High Risk';
    }
  }

  String get description {
    switch (this) {
      case StrategyRisk.low:
        return 'Minimal risk with high probability of success';
      case StrategyRisk.medium:
        return 'Moderate risk requiring careful consideration';
      case StrategyRisk.high:
        return 'High risk strategy requiring expert evaluation';
    }
  }

  String get color {
    switch (this) {
      case StrategyRisk.low:
        return '#4CAF50'; // Green
      case StrategyRisk.medium:
        return '#FF8F00'; // Amber
      case StrategyRisk.high:
        return '#D32F2F'; // Red
    }
  }
}

/// Extension on StrategyModel for utility methods
extension StrategyModelExtension on StrategyModel {
  /// Checks if strategy is suitable for a specific loan amount
  bool isSuitableForAmount(double loanAmount) {
    // Different strategies have different minimum loan amounts
    switch (category) {
      case StrategyCategory.refinancing:
        return loanAmount >= 1000000; // ₹10 lakhs minimum for refinancing
      case StrategyCategory.prepayment:
        return loanAmount >= 500000; // ₹5 lakhs minimum
      case StrategyCategory.taxPlanning:
        return loanAmount >= 2000000; // ₹20 lakhs for meaningful tax benefits
      default:
        return true; // Most strategies work for any amount
    }
  }

  /// Checks if strategy is suitable for a specific tenure
  bool isSuitableForTenure(int tenureYears) {
    switch (category) {
      case StrategyCategory.prepayment:
        return tenureYears >= 10; // Prepayment more beneficial for longer tenures
      case StrategyCategory.structureOptimization:
        return tenureYears >= 15; // Structure changes need sufficient time
      default:
        return true;
    }
  }

  /// Gets implementation priority (1 = highest priority)
  int get priority {
    if (isRecommended && isBeginner) return 1;
    if (isRecommended) return 2;
    if (isBeginner) return 3;
    return 4;
  }

  /// Gets estimated implementation effort (1-10 scale)
  int get effortScore {
    switch (difficulty) {
      case StrategyDifficulty.easy:
        return 2;
      case StrategyDifficulty.medium:
        return 5;
      case StrategyDifficulty.hard:
        return 8;
    }
  }

  /// Checks if strategy has been recently updated
  bool get isRecent {
    if (lastUpdated == null) return false;
    final daysSince = DateTime.now().difference(lastUpdated!).inDays;
    return daysSince <= 90; // Consider recent if updated within 3 months
  }

  /// Gets search keywords for this strategy
  List<String> get searchKeywords {
    final keywords = <String>[];
    keywords.addAll(title.toLowerCase().split(' '));
    keywords.addAll(description.toLowerCase().split(' '));
    keywords.addAll(tags.map((tag) => tag.toLowerCase()));
    keywords.add(category.displayName.toLowerCase());
    keywords.add(difficulty.displayName.toLowerCase());
    return keywords.where((keyword) => keyword.length > 2).toList();
  }
}

/// Extension on StrategyResult for analysis
extension StrategyResultExtension on StrategyResult {
  /// Gets ROI (Return on Investment) percentage
  double get roi {
    if (implementationCost <= 0) return double.infinity;
    return (netSavings / implementationCost) * 100;
  }

  /// Gets savings per month
  double get monthlySavings {
    if (timeSaved <= 0) return 0.0;
    return interestSaved / (timeSaved * 12);
  }

  /// Gets effectiveness score (0-100)
  int get effectivenessScore {
    final savingsScore = (netSavings / 100000).clamp(0, 50).round(); // Max 50 for ₹5L+ savings
    final timeScore = (timeSaved * 2).clamp(0, 30).round(); // Max 30 for 15+ years saved
    final riskPenalty = riskLevel == StrategyRisk.high ? 20 : (riskLevel == StrategyRisk.medium ? 10 : 0);
    
    return (savingsScore + timeScore - riskPenalty).clamp(0, 100);
  }

  /// Checks if strategy provides good value
  bool get isGoodValue {
    return netSavings > implementationCost * 5 && // At least 5x return
           riskLevel != StrategyRisk.high;
  }

  /// Gets recommendation strength (1-5 stars)
  int get recommendationStrength {
    if (!isRecommended) return 1;
    
    final score = effectivenessScore;
    if (score >= 80) return 5;
    if (score >= 60) return 4;
    if (score >= 40) return 3;
    if (score >= 20) return 2;
    return 1;
  }
}