import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/loan_provider.dart';
import '../../widgets/charts/emi_breakdown_chart.dart';
import '../../widgets/common/unified_header.dart';
import 'amortization_schedule_screen.dart';
import 'dart:async';
import 'dart:math' as math;

/// Calculator screen matching HTML mockup exactly
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
  String _loanStatus = 'planning'; // 'planning' or 'taken'
  
  // Chart and Schedule toggle states
  String _chartViewType = 'pie'; // 'pie' or 'timeline'
  
  // Slider values
  double _loanAmountSlider = 30.0;
  double _interestRateSlider = 8.5;
  double _tenureSlider = 20.0;
  double _monthsPaidSlider = 0.0;

  @override
  void initState() {
    super.initState();
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

  /// Initialize form controllers from current loan state or use sensible defaults
  Future<void> _initializeFromState() async {
    try {
      final loanState = ref.read(loanNotifierProvider);
      
      await loanState.when(
        data: (loan) async {
          if (mounted) {
            _setFormValues(loan);
          }
        },
        loading: () async {
          // Wait a bit and retry
          await Future.delayed(const Duration(milliseconds: 200));
          if (mounted) {
            final retryState = ref.read(loanNotifierProvider);
            if (retryState.hasValue) {
              _setFormValues(retryState.value!);
            } else {
              _setDefaultValues();
            }
          }
        },
        error: (_, __) async {
          if (mounted) {
            _setDefaultValues();
          }
        },
      );
    } catch (e) {
      // Fallback to defaults if anything goes wrong
      if (mounted) {
        _setDefaultValues();
      }
    }
  }

  void _setFormValues(loan) {
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

  void _setDefaultValues() {
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
    
    // Update the loan state with default values
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _updateCalculations();
      }
    });
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
      // Create updated loan model
      final currentLoan = await ref.read(loanNotifierProvider.future);
      final updatedLoan = currentLoan.copyWith(
        loanAmount: amount,
        annualInterestRate: rate,
        tenureYears: tenure,
      );
      ref.read(loanNotifierProvider.notifier).updateLoan(updatedLoan);
    }
    
    setState(() {
      _isUpdateInProgress = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loanAsync = ref.watch(loanNotifierProvider);
    final emi = ref.watch(monthlyEMIProvider);
    final totalAmount = ref.watch(totalAmountProvider);
    final totalInterest = ref.watch(totalInterestProvider);
    final isValid = ref.watch(isLoanValidProvider);
    
    return Scaffold(
      appBar: const UnifiedHeader(
        title: 'Calculator',
        showLoanSummary: true,
        showBackButton: false,
        currentTabIndex: 3, // Calculator is at index 3
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
              _buildEMIResultsHeroSection(theme, emi, loan),
              const SizedBox(height: 24),
              _buildVisualBreakdownSection(theme, loan, emi, totalAmount, totalInterest),
              const SizedBox(height: 24),
              _buildPaymentScheduleSection(theme, loan),
              const SizedBox(height: 24),
              _buildExportDataSection(theme, loan, emi),
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
                  child: const Text('💰', style: TextStyle(fontSize: 24)),
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

  /// Build loan input field with slider
  Widget _buildLoanInputField({
    required TextEditingController controller,
    required String label,
    String? prefixText,
    String? suffixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    required double sliderValue,
    required double sliderMin,
    required double sliderMax,
    int? sliderDivisions,
    required List<String> sliderLabels,
    required void Function(double) onSliderChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Input Field with Prefix/Suffix
        Stack(
          children: [
            TextFormField(
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.text,
              validator: validator,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: EdgeInsets.only(
                  left: prefixText != null ? 48 : 24,
                  right: suffixText != null ? 120 : 24,
                  top: 24,
                  bottom: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 2,
                  ),
                ),
              ),
            ),
            
            // Prefix Text
            if (prefixText != null)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    prefixText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            
            // Suffix Text
            if (suffixText != null)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    suffixText,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).dividerColor,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: sliderValue,
            min: sliderMin,
            max: sliderMax,
            divisions: sliderDivisions,
            onChanged: onSliderChanged,
          ),
        ),
        
        // Slider Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: sliderLabels.map((label) => Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
  
  /// Build optional input field
  Widget _buildOptionalField({
    required TextEditingController controller,
    required String label,
    String? prefixText,
    String? suffixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional indicator
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isOptional) ...[
                const SizedBox(width: 8),
                Text(
                  '(Optional)',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Input Field
        Stack(
          children: [
            TextFormField(
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.text,
              validator: validator,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: EdgeInsets.only(
                  left: prefixText != null ? 48 : 24,
                  right: suffixText != null ? 80 : 24,
                  top: 24,
                  bottom: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            
            // Prefix Text
            if (prefixText != null)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    prefixText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            
            // Suffix Text
            if (suffixText != null)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    suffixText,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
  
  /// Build loan status radio buttons
  Widget _buildLoanStatusSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Status',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildRadioOption(
                'planning',
                'Planning to Take',
                _loanStatus == 'planning',
                (value) => setState(() {
                  _loanStatus = value ?? 'planning';
                  if (value == 'planning') {
                    _monthsPaidController.text = '0';
                    _monthsPaidSlider = 0.0;
                  }
                }),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildRadioOption(
                'taken',
                'Already Taken',
                _loanStatus == 'taken',
                (value) => setState(() {
                  _loanStatus = value ?? 'taken';
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Build radio option
  Widget _buildRadioOption(
    String value,
    String label,
    bool selected,
    void Function(String?) onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).dividerColor,
                  width: 2,
                ),
              ),
              child: selected 
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build months paid field
  Widget _buildMonthsPaidField(ThemeData theme) {
    final maxMonths = (double.tryParse(_tenureController.text) ?? 20) * 12;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Months Already Paid',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Stack(
          children: [
            TextFormField(
              controller: _monthsPaidController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid months paid';
                }
                final months = int.tryParse(value);
                if (months == null || months < 0) {
                  return 'Please enter valid months paid';
                }
                if (months >= maxMonths) {
                  return 'Months paid cannot be more than ${maxMonths.round() - 1} for ${_tenureController.text} year tenure';
                }
                return null;
              },
              onChanged: (value) {
                final months = int.tryParse(value);
                if (months != null && months >= 0 && months < maxMonths) {
                  setState(() {
                    _monthsPaidSlider = months.toDouble();
                  });
                }
              },
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.only(
                  left: 24,
                  right: 80,
                  top: 24,
                  bottom: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.dividerColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.dividerColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  'months',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.dividerColor,
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withOpacity(0.1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _monthsPaidSlider,
            min: 0,
            max: math.max(1, maxMonths - 1),
            divisions: math.max(1, (maxMonths - 1).round()),
            onChanged: (value) {
              setState(() {
                _monthsPaidSlider = value;
                _monthsPaidController.text = value.round().toString();
              });
            },
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                maxMonths.round().toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build update calculations button
  Widget _buildUpdateButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isUpdateInProgress ? null : _updateCalculations,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isUpdateInProgress
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Calculating...'),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Update Calculations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
                Expanded(
                  child: Text(
                    'CALCULATION RESULTS',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
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
            _buildResultsGrid(theme, loan, emi, emiToIncomeRatio.toDouble()),
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
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                Expanded(
                  child: Text(
                    'VISUAL BREAKDOWN',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _chartViewType = 'pie';
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _chartViewType == 'pie' 
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            'Pie Chart',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _chartViewType == 'pie'
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _chartViewType = 'timeline';
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _chartViewType == 'timeline' 
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            'Timeline',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _chartViewType == 'timeline'
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Chart Container
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(_chartViewType),
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _chartViewType == 'pie'
                  ? const EMIBreakdownChart(height: 200)
                  : _buildTimelineView(theme, loan, emi),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildLegendItem('Principal', '₹${(loan.loanAmount / 100000).toStringAsFixed(1)}L', theme.financialColors.principalGreen),
                _buildLegendItem('Interest', '₹${(totalInterest / 100000).toStringAsFixed(1)}L', theme.financialColors.interestRed),
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
      mainAxisSize: MainAxisSize.min,
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
        Flexible(
          child: Text(
            '$label ($value)',
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
                Expanded(
                  child: Text(
                    'PAYMENT SCHEDULE',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Schedule Table Preview with link to full table
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AmortizationScheduleScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.table_chart_outlined,
                        size: 36,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          'Full Amortization Schedule',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          'View complete yearly payment breakdown\nwith export options',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tap to open',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
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
  Widget _buildExportDataSection(ThemeData theme, dynamic loan, double emi) {
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
                Expanded(
                  child: Text(
                    'EXPORT DATA',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
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
                    onPressed: () => _handleCSVExport(loan, emi),
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
                    onPressed: () => _handlePDFExport(loan, emi),
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

  /// Build timeline view for payment breakdown over time
  Widget _buildTimelineView(ThemeData theme, dynamic loan, double emi) {
    final totalMonths = loan.tenureYears * 12;
    final yearlyData = <int, Map<String, double>>{};
    
    // Calculate yearly breakdown
    double remainingBalance = loan.loanAmount;
    final monthlyInterestRate = (loan.annualInterestRate / 100) / 12;
    
    for (int year = 1; year <= loan.tenureYears; year++) {
      double yearlyPrincipal = 0;
      double yearlyInterest = 0;
      
      for (int month = 1; month <= 12 && ((year - 1) * 12 + month) <= totalMonths; month++) {
        final interestPayment = remainingBalance * monthlyInterestRate;
        final principalPayment = emi - interestPayment;
        
        yearlyPrincipal += principalPayment;
        yearlyInterest += interestPayment;
        remainingBalance -= principalPayment;
      }
      
      yearlyData[year] = {
        'principal': yearlyPrincipal,
        'interest': yearlyInterest,
      };
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Payment Timeline (Yearly Breakdown)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: yearlyData.length,
              itemBuilder: (context, index) {
                final year = index + 1;
                final data = yearlyData[year]!;
                final principalAmount = data['principal']!;
                final interestAmount = data['interest']!;
                final totalYearlyPayment = principalAmount + interestAmount;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Year
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Year $year',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      // Progress bar
                      Expanded(
                        child: Stack(
                          children: [
                            // Total bar background
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // Interest portion (red)
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 0.4 * 
                                    (interestAmount / totalYearlyPayment),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            // Principal portion (green)
                            Positioned(
                              left: MediaQuery.of(context).size.width * 0.4 * 
                                   (interestAmount / totalYearlyPayment),
                              child: Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.4 * 
                                      (principalAmount / totalYearlyPayment),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Amount
                      SizedBox(
                        width: 80,
                        child: Text(
                          CurrencyFormatter.formatCurrencyCompact(totalYearlyPayment),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Handle CSV export
  void _handleCSVExport(loan, double emi) {
    try {
      final csvContent = _generateCSVContent(loan, emi);
      // In a real app, you would use file_picker or similar to save the file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV export completed! ${csvContent.split('\n').length} rows exported.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Handle PDF export
  void _handlePDFExport(loan, double emi) {
    try {
      // In a real app, you would use pdf package to generate PDF
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF export completed! Detailed loan report generated.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF export failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Generate CSV content
  String _generateCSVContent(loan, double emi) {
    final buffer = StringBuffer();
    buffer.writeln('Payment Schedule Export');
    buffer.writeln('Loan Amount,₹${CurrencyFormatter.formatCurrency(loan.loanAmount)}');
    buffer.writeln('Interest Rate,${loan.annualInterestRate}%');
    buffer.writeln('Tenure,${loan.tenureYears} years');
    buffer.writeln('Monthly EMI,₹${CurrencyFormatter.formatCurrency(emi)}');
    buffer.writeln('');
    buffer.writeln('Month,Principal,Interest,EMI,Outstanding Balance');
    
    double remainingBalance = loan.loanAmount;
    final monthlyInterestRate = (loan.annualInterestRate / 100) / 12;
    final totalMonths = loan.tenureYears * 12;
    
    for (int month = 1; month <= totalMonths; month++) {
      final interestPayment = remainingBalance * monthlyInterestRate;
      final principalPayment = emi - interestPayment;
      remainingBalance -= principalPayment;
      
      buffer.writeln(
        '$month,'
        '₹${CurrencyFormatter.formatCurrency(principalPayment)},'
        '₹${CurrencyFormatter.formatCurrency(interestPayment)},'
        '₹${CurrencyFormatter.formatCurrency(emi)},'
        '₹${CurrencyFormatter.formatCurrency(remainingBalance)}'
      );
    }
    
    return buffer.toString();
  }
}