import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';
import '../../core/services/export_service.dart';
import '../../providers/loan_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/loan_model.dart';
import '../../widgets/charts/emi_breakdown_chart.dart';
import 'amortization_schedule_screen.dart';
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
  final _monthlyIncomeController = TextEditingController();
  final _ageController = TextEditingController();
  final _monthsPaidController = TextEditingController();
  
  Timer? _debounceTimer;
  bool _isInitializing = true;
  bool _isUpdateInProgress = false;
  final String _loanStatus = 'planning'; // 'planning' or 'taken'
  
  // Slider values
  double _loanAmountSlider = 30.0;
  double _interestRateSlider = 8.5;
  double _tenureSlider = 20.0;
  final double _monthsPaidSlider = 0.0;

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
    _monthlyIncomeController.dispose();
    _ageController.dispose();
    _monthsPaidController.dispose();
    super.dispose();
  }

  /// Initialize form controllers from current loan state
  Future<void> _initializeFromState() async {
    final loanState = ref.read(loanNotifierProvider);
    
    await loanState.when(
      data: (loan) async {
        if (mounted) {
          final loanAmountInLakhs = loan.loanAmount / 100000;
          _loanAmountController.text = _formatIndianCurrency((loan.loanAmount).toString());
          _interestRateController.text = loan.annualInterestRate.toString();
          _tenureController.text = loan.tenureYears.toString();
          _monthlyIncomeController.text = '1,00,000';
          _ageController.text = '30';
          _monthsPaidController.text = '0';
          
          _loanAmountSlider = loanAmountInLakhs.clamp(5.0, 500.0);
          _interestRateSlider = loan.annualInterestRate.clamp(6.0, 15.0);
          _tenureSlider = loan.tenureYears.toDouble().clamp(5.0, 30.0);
          
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
          _loanAmountController.text = '30,00,000';
          _interestRateController.text = '8.5';
          _tenureController.text = '20';
          _monthlyIncomeController.text = '1,00,000';
          _ageController.text = '30';
          _monthsPaidController.text = '0';
          
          _loanAmountSlider = 30.0;
          _interestRateSlider = 8.5;
          _tenureSlider = 20.0;
          
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
    _loanAmountController.text = '50,00,000';
    _interestRateController.text = '8.75';
    _tenureController.text = '25';
  }
  
  /// Format Indian currency with lakhs notation
  String _formatIndianCurrency(String value) {
    final num = int.tryParse(value.replaceAll(',', '')) ?? 0;
    if (num == 0) return '';
    return num.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+\d$)'),
      (Match match) => '${match[1]},')
      .replaceAllMapped(
        RegExp(r'(\d+),(\d{2}),(\d{3})'),
        (Match match) => '${match[1]},${match[2]},${match[3]}');
  }
  
  /// Update calculations with loading state
  Future<void> _updateCalculations() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isUpdateInProgress = true;
    });
    
    // Simulate brief loading for better UX
    await Future.delayed(const Duration(milliseconds: 800));
    
    final amount = double.tryParse(_loanAmountController.text.replaceAll(',', '')) ?? 0;
    final rate = double.tryParse(_interestRateController.text) ?? 0;
    final tenure = int.tryParse(_tenureController.text) ?? 0;
    
    if (amount > 0 && rate > 0 && tenure > 0) {
      ref.read(loanNotifierProvider.notifier).updateLoan(
        loanAmount: amount,
        annualInterestRate: rate,
        tenureYears: tenure,
      );
    }
    
    setState(() {
      _isUpdateInProgress = false;
    });
  }

  /// Build smart header with loan summary
  Widget _buildSmartHeader(ThemeData theme, AsyncValue loanAsync) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
          left: BorderSide(color: theme.colorScheme.primary, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: loanAsync.when(
                data: (loan) {
                  final amountInLakhs = (loan.loanAmount / 100000).round();
                  final status = _loanStatus == 'taken' ? 'Active' : 'Planned';
                  return Text(
                    '₹${amountInLakhs}L @ ${loan.annualInterestRate}% • ${loan.tenureYears}yr ($status)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
                loading: () => Text(
                  'Loading loan data...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                error: (_, __) => Text(
                  'No loan data',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.settings,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
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
      body: Column(
        children: [
          // Smart Header
          _buildSmartHeader(theme, loanAsync),
          
          // Main Content
          Expanded(
            child: loanAsync.when(
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
          ),
        ],
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
              _buildEMIResultsHeroSection(theme, emi, loan),
              const SizedBox(height: 24),
              _buildVisualBreakdownSection(theme, loan, emi, totalAmount, totalInterest),
              const SizedBox(height: 24),
              _buildPaymentScheduleSection(theme, loan),
              const SizedBox(height: 24),
              _buildExportDataSection(theme, loan),
            ] else if (!isValid) ...[
              _buildValidationErrorSection(theme),
            ],
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(ThemeData theme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header with Icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '💰',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'LOAN DETAILS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Loan Amount Input
            _buildLoanInputField(
              controller: _loanAmountController,
              label: 'Loan Amount',
              prefixText: '₹',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid loan amount (minimum ₹1,00,000)';
                }
                final amount = int.tryParse(value.replaceAll(',', ''));
                if (amount == null || amount < 100000) {
                  return 'Please enter a valid loan amount (minimum ₹1,00,000)';
                }
                return null;
              },
              onChanged: (value) {
                // Format as user types
                final formatted = _formatIndianCurrency(value.replaceAll(',', ''));
                if (formatted != value && formatted.isNotEmpty) {
                  _loanAmountController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
                
                final amount = double.tryParse(value.replaceAll(',', ''));
                if (amount != null && amount > 0) {
                  setState(() {
                    _loanAmountSlider = (amount / 100000).clamp(5.0, 500.0);
                  });
                }
              },
              sliderValue: _loanAmountSlider,
              sliderMin: 5.0,
              sliderMax: 500.0,
              sliderDivisions: 99,
              sliderLabels: ['₹5L', '₹5Cr'],
              onSliderChanged: (value) {
                setState(() {
                  _loanAmountSlider = value;
                  final amount = (value * 100000).round();
                  _loanAmountController.text = _formatIndianCurrency(amount.toString());
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Interest Rate Input
            _buildLoanInputField(
              controller: _interestRateController,
              label: 'Interest Rate',
              suffixText: '% per year',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Interest rate should be between 1% and 20%';
                }
                final rate = double.tryParse(value);
                if (rate == null || rate < 1 || rate > 20) {
                  return 'Interest rate should be between 1% and 20%';
                }
                return null;
              },
              onChanged: (value) {
                final rate = double.tryParse(value);
                if (rate != null && rate >= 6 && rate <= 15) {
                  setState(() {
                    _interestRateSlider = rate;
                  });
                }
              },
              sliderValue: _interestRateSlider,
              sliderMin: 6.0,
              sliderMax: 15.0,
              sliderDivisions: 90,
              sliderLabels: ['6%', '15%'],
              onSliderChanged: (value) {
                setState(() {
                  _interestRateSlider = value;
                  _interestRateController.text = value.toStringAsFixed(1);
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Tenure Input
            _buildLoanInputField(
              controller: _tenureController,
              label: 'Loan Tenure',
              suffixText: 'years',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Loan tenure should be between 1 and 30 years';
                }
                final tenure = int.tryParse(value);
                if (tenure == null || tenure < 1 || tenure > 30) {
                  return 'Loan tenure should be between 1 and 30 years';
                }
                return null;
              },
              onChanged: (value) {
                final tenure = int.tryParse(value);
                if (tenure != null && tenure >= 5 && tenure <= 30) {
                  setState(() {
                    _tenureSlider = tenure.toDouble();
                  });
                }
              },
              sliderValue: _tenureSlider,
              sliderMin: 5.0,
              sliderMax: 30.0,
              sliderDivisions: 25,
              sliderLabels: ['5 years', '30 years'],
              onSliderChanged: (value) {
                setState(() {
                  _tenureSlider = value;
                  _tenureController.text = value.round().toString();
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Monthly Income (Optional)
            _buildOptionalField(
              controller: _monthlyIncomeController,
              label: 'Monthly Income',
              prefixText: '₹',
              isOptional: true,
              onChanged: (value) {
                final formatted = _formatIndianCurrency(value.replaceAll(',', ''));
                if (formatted != value && formatted.isNotEmpty) {
                  _monthlyIncomeController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Age (Optional)
            _buildOptionalField(
              controller: _ageController,
              label: 'Age',
              suffixText: 'years',
              keyboardType: TextInputType.number,
              isOptional: true,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final age = int.tryParse(value);
                  if (age == null || age < 18 || age > 65) {
                    return 'Age should be between 18-65 years';
                  }
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Loan Status Radio Buttons
            _buildLoanStatusSection(theme),
            
            const SizedBox(height: 24),
            
            // Months Already Paid (conditional)
            if (_loanStatus == 'taken') ...[
              _buildMonthsPaidField(theme),
              const SizedBox(height: 24),
            ],
            
            // Update Calculations Button
            _buildUpdateButton(theme),
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
            
            // EMI Breakdown Chart - Reduced height to fit properly
            const EMIBreakdownChart(
              height: 180, // Reduced from 250 to prevent overflow
              showMonths: 12, // Show first year breakdown
            ),
            
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
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
    String riskDisplayName;
    String riskDescription;
    
    if (riskLevel == LoanRiskLevel.low) {
      riskColor = theme.colorScheme.tertiary;
      riskIcon = Icons.check_circle;
      riskDisplayName = 'Low Risk';
      riskDescription = 'Comfortable loan parameters';
    } else if (riskLevel == LoanRiskLevel.medium) {
      riskColor = Colors.orange;
      riskIcon = Icons.warning;
      riskDisplayName = 'Medium Risk';
      riskDescription = 'Moderate risk, manageable with discipline';
    } else {
      riskColor = theme.colorScheme.error;
      riskIcon = Icons.error;
      riskDisplayName = 'High Risk';
      riskDescription = 'High risk, consider reducing loan amount or tenure';
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
                'Risk Assessment: $riskDisplayName',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: riskColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            riskDescription,
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
                FilledButton.icon(
                  onPressed: () {
                    // Navigate to amortization schedule
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AmortizationScheduleScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Payment Schedule'),
                ),
                
                const SizedBox(width: 8),
                
                FilledButton.tonalIcon(
                  onPressed: () {
                    // Navigate to strategies screen
                    Navigator.of(context).pushNamed('/strategies');
                  },
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('View Strategies'),
                ),
                
                FilledButton.tonalIcon(
                  onPressed: () {
                    // Navigate to progress screen
                    Navigator.of(context).pushNamed('/progress');
                  },
                  icon: const Icon(Icons.track_changes),
                  label: const Text('Track Progress'),
                ),
                
                OutlinedButton.icon(
                  onPressed: () async {
                    final loanAsync = ref.read(loanNotifierProvider);
                    
                    await loanAsync.when(
                      data: (loan) async {
                        // Show export options
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Quick Export'),
                            content: const Text('Export your loan summary as:'),
                            actions: [
                              TextButton.icon(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  try {
                                    // Generate basic schedule for export
                                    final schedule = LoanCalculations.generateAmortizationSchedule(
                                      loanAmount: loan.loanAmount,
                                      annualInterestRate: loan.annualInterestRate,
                                      tenureYears: loan.tenureYears,
                                      numberOfMonths: loan.totalMonths,
                                    );
                                    
                                    final filePath = await ExportService.exportToPDF(
                                      loan: loan,
                                      schedule: schedule,
                                      includeCharts: true,
                                    );
                                    
                                    await ExportService.shareFile(
                                      filePath: filePath,
                                      subject: 'Home Loan Summary Report',
                                      text: 'Here is your loan calculation summary.',
                                    );
                                    
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Report exported successfully!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Export failed: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text('PDF Report'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please wait for loan data to load...'),
                          ),
                        );
                      },
                      error: (error, stack) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
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
  
  /// Build EMI Results Hero Section matching mockup
  Widget _buildEMIResultsHeroSection(ThemeData theme, double emi, loan) {
    final monthlyIncome = double.tryParse(_monthlyIncomeController.text.replaceAll(',', '')) ?? 0;
    final emiToIncomeRatio = monthlyIncome > 0 ? (emi / monthlyIncome) * 100 : 0;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('📈', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Text(
                  'CALCULATION RESULTS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // EMI Hero Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Monthly EMI',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.formatCurrency(emi),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Results Grid
            _buildResultsGrid(theme, loan, emi, emiToIncomeRatio),
          ],
        ),
      ),
    );
  }
  
  /// Build results grid
  Widget _buildResultsGrid(ThemeData theme, loan, double emi, double emiToIncomeRatio) {
    final totalAmount = emi * loan.tenureYears * 12;
    final totalInterest = totalAmount - loan.loanAmount;
    final interestPercentage = (totalInterest / loan.loanAmount) * 100;
    
    return Column(
      children: [
        _buildResultRow('Total Amount Payable', CurrencyFormatter.formatCurrency(totalAmount)),
        const SizedBox(height: 12),
        _buildResultRow('Total Interest', CurrencyFormatter.formatCurrency(totalInterest)),
        const SizedBox(height: 12),
        _buildResultRow('Interest Percentage', '${interestPercentage.toStringAsFixed(1)}%'),
        
        if (emiToIncomeRatio > 0) ...[
          const SizedBox(height: 12),
          _buildResultRow(
            'EMI/Income Ratio',
            '${emiToIncomeRatio.toStringAsFixed(0)}%',
            indicator: _getEMIRatioIndicator(emiToIncomeRatio),
          ),
        ],
      ],
    );
  }
  
  /// Build individual result row
  Widget _buildResultRow(String label, String value, {Widget? indicator}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (indicator != null) ...[
                const SizedBox(width: 8),
                indicator,
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  /// Get EMI ratio indicator
  Widget _getEMIRatioIndicator(double ratio) {
    if (ratio < 30) {
      return const Text('✓', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold));
    } else if (ratio <= 40) {
      return const Text('⚠️', style: TextStyle(fontWeight: FontWeight.bold));
    } else {
      return const Text('❌', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    }
  }
  
  /// Build Visual Breakdown Section
  Widget _buildVisualBreakdownSection(ThemeData theme, loan, double emi, double totalAmount, double totalInterest) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('📈', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Text(
                  'VISUAL BREAKDOWN',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Chart Toggle Buttons
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'Pie Chart',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Timeline',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Chart Container
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const EMIBreakdownChart(height: 280),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Principal', '₹${(loan.loanAmount / 100000).toFixed(1)}L', Colors.green),
                const SizedBox(width: 24),
                _buildLegendItem('Interest', '₹${(totalInterest / 100000).toFixed(1)}L', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build legend item
  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text('$label ($value)'),
      ],
    );
  }
  
  /// Build Payment Schedule Section
  Widget _buildPaymentScheduleSection(ThemeData theme, loan) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('📋', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Text(
                  'PAYMENT SCHEDULE',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Schedule Toggle Buttons
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'Yearly',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Monthly',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Quarterly',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Schedule Table Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Center(
                child: Text(
                  'Amortization Schedule\n(Interactive table will be implemented)',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build Export Data Section
  Widget _buildExportDataSection(ThemeData theme, loan) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('📄', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Text(
                  'EXPORT DATA',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Export Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('CSV export started! File will download shortly.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Text('📄', style: TextStyle(fontSize: 18)),
                    label: Text(
                      'CSV',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PDF export started! File will download shortly.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Text('📁', style: TextStyle(fontSize: 18)),
                    label: Text(
                      'PDF',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}