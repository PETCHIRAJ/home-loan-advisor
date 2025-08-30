import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../domain/entities/emi_result.dart';
import '../../providers/scenario_comparison_providers.dart';
import '../../widgets/common/app_scaffold.dart';
import 'widgets/scenario_comparison_header.dart';
import 'widgets/scenario_cards_view.dart';
import 'widgets/comparison_charts.dart';
import 'widgets/scenario_metrics_summary.dart';

class ScenarioComparisonScreen extends ConsumerStatefulWidget {
  final LoanParameters baseParameters;
  final EMIResult baseResult;

  const ScenarioComparisonScreen({
    super.key,
    required this.baseParameters,
    required this.baseResult,
  });

  @override
  ConsumerState<ScenarioComparisonScreen> createState() => _ScenarioComparisonScreenState();
}

class _ScenarioComparisonScreenState extends ConsumerState<ScenarioComparisonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitialized = false;

  final List<String> _tabLabels = [
    'Scenarios',
    'Charts',
    'Metrics',
  ];

  final List<IconData> _tabIcons = [
    Icons.view_column,
    Icons.analytics,
    Icons.assessment,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeComparison() async {
    if (!_isInitialized) {
      await ref
          .read(scenarioComparisonProvider.notifier)
          .initializeComparison(widget.baseParameters, widget.baseResult);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scenarioComparisonProvider);

    // Initialize comparison on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeComparison();
    });

    return AppScaffold(
      title: 'Scenario Comparison',
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            switch (value) {
              case 'reset':
                await ref.read(scenarioComparisonProvider.notifier).resetToDefaults();
                break;
              case 'toggle_view':
                ref.read(scenarioComparisonProvider.notifier).toggleShowPresetsOnly();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'reset',
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('Reset to Defaults'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_view',
              child: Row(
                children: [
                  Icon(state.showPresetsOnly ? Icons.visibility : Icons.visibility_off),
                  const SizedBox(width: 8),
                  Text(state.showPresetsOnly ? 'Show All' : 'Show Presets Only'),
                ],
              ),
            ),
          ],
        ),
      ],
      body: Column(
        children: [
          // Header with summary
          ScenarioComparisonHeader(
            isLoading: state.isLoading,
            error: state.error,
            onClearError: () => ref.read(scenarioComparisonProvider.notifier).clearError(),
          ),

          // Tab Bar
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: List.generate(
                _tabLabels.length,
                (index) => Tab(
                  icon: Icon(_tabIcons[index], size: 20),
                  text: _tabLabels[index],
                ),
              ),
              labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Scenarios Tab
                _buildScenariosTab(state),

                // Charts Tab
                _buildChartsTab(state),

                // Metrics Tab
                _buildMetricsTab(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenariosTab(ScenarioComparisonState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Calculating scenarios...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading scenarios',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _initializeComparison(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.comparison == null) {
      return const Center(
        child: Text('No comparison data available'),
      );
    }

    return const ScenarioCardsView();
  }

  Widget _buildChartsTab(ScenarioComparisonState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.comparison == null || state.comparison!.scenariosWithResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No scenarios to compare',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Enable scenarios from the Scenarios tab to see charts',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return const ComparisonCharts();
  }

  Widget _buildMetricsTab(ScenarioComparisonState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.comparison == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No metrics available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return const ScenarioMetricsSummary();
  }
}