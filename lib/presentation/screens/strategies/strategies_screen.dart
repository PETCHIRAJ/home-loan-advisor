import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../providers/calculation_providers.dart';
import '../../../domain/entities/money_saving_strategy.dart';
import '../../../domain/entities/emi_result.dart';
import 'widgets/strategy_card.dart';
import 'widgets/strategy_details_sheet.dart';
import 'widgets/strategies_summary.dart';

class StrategiesScreen extends ConsumerStatefulWidget {
  const StrategiesScreen({super.key});

  @override
  ConsumerState<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends ConsumerState<StrategiesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  String _selectedFilter = 'All';
  
  final List<String> _filters = ['All', 'Low Effort', 'High Impact', 'Quick Win'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Load strategies when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStrategies();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check and reload strategies when dependencies change (e.g., coming back to this tab)
    _loadStrategies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadStrategies() {
    final emiCalculation = ref.read(emiCalculationProvider);
    
    if (emiCalculation.hasValue && emiCalculation.value != null) {
      ref.read(moneySavingStrategiesProvider.notifier).loadStrategies();
      _animationController.forward();
    } else {
      // Clear strategies if EMI is not available
      ref.read(moneySavingStrategiesProvider.notifier).clearStrategies();
    }
  }

  void _showStrategyDetails(PersonalizedStrategyResult strategy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StrategyDetailsSheet(strategy: strategy),
    );
  }

  List<PersonalizedStrategyResult> _filterStrategies(
    List<PersonalizedStrategyResult> strategies) {
    if (_selectedFilter == 'All') return strategies;
    
    // This would need strategy metadata to filter properly
    // For now, return all strategies
    return strategies;
  }

  @override
  Widget build(BuildContext context) {
    final strategiesAsync = ref.watch(moneySavingStrategiesProvider);
    final emiCalculation = ref.watch(emiCalculationProvider);

    // Listen for changes in EMI calculation and reload strategies
    ref.listen<AsyncValue<EMIResult?>>(emiCalculationProvider, (previous, next) {
      if (next.hasValue && next.value != null && 
          (previous?.value == null || previous?.hasValue != true)) {
        _loadStrategies();
      }
    });

    return AppScaffold(
      title: 'Money-Saving Strategies',
      body: emiCalculation.when(
        data: (result) {
          if (result == null) {
            return _buildEmptyState();
          }
          
          return strategiesAsync.when(
            data: (strategies) {
              if (strategies.isEmpty) {
                return _buildLoadingState();
              }
              return _buildStrategiesContent(strategies);
            },
            loading: () => _buildLoadingState(),
            error: (error, stack) {
              return _buildErrorState(error.toString());
            },
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, stack) {
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Calculate EMI First',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Complete your loan calculation to get personalized money-saving strategies',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.calculate),
            label: const Text('Go to Calculator'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Calculating personalized strategies...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Strategies',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loadStrategies,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategiesContent(List<PersonalizedStrategyResult> strategies) {
    final filteredStrategies = _filterStrategies(strategies);
    final totalPotentialSavings = strategies.fold<double>(
      0, (sum, strategy) => sum + strategy.personalizedSavings);

    return FadeTransition(
      opacity: _fadeInAnimation,
      child: CustomScrollView(
        slivers: [
          // Summary Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StrategiesSummary(
                totalStrategies: strategies.length,
                totalPotentialSavings: totalPotentialSavings,
                recommendedStrategies: strategies
                    .where((s) => s.feasibility == StrategyFeasibility.highlyRecommended)
                    .length,
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Strategy Cards
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final strategy = filteredStrategies[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: index == filteredStrategies.length - 1 ? 16 : 8,
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (index * 0.1).clamp(0.0, 0.8),
                        ((index * 0.1) + 0.2).clamp(0.2, 1.0),
                        curve: Curves.easeOutCubic,
                      ),
                    )),
                    child: StrategyCard(
                      strategy: strategy,
                      onTap: () => _showStrategyDetails(strategy),
                    ),
                  ),
                );
              },
              childCount: filteredStrategies.length,
            ),
          ),
        ],
      ),
    );
  }
}
