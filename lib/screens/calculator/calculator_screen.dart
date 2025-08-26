import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';

/// Calculator screen for EMI calculations and loan analysis
/// 
/// Features:
/// - Loan amount, interest rate, and tenure input
/// - Real-time EMI calculation
/// - Total amount and interest breakdown
/// - Indian currency formatting
/// - Input validation and error handling
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  
  double _loanAmount = 5000000; // Default ₹50 lakhs
  double _interestRate = 8.5; // Default 8.5%
  int _tenureYears = 20; // Default 20 years
  
  double? _emi;
  double? _totalAmount;
  double? _totalInterest;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    _loanAmountController.text = '50';
    _interestRateController.text = '8.5';
    _tenureController.text = '20';
    _calculateEMI();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _calculateEMI() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _emi = LoanCalculations.calculateEMI(
          loanAmount: _loanAmount,
          annualInterestRate: _interestRate,
          tenureYears: _tenureYears,
        );
        
        if (_emi != null) {
          _totalAmount = LoanCalculations.calculateTotalAmount(
            monthlyEMI: _emi!,
            tenureYears: _tenureYears,
          );
          
          _totalInterest = LoanCalculations.calculateTotalInterest(
            loanAmount: _loanAmount,
            monthlyEMI: _emi!,
            tenureYears: _tenureYears,
          );
        }
        
        _showResults = _emi != null && _emi! > 0;
      });
    }
  }

  void _resetCalculator() {
    setState(() {
      _loanAmountController.text = '50';
      _interestRateController.text = '8.5';
      _tenureController.text = '20';
      _loanAmount = 5000000;
      _interestRate = 8.5;
      _tenureYears = 20;
      _emi = null;
      _totalAmount = null;
      _totalInterest = null;
      _showResults = false;
    });
    _calculateEMI();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Calculator'),
        actions: [
          IconButton(
            onPressed: _resetCalculator,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Calculator',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Section
              _buildInputSection(theme),
              
              const SizedBox(height: 24),
              
              // Calculate Button
              _buildCalculateButton(theme),
              
              const SizedBox(height: 24),
              
              // Results Section
              if (_showResults) ...[
                _buildResultsSection(theme),
                const SizedBox(height: 24),
                _buildBreakdownSection(theme),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
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
                helperText: 'Enter amount in lakhs (e.g., 50 for ₹50,00,000)',
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
                if (amount > 1000) {
                  return 'Maximum loan amount is ₹1000 lakhs';
                }
                return null;
              },
              onChanged: (value) {
                final amount = double.tryParse(value);
                if (amount != null && amount > 0) {
                  setState(() {
                    _loanAmount = amount * 100000; // Convert lakhs to rupees
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
                if (rate > 25) {
                  return 'Interest rate seems too high (max 25%)';
                }
                return null;
              },
              onChanged: (value) {
                final rate = double.tryParse(value);
                if (rate != null && rate > 0) {
                  setState(() {
                    _interestRate = rate;
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
                if (tenure < 5 || tenure > 30) {
                  return 'Tenure should be between 5-30 years';
                }
                return null;
              },
              onChanged: (value) {
                final tenure = int.tryParse(value);
                if (tenure != null && tenure > 0) {
                  setState(() {
                    _tenureYears = tenure;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton(ThemeData theme) {
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: _calculateEMI,
        icon: const Icon(Icons.calculate),
        label: const Text('Calculate EMI'),
        style: FilledButton.styleFrom(
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection(ThemeData theme) {
    if (_emi == null) return const SizedBox.shrink();
    
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
                CurrencyFormatter.formatCurrency(_emi!),
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

  Widget _buildBreakdownSection(ThemeData theme) {
    if (_totalAmount == null || _totalInterest == null) {
      return const SizedBox.shrink();
    }
    
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
              CurrencyFormatter.formatCurrencyCompact(_loanAmount),
              theme.colorScheme.primary,
              Icons.account_balance,
            ),
            
            const SizedBox(height: 12),
            
            _buildBreakdownRow(
              theme,
              'Total Interest',
              CurrencyFormatter.formatCurrencyCompact(_totalInterest!),
              theme.colorScheme.error,
              Icons.trending_up,
            ),
            
            const SizedBox(height: 12),
            
            _buildBreakdownRow(
              theme,
              'Total Amount',
              CurrencyFormatter.formatCurrencyCompact(_totalAmount!),
              theme.colorScheme.secondary,
              Icons.payments,
            ),
            
            const SizedBox(height: 16),
            
            // Visual representation
            _buildAmountVisualization(theme),
            
            const SizedBox(height: 16),
            
            // Additional metrics
            _buildAdditionalMetrics(theme),
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

  Widget _buildAmountVisualization(ThemeData theme) {
    final principalRatio = _loanAmount / _totalAmount!;
    final interestRatio = _totalInterest! / _totalAmount!;
    
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

  Widget _buildAdditionalMetrics(ThemeData theme) {
    final monthlyInterest = (_loanAmount * _interestRate / 100) / 12;
    final monthlyPrincipal = _emi! - monthlyInterest;
    
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
}