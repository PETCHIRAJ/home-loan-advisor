import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../providers/calculation_providers.dart';
import '../common/indian_currency_input_field.dart';
import '../common/responsive_layout.dart';

class LoanInputForm extends ConsumerWidget {
  const LoanInputForm({super.key});

  void _updateTaxSlabBasedOnIncome(double income, dynamic notifier) {
    int taxSlab;
    if (income <= 250000) {
      taxSlab = 0; // No tax
    } else if (income <= 500000) {
      taxSlab = 5; // 5%
    } else if (income <= 1000000) {
      taxSlab = 20; // 20%
    } else {
      taxSlab = 30; // 30%
    }
    notifier.updateTaxSlab(taxSlab);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanParameters = ref.watch(loanParametersProvider);
    final loanParamsNotifier = ref.read(loanParametersProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loan Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // Loan Amount with enhanced Indian currency formatting
            IndianCurrencyInputField(
              label: 'Loan Amount',
              helperText: 'Enter the amount you want to borrow',
              initialValue: loanParameters.loanAmount,
              minValue: 500000, // 5 lakhs
              maxValue: 20000000, // 2 crores
              onValueChanged: loanParamsNotifier.updateLoanAmount,
            ),

            const SizedBox(height: 16),

            // Interest Rate with percentage formatting
            PercentageInputField(
              label: 'Interest Rate',
              helperText: 'Annual interest rate charged by the bank',
              initialValue: loanParameters.interestRate,
              minValue: 6.0,
              maxValue: 15.0,
              decimalPlaces: 2,
              onValueChanged: loanParamsNotifier.updateInterestRate,
            ),

            const SizedBox(height: 16),

            // Loan Tenure
            _ImprovedNumberInput(
              label: 'Loan Tenure',
              value: loanParameters.tenureYears.toDouble(),
              min: 5,
              max: 30,
              step: 1,
              inputType: InputType.years,
              onChanged: (value) => loanParamsNotifier.updateTenure(value.round()),
            ),

            const SizedBox(height: 24),

            // Personal Details Section
            Text(
              'Personal Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Annual Income with enhanced currency formatting
            IndianCurrencyInputField(
              label: 'Annual Income',
              helperText: 'Your total annual income from all sources',
              initialValue: loanParameters.annualIncome,
              minValue: 200000, // 2 lakhs
              maxValue: 10000000, // 1 crore
              onValueChanged: (value) {
                loanParamsNotifier.updateAnnualIncome(value);
                // Auto-update tax slab based on income
                _updateTaxSlabBasedOnIncome(value, loanParamsNotifier);
              },
            ),

            const SizedBox(height: 16),

            // Age
            _ImprovedNumberInput(
              label: 'Age',
              value: loanParameters.age.toDouble(),
              min: 21,
              max: 75,
              step: 1,
              inputType: InputType.years,
              onChanged: (value) => loanParamsNotifier.updateAge(value.round()),
            ),

            const SizedBox(height: 16),

            // Tax Slab
            Text('Tax Slab', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('No Tax')),
                ButtonSegment(value: 5, label: Text('5%')),
                ButtonSegment(value: 20, label: Text('20%')),
                ButtonSegment(value: 30, label: Text('30%')),
              ],
              selected: {loanParameters.taxSlabPercentage},
              onSelectionChanged: (Set<int> selection) {
                loanParamsNotifier.updateTaxSlab(selection.first);
              },
            ),

            const SizedBox(height: 16),

            // Employment Type
            Text(
              'Employment Type',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'salaried', label: Text('Salaried')),
                ButtonSegment(
                  value: 'self_employed',
                  label: Text('Self Employed'),
                ),
              ],
              selected: {loanParameters.employmentType},
              onSelectionChanged: (Set<String> selection) {
                loanParamsNotifier.updateEmploymentType(selection.first);
              },
            ),

            const SizedBox(height: 16),

            // Gender
            Text('Gender', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'male', label: Text('Male')),
                ButtonSegment(value: 'female', label: Text('Female')),
              ],
              selected: {loanParameters.gender},
              onSelectionChanged: (Set<String> selection) {
                loanParamsNotifier.updateGender(selection.first);
              },
            ),

            const SizedBox(height: 16),

            // Property and First-time buyer switches
            SwitchListTile(
              title: const Text('Self-occupied property'),
              subtitle: const Text('Affects tax benefits eligibility'),
              value: loanParameters.isSelfOccupied,
              onChanged: loanParamsNotifier.updatePropertyType,
            ),

            SwitchListTile(
              title: const Text('First-time home buyer'),
              subtitle: const Text('May qualify for additional benefits'),
              value: loanParameters.isFirstTimeHomeBuyer,
              onChanged: loanParamsNotifier.updateFirstTimeBuyer,
            ),
          ],
        ),
      ),
    );
  }
}

