import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/loan_parameters.dart';
import '../../../providers/scenario_comparison_providers.dart';

class AddCustomScenarioDialog extends ConsumerStatefulWidget {
  const AddCustomScenarioDialog({super.key});

  @override
  ConsumerState<AddCustomScenarioDialog> createState() => _AddCustomScenarioDialogState();
}

class _AddCustomScenarioDialogState extends ConsumerState<AddCustomScenarioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  final _annualIncomeController = TextEditingController();
  
  int _taxSlabPercentage = 20;
  bool _isSelfOccupied = true;
  bool _isFirstTimeHomeBuyer = false;
  int _age = 30;
  String _employmentType = 'salaried';
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    // Initialize with base scenario values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(scenarioComparisonProvider);
      final baseScenario = state.comparison?.baseScenario;
      if (baseScenario != null) {
        _initializeWithBaseValues(baseScenario.parameters);
      }
    });
  }

  void _initializeWithBaseValues(LoanParameters baseParams) {
    _loanAmountController.text = baseParams.loanAmount.toStringAsFixed(0);
    _interestRateController.text = baseParams.interestRate.toStringAsFixed(2);
    _tenureController.text = baseParams.tenureYears.toString();
    _annualIncomeController.text = baseParams.annualIncome.toStringAsFixed(0);
    _taxSlabPercentage = baseParams.taxSlabPercentage;
    _isSelfOccupied = baseParams.isSelfOccupied;
    _isFirstTimeHomeBuyer = baseParams.isFirstTimeHomeBuyer;
    _age = baseParams.age;
    _employmentType = baseParams.employmentType;
    _gender = baseParams.gender;
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    _annualIncomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Custom Scenario'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Scenario details
                _buildSectionTitle('Scenario Details'),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Scenario Name *',
                    hintText: 'e.g., High EMI Option',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a scenario name';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Brief description of this scenario',
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 24),

                // Loan parameters
                _buildSectionTitle('Loan Parameters'),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _loanAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount *',
                    prefixText: '₹ ',
                    hintText: '2500000',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'loan amount', 100000),
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _interestRateController,
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate *',
                    suffixText: '% p.a.',
                    hintText: '8.5',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => _validateNumber(value, 'interest rate', 1, 50),
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _tenureController,
                  decoration: const InputDecoration(
                    labelText: 'Tenure *',
                    suffixText: 'years',
                    hintText: '20',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'tenure', 1, 50),
                ),

                const SizedBox(height: 24),

                // Personal details
                _buildSectionTitle('Personal Details'),
                const SizedBox(height: 12),
                
                TextFormField(
                  controller: _annualIncomeController,
                  decoration: const InputDecoration(
                    labelText: 'Annual Income *',
                    prefixText: '₹ ',
                    hintText: '1500000',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'annual income', 100000),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tax Slab',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: _taxSlabPercentage,
                            items: [5, 10, 20, 30].map((rate) {
                              return DropdownMenuItem(
                                value: rate,
                                child: Text('$rate%'),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _taxSlabPercentage = value!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: _age,
                            items: List.generate(43, (index) => 25 + index).map((age) {
                              return DropdownMenuItem(
                                value: age,
                                child: Text('$age years'),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _age = value!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employment',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _employmentType,
                            items: const [
                              DropdownMenuItem(value: 'salaried', child: Text('Salaried')),
                              DropdownMenuItem(value: 'self_employed', child: Text('Self Employed')),
                            ],
                            onChanged: (value) => setState(() => _employmentType = value!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            items: const [
                              DropdownMenuItem(value: 'male', child: Text('Male')),
                              DropdownMenuItem(value: 'female', child: Text('Female')),
                            ],
                            onChanged: (value) => setState(() => _gender = value!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Property details
                _buildSectionTitle('Property Details'),
                const SizedBox(height: 12),
                
                SwitchListTile(
                  title: const Text('Self-occupied property'),
                  subtitle: const Text('Check if you will live in this property'),
                  value: _isSelfOccupied,
                  onChanged: (value) => setState(() => _isSelfOccupied = value),
                  contentPadding: EdgeInsets.zero,
                ),
                
                SwitchListTile(
                  title: const Text('First-time home buyer'),
                  subtitle: const Text('Check if this is your first home purchase'),
                  value: _isFirstTimeHomeBuyer,
                  onChanged: (value) => setState(() => _isFirstTimeHomeBuyer = value),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addCustomScenario,
          child: const Text('Add Scenario'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String? _validateNumber(String? value, String fieldName, [double? min, double? max]) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number for $fieldName';
    }
    
    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }
    
    if (max != null && number > max) {
      return '$fieldName must not exceed $max';
    }
    
    return null;
  }

  void _addCustomScenario() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final loanAmount = double.parse(_loanAmountController.text);
    final interestRate = double.parse(_interestRateController.text);
    final tenure = int.parse(_tenureController.text);
    final annualIncome = double.parse(_annualIncomeController.text);

    final parameters = LoanParameters(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureYears: tenure,
      annualIncome: annualIncome,
      taxSlabPercentage: _taxSlabPercentage,
      isSelfOccupied: _isSelfOccupied,
      isFirstTimeHomeBuyer: _isFirstTimeHomeBuyer,
      age: _age,
      employmentType: _employmentType,
      gender: _gender,
    );

    ref
        .read(scenarioComparisonProvider.notifier)
        .addCustomScenario(name, description.isEmpty ? name : description, parameters);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added custom scenario: $name'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}