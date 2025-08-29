import 'package:flutter/material.dart';
import '../../services/indian_strategies_service.dart';
import '../../widgets/common/unified_header.dart';

/// Screen displaying all 7 Indian home loan strategies with personalized calculations
class IndianStrategiesScreen extends StatelessWidget {
  final double loanAmount;
  final double interestRate;
  final int tenureYears;

  const IndianStrategiesScreen({
    Key? key,
    required this.loanAmount,
    required this.interestRate,
    required this.tenureYears,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strategiesService = IndianStrategiesService.instance;
    final strategies = strategiesService.getPrioritizedStrategies(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenureYears,
    );

    return Scaffold(
      body: Column(
        children: [
          UnifiedHeader(
            title: '7 Money-Saving Strategies',
            subtitle: 'Personalized for your ₹${strategiesService.formatLakhs(loanAmount)}L loan',
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: strategies.length,
              itemBuilder: (context, index) {
                final strategy = strategies[index];
                return _StrategyCard(strategy: strategy);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final Map<String, dynamic> strategy;

  const _StrategyCard({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final impact = strategy['calculatedImpact'] as Map<String, dynamic>?;
    final interestSaved = impact?['interestSaved'] as double? ?? 0.0;
    final priorityScore = strategy['prioritizationScore'] as int? ?? 0;
    final difficultyLevel = strategy['difficultyLevel'] as int? ?? 1;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with priority and difficulty
            Row(
              children: [
                Expanded(
                  child: Text(
                    strategy['title'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _PriorityBadge(score: priorityScore),
                const SizedBox(width: 8),
                _DifficultyBadge(level: difficultyLevel),
              ],
            ),
            const SizedBox(height: 12),
            
            // Hero savings number
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.savings, color: Colors.green[700], size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Save ₹${IndianStrategiesService.instance.formatLakhs(interestSaved)}L',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Short description
            Text(
              strategy['shortDescription'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            
            // Implementation time and action button
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  strategy['timeToImplement'] as String? ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _showStrategyDetails(context, strategy),
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStrategyDetails(BuildContext context, Map<String, dynamic> strategy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _StrategyDetailsSheet(strategy: strategy),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final int score;

  const _PriorityBadge({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    
    if (score >= 90) {
      color = Colors.red;
      label = 'HIGH';
    } else if (score >= 75) {
      color = Colors.orange;
      label = 'MED';
    } else {
      color = Colors.blue;
      label = 'LOW';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final int level;

  const _DifficultyBadge({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stars = '★' * level + '☆' * (5 - level);
    
    return Text(
      stars,
      style: TextStyle(
        color: Colors.amber[700],
        fontSize: 16,
      ),
    );
  }
}

class _StrategyDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> strategy;

  const _StrategyDetailsSheet({Key? key, required this.strategy}) : super(key: key);

  @override
  State<_StrategyDetailsSheet> createState() => _StrategyDetailsSheetState();
}

class _StrategyDetailsSheetState extends State<_StrategyDetailsSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.strategy['title'] as String,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'How To'),
              Tab(text: 'Scenarios'),
              Tab(text: 'Risks'),
              Tab(text: 'Combine'),
            ],
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(strategy: widget.strategy),
                _HowToTab(strategy: widget.strategy),
                _ScenariosTab(strategy: widget.strategy),
                _RisksTab(strategy: widget.strategy),
                _CombineTab(strategy: widget.strategy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> strategy;

  const _OverviewTab({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final impact = strategy['calculatedImpact'] as Map<String, dynamic>?;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Impact numbers
          if (impact != null) ...[
            _ImpactCard(impact: impact),
            const SizedBox(height: 16),
          ],
          
          // Detailed explanation
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strategy['detailedExplanation'] as String? ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final Map<String, dynamic> impact;

  const _ImpactCard({Key? key, required this.impact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final interestSaved = impact['interestSaved'] as double? ?? 0.0;
    final timeSaved = impact['timeSavedYears'] as double? ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.green[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '₹${IndianStrategiesService.instance.formatLakhs(interestSaved)}L',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Interest Saved',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              if (timeSaved > 0) ...[
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.green[300],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${timeSaved.toStringAsFixed(1)} yrs',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time Saved',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HowToTab extends StatelessWidget {
  final Map<String, dynamic> strategy;

  const _HowToTab({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = strategy['implementationGuide'] as List<dynamic>? ?? [];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return _StepCard(
          stepNumber: index + 1,
          stepContent: steps[index] as String,
        );
      },
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String stepContent;

  const _StepCard({
    Key? key,
    required this.stepNumber,
    required this.stepContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                stepContent,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenariosTab extends StatelessWidget {
  final Map<String, dynamic> strategy;

  const _ScenariosTab({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scenarios = strategy['scenarios'] as Map<String, dynamic>? ?? {};
    
    if (scenarios.isEmpty) {
      return const Center(
        child: Text('No scenarios available for this strategy'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (scenarios.containsKey('bestCase'))
          _ScenarioCard(
            title: 'Best Case',
            scenario: scenarios['bestCase'] as Map<String, dynamic>,
            color: Colors.green,
          ),
        const SizedBox(height: 12),
        
        if (scenarios.containsKey('typical'))
          _ScenarioCard(
            title: 'Typical',
            scenario: scenarios['typical'] as Map<String, dynamic>,
            color: Colors.blue,
          ),
        const SizedBox(height: 12),
        
        if (scenarios.containsKey('minimal'))
          _ScenarioCard(
            title: 'Minimal',
            scenario: scenarios['minimal'] as Map<String, dynamic>,
            color: Colors.orange,
          ),
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> scenario;
  final Color color;

  const _ScenarioCard({
    Key? key,
    required this.title,
    required this.scenario,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Text(
              scenario['description'] as String? ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            
            // Show key metrics
            ...scenario.entries
                .where((e) => e.key != 'description')
                .map((e) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatKey(e.key),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            _formatValue(e.key, e.value),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  String _formatKey(String key) {
    switch (key) {
      case 'interestSaved':
        return 'Interest Saved';
      case 'timeSaved':
        return 'Time Saved';
      case 'annualAmount':
        return 'Annual Amount';
      case 'monthlyExtra':
        return 'Monthly Extra';
      default:
        return key.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim();
    }
  }

  String _formatValue(String key, dynamic value) {
    if (key.contains('Amount') || key.contains('Saved')) {
      return '₹${IndianStrategiesService.instance.formatLakhs(value as double)}L';
    } else if (key.contains('Time')) {
      return '${(value as double).toStringAsFixed(1)} years';
    } else if (key.contains('Extra')) {
      return '₹${IndianStrategiesService.instance.formatINR(value as double)}';
    }
    return value.toString();
  }
}

class _RisksTab extends StatelessWidget {
  final Map<String, dynamic> strategy;

  const _RisksTab({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final riskAssessment = strategy['riskAssessment'] as Map<String, dynamic>? ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (riskAssessment.containsKey('financialRisks'))
            _RiskSection(
              title: 'Financial Risks',
              risks: riskAssessment['financialRisks'] as List<dynamic>,
              icon: Icons.account_balance_wallet,
              color: Colors.red,
            ),
          const SizedBox(height: 16),
          
          if (riskAssessment.containsKey('implementationChallenges'))
            _RiskSection(
              title: 'Implementation Challenges',
              risks: riskAssessment['implementationChallenges'] as List<dynamic>,
              icon: Icons.build,
              color: Colors.orange,
            ),
          const SizedBox(height: 16),
          
          if (riskAssessment.containsKey('marketTimingRisks'))
            _RiskSection(
              title: 'Market Timing Risks',
              risks: riskAssessment['marketTimingRisks'] as List<dynamic>,
              icon: Icons.trending_down,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class _RiskSection extends StatelessWidget {
  final String title;
  final List<dynamic> risks;
  final IconData icon;
  final Color color;

  const _RiskSection({
    Key? key,
    required this.title,
    required this.risks,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color[700], size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        ...risks.map((risk) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: color[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      risk as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _CombineTab extends StatelessWidget {
  final Map<String, dynamic> strategy;

  const _CombineTab({Key? key, required this.strategy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final combinationStrategy = strategy['combinationStrategy'] as Map<String, dynamic>? ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (combinationStrategy.containsKey('worksWellWith'))
            _CombinationSection(
              title: 'Works Well With',
              combinations: combinationStrategy['worksWellWith'] as List<dynamic>,
              icon: Icons.thumb_up,
              color: Colors.green,
            ),
          const SizedBox(height: 16),
          
          if (combinationStrategy.containsKey('avoidCombiningWith'))
            _CombinationSection(
              title: 'Avoid Combining With',
              combinations: combinationStrategy['avoidCombiningWith'] as List<dynamic>,
              icon: Icons.warning,
              color: Colors.red,
            ),
        ],
      ),
    );
  }
}

class _CombinationSection extends StatelessWidget {
  final String title;
  final List<dynamic> combinations;
  final IconData icon;
  final Color color;

  const _CombinationSection({
    Key? key,
    required this.title,
    required this.combinations,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (combinations.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color[700], size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        ...combinations.map((combination) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  combination as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )),
      ],
    );
  }
}