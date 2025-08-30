import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/calculation_providers.dart';

class LoanInputForm extends ConsumerWidget {
  const LoanInputForm({super.key});

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

            // Loan Amount
            _HybridNumberInput(
              label: 'Loan Amount',
              value: loanParameters.loanAmount,
              min: 100000,
              max: 50000000,
              prefix: '₹',
              onChanged: loanParamsNotifier.updateLoanAmount,
              formatter: (value) => value.toIndianFormat(),
            ),

            const SizedBox(height: 16),

            // Interest Rate
            _HybridNumberInput(
              label: 'Interest Rate (% per annum)',
              value: loanParameters.interestRate,
              min: 6.0,
              max: 15.0,
              suffix: '%',
              onChanged: loanParamsNotifier.updateInterestRate,
              formatter: (value) => value.toStringAsFixed(2),
            ),

            const SizedBox(height: 16),

            // Loan Tenure
            _HybridNumberInput(
              label: 'Loan Tenure',
              value: loanParameters.tenureYears.toDouble(),
              min: 5,
              max: 30,
              suffix: 'years',
              onChanged: (value) =>
                  loanParamsNotifier.updateTenure(value.round()),
              formatter: (value) => '${value.round()}',
            ),

            const SizedBox(height: 24),

            // Personal Details Section
            Text(
              'Personal Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Annual Income
            _HybridNumberInput(
              label: 'Annual Income',
              value: loanParameters.annualIncome,
              min: 200000,
              max: 10000000,
              prefix: '₹',
              onChanged: loanParamsNotifier.updateAnnualIncome,
              formatter: (value) => value.toIndianFormat(),
            ),

            const SizedBox(height: 16),

            // Age
            _HybridNumberInput(
              label: 'Age',
              value: loanParameters.age.toDouble(),
              min: 21,
              max: 75,
              suffix: 'years',
              onChanged: (value) => loanParamsNotifier.updateAge(value.round()),
              formatter: (value) => '${value.round()}',
            ),

            const SizedBox(height: 16),

            // Tax Slab
            Text('Tax Slab (%)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 5, label: Text('5%')),
                ButtonSegment(value: 10, label: Text('10%')),
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

class _HybridNumberInput extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String? prefix;
  final String? suffix;
  final Function(double) onChanged;
  final String Function(double)? formatter;

  const _HybridNumberInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.prefix,
    this.suffix,
    required this.onChanged,
    this.formatter,
  });

  @override
  State<_HybridNumberInput> createState() => _HybridNumberInputState();
}

class _HybridNumberInputState extends State<_HybridNumberInput> {
  late TextEditingController _controller;
  bool _isEditing = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
  }

  @override
  void didUpdateWidget(_HybridNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isEditing) {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (widget.formatter != null) {
      return widget.formatter!(value);
    }
    return value.toString();
  }

  void _handleTextChange(String text) {
    _isEditing = true;

    // Remove prefix and suffix for parsing
    String cleanText = text;
    if (widget.prefix != null) {
      cleanText = cleanText.replaceAll(widget.prefix!, '');
    }
    if (widget.suffix != null) {
      cleanText = cleanText.replaceAll(widget.suffix!, '');
    }

    // Remove commas and other formatting
    cleanText = cleanText.replaceAll(',', '').replaceAll(' ', '');

    final double? newValue = double.tryParse(cleanText);

    // Validate input
    setState(() {
      if (newValue == null && cleanText.isNotEmpty) {
        _errorText = 'Please enter a valid number';
      } else if (newValue != null && newValue < widget.min) {
        _errorText = 'Value must be at least ${_formatValue(widget.min)}';
      } else if (newValue != null && newValue > widget.max) {
        _errorText = 'Value cannot exceed ${_formatValue(widget.max)}';
      } else {
        _errorText = null;
        if (newValue != null) {
          widget.onChanged(newValue);
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

        // Text field with prefix/suffix
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          style: FinancialTypography.moneyMedium,
          decoration: InputDecoration(
            prefixText: widget.prefix,
            suffixText: widget.suffix,
            errorText: _errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          onChanged: _handleTextChange,
          onSubmitted: _handleTextChange,
        ),

        const SizedBox(height: 8),

        // Slider
        Slider(
          value: widget.value.clamp(widget.min, widget.max),
          min: widget.min,
          max: widget.max,
          divisions: ((widget.max - widget.min) / _getStep()).round(),
          onChanged: (value) {
            widget.onChanged(value);
            _controller.text = _formatValue(value);
          },
        ),

        // Min-Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatValue(widget.min),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                _formatValue(widget.max),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getStep() {
    final range = widget.max - widget.min;
    if (range > 1000000) return 50000; // Large amounts
    if (range > 100000) return 5000;
    if (range > 10000) return 1000;
    if (range > 100) return 10;
    return 1;
  }
}
