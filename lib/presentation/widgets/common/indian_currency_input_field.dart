import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'responsive_layout.dart';

/// Enhanced input field for Indian currency with real-time formatting and visual feedback
class IndianCurrencyInputField extends StatefulWidget {
  final String label;
  final String? helperText;
  final double? initialValue;
  final Function(double) onValueChanged;
  final double? minValue;
  final double? maxValue;
  final String? prefixText;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const IndianCurrencyInputField({
    super.key,
    required this.label,
    this.helperText,
    this.initialValue,
    required this.onValueChanged,
    this.minValue,
    this.maxValue,
    this.prefixText,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<IndianCurrencyInputField> createState() =>
      _IndianCurrencyInputFieldState();
}

class _IndianCurrencyInputFieldState extends State<IndianCurrencyInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _formattedValue = '';
  String _helpText = '';
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.initialValue != null && widget.initialValue! > 0) {
      _controller.text = widget.initialValue.toString();
      _updateFormatting(_controller.text);
    }

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(IndianCurrencyInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        _controller.text != widget.initialValue.toString()) {
      _controller.text = widget.initialValue.toString();
      _updateFormatting(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Formatted display when not focused
        if (!_focusNode.hasFocus && _formattedValue.isNotEmpty)
          _buildFormattedDisplay(context),

        // Input field
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helperText ?? _helpText,
            helperMaxLines: 2,
            prefixIcon: const Icon(Icons.currency_rupee, size: 20),
            suffixIcon: _controller.text.isNotEmpty && widget.enabled
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: _clearField,
                  )
                : null,
            errorText: _isValid ? null : _getErrorText(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
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
              ),
            ),
          ),
          onChanged: _onTextChanged,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            _IndianCurrencyInputFormatter(),
          ],
        ),

        // Value breakdown helper
        if (_controller.text.isNotEmpty && !_focusNode.hasFocus && _isValid)
          _buildValueBreakdown(context),

        // Quick amount buttons for common values
        if (_focusNode.hasFocus && _controller.text.isEmpty)
          _buildQuickAmountButtons(context),
      ],
    );
  }

  Widget _buildFormattedDisplay(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: ResponsiveSpacing.md,
        vertical: ResponsiveSpacing.sm,
      ),
      margin: const EdgeInsets.only(bottom: ResponsiveSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.currency_rupee, size: 18, color: colorScheme.primary),
          const SizedBox(width: ResponsiveSpacing.sm),
          Expanded(
            child: Text(
              _formattedValue,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_isValid)
            Icon(Icons.check_circle, size: 16, color: colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildValueBreakdown(BuildContext context) {
    final value = double.tryParse(_controller.text) ?? 0;
    if (value == 0) return const SizedBox.shrink();

    final breakdown = _getValueBreakdown(value);
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: ResponsiveSpacing.xs),
      child: Text(
        '≈ $breakdown',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildQuickAmountButtons(BuildContext context) {
    final commonAmounts = [
      {'label': '10L', 'value': 1000000.0},
      {'label': '25L', 'value': 2500000.0},
      {'label': '50L', 'value': 5000000.0},
      {'label': '1Cr', 'value': 10000000.0},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: ResponsiveSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick amounts',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: ResponsiveSpacing.xs),
          Wrap(
            spacing: ResponsiveSpacing.xs,
            children: commonAmounts.map((amount) {
              return ActionChip(
                label: Text(amount['label'] as String),
                onPressed: () {
                  _controller.text = (amount['value'] as double)
                      .toStringAsFixed(0);
                  _onTextChanged(_controller.text);
                },
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                labelStyle: Theme.of(context).textTheme.bodySmall,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String value) {
    _updateFormatting(value);
    _validateInput(value);

    final numericValue = double.tryParse(value) ?? 0;
    widget.onValueChanged(numericValue);

    setState(() {
      _helpText = _generateHelpText(numericValue);
    });
  }

  void _updateFormatting(String value) {
    final numericValue = double.tryParse(value) ?? 0;
    if (numericValue > 0) {
      _formattedValue = _formatIndianCurrency(numericValue);
    } else {
      _formattedValue = '';
    }
  }

  void _validateInput(String value) {
    final numericValue = double.tryParse(value) ?? 0;
    bool isValid = true;

    if (widget.minValue != null && numericValue < widget.minValue!) {
      isValid = false;
    }

    if (widget.maxValue != null && numericValue > widget.maxValue!) {
      isValid = false;
    }

    setState(() {
      _isValid = isValid;
    });
  }

  String _formatIndianCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: value % 1 == 0 ? 0 : 2,
    );
    return formatter.format(value);
  }

  String _generateHelpText(double value) {
    if (value == 0) return widget.helperText ?? '';

    final baseHelp = widget.helperText ?? '';
    final breakdown = _getValueInWords(value);

    return baseHelp.isNotEmpty ? '$baseHelp • $breakdown' : breakdown;
  }

  String _getValueInWords(double value) {
    if (value >= 10000000) {
      final crores = value / 10000000;
      return crores % 1 == 0
          ? '${crores.toInt()} Crore'
          : '${crores.toStringAsFixed(2)} Crore';
    } else if (value >= 100000) {
      final lakhs = value / 100000;
      return lakhs % 1 == 0
          ? '${lakhs.toInt()} Lakh'
          : '${lakhs.toStringAsFixed(1)} Lakh';
    } else if (value >= 1000) {
      final thousands = value / 1000;
      return thousands % 1 == 0
          ? '${thousands.toInt()} Thousand'
          : '${thousands.toStringAsFixed(1)} Thousand';
    }
    return value.toStringAsFixed(0);
  }

  String _getValueBreakdown(double value) {
    final crores = (value / 10000000).floor();
    final lakhs = ((value % 10000000) / 100000).floor();
    final thousands = ((value % 100000) / 1000).floor();

    final breakdown = <String>[];
    if (crores > 0) breakdown.add('${crores}Cr');
    if (lakhs > 0) breakdown.add('${lakhs}L');
    if (thousands > 0) breakdown.add('${thousands}K');

    return breakdown.join(' ');
  }

  String? _getErrorText() {
    final value = double.tryParse(_controller.text) ?? 0;

    if (widget.minValue != null && value < widget.minValue!) {
      final minFormatted = _formatIndianCurrency(widget.minValue!);
      return 'Minimum value: $minFormatted';
    }

    if (widget.maxValue != null && value > widget.maxValue!) {
      final maxFormatted = _formatIndianCurrency(widget.maxValue!);
      return 'Maximum value: $maxFormatted';
    }

    return null;
  }

  void _onFocusChanged() {
    setState(() {}); // Rebuild to show/hide formatted display
  }

  void _clearField() {
    _controller.clear();
    widget.onValueChanged(0);
    setState(() {
      _formattedValue = '';
      _helpText = widget.helperText ?? '';
      _isValid = true;
    });
  }
}

/// Input formatter for Indian currency that allows only valid number formats
class _IndianCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty input
    final newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }

    // Count decimal points
    final decimalCount = '.'.allMatches(newText).length;
    if (decimalCount > 1) {
      return oldValue;
    }

    // Limit decimal places to 2
    if (newText.contains('.')) {
      final parts = newText.split('.');
      if (parts.length == 2 && parts[1].length > 2) {
        return oldValue;
      }
    }

    // Prevent leading zeros (except for 0.x format)
    if (newText.length > 1 &&
        newText.startsWith('0') &&
        !newText.startsWith('0.')) {
      return oldValue;
    }

    // Validate that the result is a valid number
    if (double.tryParse(newText) == null && newText != '.') {
      return oldValue;
    }

    return newValue;
  }
}

/// Percentage input field specifically for interest rates and other percentages
class PercentageInputField extends StatefulWidget {
  final String label;
  final String? helperText;
  final double? initialValue;
  final Function(double) onValueChanged;
  final double? minValue;
  final double? maxValue;
  final bool enabled;
  final int decimalPlaces;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const PercentageInputField({
    super.key,
    required this.label,
    this.helperText,
    this.initialValue,
    required this.onValueChanged,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.enabled = true,
    this.decimalPlaces = 2,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<PercentageInputField> createState() => _PercentageInputFieldState();
}

class _PercentageInputFieldState extends State<PercentageInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!.toStringAsFixed(
        widget.decimalPlaces,
      );
    }
  }

  @override
  void didUpdateWidget(PercentageInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        _controller.text !=
            widget.initialValue!.toStringAsFixed(widget.decimalPlaces)) {
      _controller.text = widget.initialValue!.toStringAsFixed(
        widget.decimalPlaces,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        suffixText: '% p.a.',
        prefixIcon: const Icon(Icons.percent, size: 20),
        suffixIcon: _controller.text.isNotEmpty && widget.enabled
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.onValueChanged(0);
                  setState(() {
                    _isValid = true;
                  });
                },
              )
            : null,
        errorText: _isValid ? null : _getErrorText(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
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
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),
      onChanged: _onTextChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        _PercentageInputFormatter(widget.decimalPlaces),
      ],
    );
  }

  void _onTextChanged(String value) {
    _validateInput(value);

    final numericValue = double.tryParse(value) ?? 0;
    widget.onValueChanged(numericValue);
  }

  void _validateInput(String value) {
    final numericValue = double.tryParse(value) ?? 0;
    bool isValid = true;

    if (widget.minValue != null && numericValue < widget.minValue!) {
      isValid = false;
    }

    if (widget.maxValue != null && numericValue > widget.maxValue!) {
      isValid = false;
    }

    setState(() {
      _isValid = isValid;
    });
  }

  String? _getErrorText() {
    final value = double.tryParse(_controller.text) ?? 0;

    if (widget.minValue != null && value < widget.minValue!) {
      return 'Minimum: ${widget.minValue}%';
    }

    if (widget.maxValue != null && value > widget.maxValue!) {
      return 'Maximum: ${widget.maxValue}%';
    }

    return null;
  }
}

/// Input formatter for percentage values
class _PercentageInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  _PercentageInputFormatter(this.decimalPlaces);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    // Count decimal points
    final decimalCount = '.'.allMatches(newText).length;
    if (decimalCount > 1) {
      return oldValue;
    }

    // Limit decimal places
    if (newText.contains('.')) {
      final parts = newText.split('.');
      if (parts.length == 2 && parts[1].length > decimalPlaces) {
        return oldValue;
      }
    }

    // Prevent leading zeros (except for 0.x format)
    if (newText.length > 1 &&
        newText.startsWith('0') &&
        !newText.startsWith('0.')) {
      return oldValue;
    }

    // Validate number
    if (double.tryParse(newText) == null && newText != '.') {
      return oldValue;
    }

    return newValue;
  }
}
