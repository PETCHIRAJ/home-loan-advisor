import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/loan_provider.dart';
import '../../providers/settings_provider.dart';
import 'dart:async';

/// Calculator screen for EMI calculations and loan analysis with Riverpod
/// 
/// Features:
/// - Loan amount, interest rate, and tenure input with reactive updates
/// - Real-time EMI calculation using Riverpod state management
/// - Total amount and interest breakdown with computed providers
/// - Indian currency formatting
/// - Input validation and error handling
/// - Automatic state persistence across app restarts
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  
  Timer? _debounceTimer;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromState();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  /// Initialize form controllers from current loan state
  Future<void> _initializeFromState() async {
    final loanState = ref.read(loanNotifierProvider);
    
    await loanState.when(
      data: (loan) async {
        if (mounted) {
          _loanAmountController.text = (loan.loanAmount / 100000).toStringAsFixed(0);
          _interestRateController.text = loan.annualInterestRate.toString();
          _tenureController.text = loan.tenureYears.toString();
          
          setState(() {
            _isInitializing = false;
          });
        }
      },
      loading: () async {
        // Wait for load to complete
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) _initializeFromState();
      },
      error: (_, __) async {
        // Use defaults on error
        if (mounted) {
          _loanAmountController.text = '30';
          _interestRateController.text = '8.5';
          _tenureController.text = '20';
          
          setState(() {
            _isInitializing = false;
          });
        }
      },
    );
  }
  
  /// Debounced update for reactive state changes
  void _debouncedUpdate(VoidCallback updateFunction) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && _formKey.currentState?.validate() == true) {
        updateFunction();
      }
    });
  }

  /// Reset calculator to default values
  void _resetCalculator() {
    ref.read(loanNotifierProvider.notifier).resetLoan();
    
    _loanAmountController.text = '30';
    _interestRateController.text = '8.5';
    _tenureController.text = '20';
  }

  /// Load demo data for quick testing
  void _loadDemoData() {
    ref.read(loanNotifierProvider.notifier).loadDemoData();
    
    // Update controllers to reflect demo data
    _loanAmountController.text = '50';
    _interestRateController.text = '8.75';
    _tenureController.text = '25';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loanAsync = ref.watch(loanNotifierProvider);
    final emi = ref.watch(monthlyEMIProvider);
    final totalAmount = ref.watch(totalAmountProvider);
    final totalInterest = ref.watch(totalInterestProvider);
    final isValid = ref.watch(isLoanValidProvider);
    final hapticEnabled = ref.watch(hapticFeedbackEnabledProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Calculator'),
        actions: [
          IconButton(
            onPressed: () {
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }
              _loadDemoData();
            },
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Load Demo Data',
          ),
          IconButton(
            onPressed: () {
              if (hapticEnabled) {
                HapticFeedback.lightImpact();
              }
              _resetCalculator();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Calculator',
          ),
        ],
      ),
      body: loanAsync.when(
        data: (loan) => _buildContent(theme, loan, emi, totalAmount, totalInterest, isValid),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading loan data',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(loanNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    loan,
    double emi,
    double totalAmount,
    double totalInterest,
    bool isValid,
  ) {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            _buildInputSection(theme),
            
            const SizedBox(height: 24),
            
            // Results Section
            if (isValid && emi > 0) ...[
              _buildResultsSection(theme, emi),
              const SizedBox(height: 24),
              _buildBreakdownSection(theme, loan, emi, totalAmount, totalInterest),
            ] else if (!isValid) ...[
              _buildValidationErrorSection(theme),
            ],
            
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(theme),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Loan Amount Input
            TextFormField(
              controller: _loanAmountController,
              decoration: InputDecoration(
                labelText: 'Loan Amount',
                prefixText: '₹ ',
                suffixText: 'lakhs',
                helperText: 'Enter amount in lakhs (e.g., 30 for ₹30,00,000)',
                prefixIcon: const Icon(Icons.currency_rupee),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter loan amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                if (amount < 1) {
                  return 'Minimum loan amount is ₹1 lakh';
                }
                if (amount > 1000) {
                  return 'Maximum loan amount is ₹1000 lakhs';
                }
                return null;
              },
              onChanged: (value) {
                final amount = double.tryParse(value);
                if (amount != null && amount > 0) {
                  _debouncedUpdate(() {
                    ref.read(loanNotifierProvider.notifier)
                        .updateLoanAmount(amount * 100000); // Convert lakhs to rupees
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Interest Rate Input
            TextFormField(
              controller: _interestRateController,
              decoration: const InputDecoration(
                labelText: 'Interest Rate',
                suffixText: '% per annum',
                helperText: 'Annual interest rate (e.g., 8.5)',
                prefixIcon: Icon(Icons.percent),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter interest rate';
                }
                final rate = double.tryParse(value);
                if (rate == null || rate <= 0) {
                  return 'Please enter a valid rate';
                }
                if (rate > 30) {
                  return 'Interest rate seems too high (max 30%)';
                }
                return null;
              },
              onChanged: (value) {
                final rate = double.tryParse(value);
                if (rate != null && rate > 0) {
                  _debouncedUpdate(() {
                    ref.read(loanNotifierProvider.notifier)
                        .updateInterestRate(rate);
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Tenure Input
            TextFormField(
              controller: _tenureController,
              decoration: const InputDecoration(
                labelText: 'Loan Tenure',
                suffixText: 'years',
                helperText: 'Loan period in years (5-30 years)',
                prefixIcon: Icon(Icons.schedule),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter loan tenure';
                }
                final tenure = int.tryParse(value);
                if (tenure == null || tenure <= 0) {
                  return 'Please enter a valid tenure';
                }
                if (tenure < 5 || tenure > 50) {
                  return 'Tenure should be between 5-50 years';
                }
                return null;
              },
              onChanged: (value) {
                final tenure = int.tryParse(value);
                if (tenure != null && tenure > 0) {
                  _debouncedUpdate(() {
                    ref.read(loanNotifierProvider.notifier)
                        .updateTenure(tenure);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(ThemeData theme, double emi) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primaryContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.payments,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Monthly EMI',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                CurrencyFormatter.formatCurrency(emi),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'per month',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownSection(
    ThemeData theme,
    loan,
    double emi,
    double totalAmount,
    double totalInterest,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Breakdown',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildBreakdownRow(
              theme,
              'Principal Amount',
              CurrencyFormatter.formatCurrencyCompact(loan.loanAmount),
              theme.colorScheme.primary,
              Icons.account_balance,
            ),
            
            const SizedBox(height: 12),
            
            _buildBreakdownRow(
              theme,
              'Total Interest',
              CurrencyFormatter.formatCurrencyCompact(totalInterest),
              theme.colorScheme.error,
              Icons.trending_up,
            ),
            
            const SizedBox(height: 12),
            
            _buildBreakdownRow(
              theme,
              'Total Amount',
              CurrencyFormatter.formatCurrencyCompact(totalAmount),
              theme.colorScheme.secondary,
              Icons.payments,
            ),
            
            const SizedBox(height: 16),
            
            // Visual representation
            _buildAmountVisualization(theme, loan.loanAmount, totalAmount, totalInterest),
            
            const SizedBox(height: 16),
            
            // Additional metrics
            _buildAdditionalMetrics(theme, loan, emi),
            
            const SizedBox(height: 16),
            
            // Risk assessment
            _buildRiskAssessment(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(
    ThemeData theme,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountVisualization(
    ThemeData theme,
    double principal,
    double totalAmount,
    double totalInterest,
  ) {
    final principalRatio = principal / totalAmount;
    final interestRatio = totalInterest / totalAmount;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount Composition',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                Expanded(
                  flex: (principalRatio * 100).round(),
                  child: Container(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  flex: (interestRatio * 100).round(),
                  child: Container(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Principal (${(principalRatio * 100).toStringAsFixed(1)}%)',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Interest (${(interestRatio * 100).toStringAsFixed(1)}%)',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalMetrics(ThemeData theme, loan, double emi) {
    final monthlyInterest = (loan.loanAmount * loan.annualInterestRate / 100) / 12;
    final monthlyPrincipal = emi - monthlyInterest;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'First Month Breakdown:',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Principal Component:',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                CurrencyFormatter.formatCurrency(monthlyPrincipal),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interest Component:',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                CurrencyFormatter.formatCurrency(monthlyInterest),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAssessment(ThemeData theme) {
    final riskLevel = ref.watch(loanRiskLevelProvider);
    final isAffordable = ref.watch(isLoanAffordableProvider);
    final ltvRatio = ref.watch(ltvRatioProvider);
    final emiToIncome = ref.watch(emiToIncomeRatioProvider);
    
    Color riskColor;
    IconData riskIcon;
    
    switch (riskLevel) {
      case LoanRiskLevel.low:
        riskColor = theme.colorScheme.tertiary;
        riskIcon = Icons.check_circle;
        break;
      case LoanRiskLevel.medium:
        riskColor = Colors.orange;
        riskIcon = Icons.warning;
        break;
      case LoanRiskLevel.high:
        riskColor = theme.colorScheme.error;
        riskIcon = Icons.error;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: riskColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(riskIcon, color: riskColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Risk Assessment: ${riskLevel.displayName}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: riskColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            riskLevel.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: riskColor.withOpacity(0.8),
            ),
          ),
          
          if (ltvRatio != null || emiToIncome != null) ...[
            const SizedBox(height: 8),
            
            if (ltvRatio != null)
              Text(
                'Loan-to-Value Ratio: ${ltvRatio.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall,
              ),
            
            if (emiToIncome != null)
              Text(
                'EMI-to-Income Ratio: ${emiToIncome.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildValidationErrorSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.warning_amber,
              size: 48,
              color: theme.colorScheme.error,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Invalid Loan Parameters',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Please check your inputs and ensure all values are within valid ranges.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    // Navigate to strategies
                    DefaultTabController.of(context)?.animateTo(2);
                  },
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('View Strategies'),
                ),
                
                FilledButton.tonalIcon(
                  onPressed: () {
                    // Navigate to progress tracking
                    DefaultTabController.of(context)?.animateTo(3);
                  },
                  icon: const Icon(Icons.track_changes),
                  label: const Text('Track Progress'),
                ),
                
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Export functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export functionality coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}