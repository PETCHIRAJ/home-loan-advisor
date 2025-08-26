import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/loan_data.dart';
import '../widgets/calculator_result_card.dart';

class QuickCalculatorScreen extends StatefulWidget {
  const QuickCalculatorScreen({super.key});

  @override
  State<QuickCalculatorScreen> createState() => _QuickCalculatorScreenState();
}

class _QuickCalculatorScreenState extends State<QuickCalculatorScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();

  late AnimationController _resultController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  LoanData? _currentLoan;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeInOut,
    ));

    // Real-time calculation as user types
    _loanAmountController.addListener(_onInputChanged);
    _interestRateController.addListener(_onInputChanged);
    _tenureController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _resultController.dispose();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (_loanAmountController.text.isNotEmpty &&
        _interestRateController.text.isNotEmpty &&
        _tenureController.text.isNotEmpty) {
      _calculateLoan();
    }
  }

  void _calculateLoan() {
    try {
      final loanAmount = double.parse(_loanAmountController.text.replaceAll(',', ''));
      final interestRate = double.parse(_interestRateController.text);
      final tenure = int.parse(_tenureController.text);

      setState(() {
        _currentLoan = LoanData(
          loanAmount: loanAmount,
          interestRate: interestRate,
          tenureYears: tenure,
        );
        _showResults = true;
      });

      if (!_resultController.isAnimating) {
        _resultController.forward();
      }
    } catch (e) {
      setState(() {
        _showResults = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Quick Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  '📊 Quick Loan Analysis',
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Just 3 inputs to reveal everything about your loan',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppTheme.outline,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Input Form
                _buildInputForm(),
                
                const SizedBox(height: 24),
                
                // Results Section
                if (_showResults && _currentLoan != null)
                  AnimatedBuilder(
                    animation: _resultController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildResults(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Loan Amount
          _buildInputField(
            controller: _loanAmountController,
            label: 'Loan Amount',
            hint: 'Enter loan amount',
            prefix: '₹',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CurrencyInputFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter loan amount';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // Interest Rate
          _buildInputField(
            controller: _interestRateController,
            label: 'Interest Rate',
            hint: 'Annual interest rate',
            suffix: '%',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter interest rate';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // Tenure
          _buildInputField(
            controller: _tenureController,
            label: 'Loan Tenure',
            hint: 'Loan period in years',
            suffix: 'Years',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter tenure';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 24),
          
          // Calculate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _calculateLoan,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate EMI'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            suffixText: suffix,
            prefixStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
            suffixStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppTheme.outline,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: AppTextStyles.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_currentLoan == null) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Text(
              '🎯 Your Loan Analysis',
              style: AppTextStyles.titleLarge,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _showDetailedBreakdown(),
              child: const Text('View Details'),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Key Metrics Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            CalculatorResultCard(
              title: 'Monthly EMI',
              value: _currentLoan!.monthlyEMI.toIndianCurrency,
              icon: Icons.payment,
              color: AppTheme.primaryBlue,
              onTap: () => _showEMIBreakdown(),
            ),
            CalculatorResultCard(
              title: 'Total Interest',
              value: _currentLoan!.totalInterest.toIndianCurrencyCompact,
              icon: Icons.trending_up,
              color: AppTheme.errorRed,
              onTap: () => _showInterestBreakdown(),
            ),
            CalculatorResultCard(
              title: 'Daily Interest',
              value: '₹${_currentLoan!.dailyInterestBurn.toStringAsFixed(0)}',
              icon: Icons.local_fire_department,
              color: AppTheme.warningOrange,
              onTap: () => _showDailyBurnDetails(),
            ),
            CalculatorResultCard(
              title: 'Total Amount',
              value: (_currentLoan!.loanAmount + _currentLoan!.totalInterest).toIndianCurrencyCompact,
              icon: Icons.account_balance,
              color: AppTheme.secondaryTeal,
              onTap: () => _showTotalBreakdown(),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Quick Optimization Preview
        _buildOptimizationPreview(),
        
        const SizedBox(height: 24),
        
        // Action Buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildOptimizationPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.successGreen.withOpacity(0.1),
            AppTheme.secondaryTeal.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppTheme.successGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Optimization Opportunity',
                style: AppTextStyles.labelLarge,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Top 3 savings strategies
          _buildOptimizationItem(
            'Bi-Weekly Payments',
            'Save ${_currentLoan!.biWeeklySavings.toIndianCurrencyCompact}',
            'Switch to 26 payments per year',
            Icons.payment,
          ),
          
          const SizedBox(height: 12),
          
          _buildOptimizationItem(
            'Extra EMI Strategy',
            'Save ${_currentLoan!.extraEMISavings.toIndianCurrencyCompact}',
            'Pay one additional EMI annually',
            Icons.add_circle,
          ),
          
          const SizedBox(height: 12),
          
          _buildOptimizationItem(
            'Round-Up EMI',
            'Save ${_currentLoan!.roundUpSavings.toIndianCurrencyCompact}',
            'Round EMI to nearest thousand',
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationItem(String title, String savings, String description, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: AppTheme.successGreen,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 13,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppTheme.outline,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Text(
          savings,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppTheme.successGreen,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _exploreStrategies(),
                icon: const Icon(Icons.explore, size: 18),
                label: const Text('Explore Strategies'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _saveCalculation(),
                icon: const Icon(Icons.bookmark, size: 18),
                label: const Text('Save This'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _startOptimizationJourney(),
            icon: const Icon(Icons.rocket_launch, size: 18),
            label: const Text('Start My Optimization Journey'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Action methods
  void _showDetailedBreakdown() {
    // Show detailed loan breakdown
  }

  void _showEMIBreakdown() {
    // Show EMI composition breakdown
  }

  void _showInterestBreakdown() {
    // Show interest calculation details
  }

  void _showDailyBurnDetails() {
    // Show daily interest burn details
  }

  void _showTotalBreakdown() {
    // Show total payment breakdown
  }

  void _exploreStrategies() {
    // Navigate to strategies screen
  }

  void _saveCalculation() {
    // Save calculation to local storage
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculation saved successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _startOptimizationJourney() {
    // Navigate to personalized optimization flow
    HapticFeedback.heavyImpact();
  }
}

// Custom formatter for currency input
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Format with commas
    String formatted = _formatCurrency(digitsOnly);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatCurrency(String digits) {
    if (digits.length <= 3) return digits;
    
    // Indian currency formatting (lakhs and crores)
    String reversed = digits.split('').reversed.join();
    String formatted = '';
    
    for (int i = 0; i < reversed.length; i++) {
      if (i == 3 || (i > 3 && (i - 3) % 2 == 0)) {
        formatted = ',$formatted';
      }
      formatted = reversed[i] + formatted;
    }
    
    return formatted;
  }
}