enum InputType { currency, percentage, years }

class _ImprovedNumberInput extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final InputType inputType;
  final Function(double) onChanged;

  const _ImprovedNumberInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.inputType,
    required this.onChanged,
  });

  @override
  State<_ImprovedNumberInput> createState() => _ImprovedNumberInputState();
}

class _ImprovedNumberInputState extends State<_ImprovedNumberInput> {
  late TextEditingController _controller;
  bool _isEditing = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _getPlainValue(widget.value));
  }

  @override
  void didUpdateWidget(_ImprovedNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isEditing) {
      _controller.text = _getPlainValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPlainValue(double value) {
    switch (widget.inputType) {
      case InputType.currency:
        return value.round().toString();
      case InputType.percentage:
        return value.toStringAsFixed(1);
      case InputType.years:
        return value.round().toString();
    }
  }

  String _getFormattedValue(double value) {
    switch (widget.inputType) {
      case InputType.currency:
        return value.toIndianFormat();
      case InputType.percentage:
        return '${value.toStringAsFixed(1)}%';
      case InputType.years:
        return '${value.round()} years';
    }
  }

  String _getPlaceholder() {
    switch (widget.inputType) {
      case InputType.currency:
        return 'e.g., 2500000';
      case InputType.percentage:
        return 'e.g., 8.5';
      case InputType.years:
        return 'e.g., 20';
    }
  }


  void _handleTextChange(String text) {
    _isEditing = true;

    // Remove commas and spaces
    String cleanText = text.replaceAll(',', '').replaceAll(' ', '');
    final double? newValue = double.tryParse(cleanText);

    setState(() {
      if (newValue == null && cleanText.isNotEmpty) {
        _errorText = 'Please enter a valid number';
      } else if (newValue != null && newValue < widget.min) {
        _errorText = 'Minimum value is ${_getPlainValue(widget.min)}';
      } else if (newValue != null && newValue > widget.max) {
        _errorText = 'Maximum value is ${_getPlainValue(widget.max)}';
      } else {
        _errorText = null;
        if (newValue != null) {
          // Snap to nearest step for slider compatibility
          final snappedValue = (newValue / widget.step).round() * widget.step;
          widget.onChanged(snappedValue.clamp(widget.min, widget.max));
        }
      }
    });

    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),

        // Text input for plain numbers
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: _getPlaceholder(),
            suffixText: widget.inputType == InputType.percentage ? '%' : 
                       widget.inputType == InputType.years ? 'years' : null,
            errorText: _errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          onChanged: _handleTextChange,
        ),

        // Helper text showing formatted value
        if (widget.inputType == InputType.currency) ...[
          const SizedBox(height: 4),
          Text(
            _getFormattedValue(widget.value),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        const SizedBox(height: 12),

        // Slider with proper steps
        Slider(
          value: widget.value.clamp(widget.min, widget.max),
          min: widget.min,
          max: widget.max,
          divisions: ((widget.max - widget.min) / widget.step).round(),
          onChanged: (value) {
            final snappedValue = (value / widget.step).round() * widget.step;
            widget.onChanged(snappedValue);
            _controller.text = _getPlainValue(snappedValue);
          },
        ),

        // Min-Max labels with formatted values
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getFormattedValue(widget.min),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                _getFormattedValue(widget.max),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
