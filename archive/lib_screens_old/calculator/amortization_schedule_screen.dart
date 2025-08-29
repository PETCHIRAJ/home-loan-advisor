import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/loan_calculations.dart';
import '../../core/services/export_service.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/loan_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/loan_model.dart';
import '../../widgets/common/unified_header.dart';

/// Comprehensive amortization schedule screen showing detailed monthly payment breakdowns
/// 
/// Features:
/// - Full monthly payment table with principal/interest breakdown
/// - Remaining balance tracking for each month
/// - Yearly summaries and filtering options
/// - Export functionality for CSV/sharing
/// - Responsive table with scroll capabilities
/// - Search and filter options by year/month
class AmortizationScheduleScreen extends ConsumerStatefulWidget {
  const AmortizationScheduleScreen({super.key});

  @override
  ConsumerState<AmortizationScheduleScreen> createState() =>
      _AmortizationScheduleScreenState();
}

class _AmortizationScheduleScreenState
    extends ConsumerState<AmortizationScheduleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  // Filter options
  int? _selectedYear;
  bool _showYearlySummary = false;
  final List<int> _availableYears = [];
  
  // Data
  List<Map<String, dynamic>> _fullSchedule = [];
  List<Map<String, dynamic>> _filteredSchedule = [];
  final List<Map<String, dynamic>> _yearlySummary = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateScheduleData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Generate full amortization schedule and yearly summaries
  void _generateScheduleData() {
    final loanAsync = ref.read(loanNotifierProvider);
    
    loanAsync.whenData((loan) {
      // Generate full amortization schedule
      _fullSchedule = LoanCalculations.generateAmortizationSchedule(
        loanAmount: loan.loanAmount,
        annualInterestRate: loan.annualInterestRate,
        tenureYears: loan.tenureYears,
        numberOfMonths: loan.totalMonths,
      );
      
      // Generate available years
      _availableYears.clear();
      final startYear = DateTime.now().year;
      for (int i = 0; i < loan.tenureYears; i++) {
        _availableYears.add(startYear + i);
      }
      
      // Generate yearly summary
      _generateYearlySummary(loan);
      
      // Initialize filtered schedule with full data
      _filteredSchedule = List.from(_fullSchedule);
      
      if (mounted) {
        setState(() {});
      }
    });
  }

  /// Generate yearly summary data
  void _generateYearlySummary(LoanModel loan) {
    _yearlySummary.clear();
    
    for (int year = 1; year <= loan.tenureYears; year++) {
      final startMonth = (year - 1) * 12 + 1;
      final endMonth = year * 12;
      
      double yearlyPrincipal = 0;
      double yearlyInterest = 0;
      double yearlyEMI = 0;
      double endingBalance = 0;
      
      for (int month = startMonth; month <= endMonth && month <= _fullSchedule.length; month++) {
        final monthData = _fullSchedule[month - 1];
        yearlyPrincipal += monthData['principal'] as double;
        yearlyInterest += monthData['interest'] as double;
        yearlyEMI += monthData['emi'] as double;
        
        if (month == endMonth || month == _fullSchedule.length) {
          endingBalance = monthData['balance'] as double;
        }
      }
      
      _yearlySummary.add({
        'year': year,
        'totalEMI': yearlyEMI,
        'totalPrincipal': yearlyPrincipal,
        'totalInterest': yearlyInterest,
        'endingBalance': endingBalance,
        'startMonth': startMonth,
        'endMonth': endMonth,
      });
    }
  }

  /// Filter schedule by selected year
  void _filterByYear(int? year) {
    setState(() {
      _selectedYear = year;
      
      if (year == null) {
        _filteredSchedule = List.from(_fullSchedule);
      } else {
        final startMonth = (year - DateTime.now().year) * 12 + 1;
        final endMonth = startMonth + 11;
        
        _filteredSchedule = _fullSchedule.where((entry) {
          final month = entry['month'] as int;
          return month >= startMonth && month <= endMonth && month <= _fullSchedule.length;
        }).toList();
      }
    });
  }

  /// Export schedule data as CSV text
  String _generateCSVData() {
    final buffer = StringBuffer();
    
    // CSV Headers
    buffer.writeln('Month,EMI,Principal,Interest,Balance');
    
    // Data rows
    for (final entry in _filteredSchedule) {
      buffer.writeln('${entry['month']},${entry['emi'].toStringAsFixed(2)},'
          '${entry['principal'].toStringAsFixed(2)},${entry['interest'].toStringAsFixed(2)},'
          '${entry['balance'].toStringAsFixed(2)}');
    }
    
    return buffer.toString();
  }

  /// Show export options dialog
  void _showExportDialog() async {
    final hapticEnabled = ref.read(hapticFeedbackEnabledProvider);
    
    if (hapticEnabled) {
      HapticFeedback.lightImpact();
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Options'),
        content: const Text('Choose export format for your loan data:'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _exportAsCSV();
            },
            icon: const Icon(Icons.table_chart),
            label: const Text('CSV File'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _exportAsPDF();
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
  }
  
  /// Export as CSV file
  void _exportAsCSV() async {
    final loanAsync = ref.read(loanNotifierProvider);
    
    loanAsync.when(
      data: (loan) async {
        try {
          _showLoadingDialog('Generating CSV...');
          
          final filePath = await ExportService.exportToCSV(
            schedule: _filteredSchedule,
            includeSummary: true,
            loan: loan,
          );
          
          Navigator.of(context).pop(); // Close loading dialog
          
          await ExportService.shareFile(
            filePath: filePath,
            subject: 'Home Loan Amortization Schedule - CSV',
            text: 'Here is your detailed loan amortization schedule in CSV format.',
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('CSV file exported and shared successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          Navigator.of(context).pop(); // Close loading dialog
          _showErrorDialog('Failed to export CSV: $e');
        }
      },
      loading: () {},
      error: (error, stack) => _showErrorDialog('Error loading loan data: $error'),
    );
  }
  
  /// Export as PDF report
  void _exportAsPDF() async {
    final loanAsync = ref.read(loanNotifierProvider);
    
    loanAsync.when(
      data: (loan) async {
        try {
          _showLoadingDialog('Generating PDF report...');
          
          final filePath = await ExportService.exportToPDF(
            loan: loan,
            schedule: _filteredSchedule,
            yearlySummary: _yearlySummary,
            includeCharts: true,
          );
          
          Navigator.of(context).pop(); // Close loading dialog
          
          await ExportService.shareFile(
            filePath: filePath,
            subject: 'Home Loan Analysis Report - PDF',
            text: 'Here is your comprehensive home loan analysis report with charts and detailed breakdown.',
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF report exported and shared successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          Navigator.of(context).pop(); // Close loading dialog
          _showErrorDialog('Failed to export PDF: $e');
        }
      },
      loading: () {},
      error: (error, stack) => _showErrorDialog('Error loading loan data: $error'),
    );
  }
  
  /// Show loading dialog
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
  
  /// Show error dialog
  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loanAsync = ref.watch(loanNotifierProvider);
    
    return Scaffold(
      appBar: UnifiedHeader(
        title: 'Amortization Schedule',
        showLoanSummary: true,
        showBackButton: true,
        showSettingsButton: false,
        actions: [
          IconButton(
            onPressed: _showExportDialog,
            icon: const Icon(Icons.share),
            tooltip: 'Export & Share',
          ),
          IconButton(
            onPressed: () => _filterByYear(null),
            icon: const Icon(Icons.refresh),
            tooltip: 'Show All Months',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: loanAsync.when(
        data: (loan) => _buildContent(theme, loan),
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
                'Error loading schedule',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, LoanModel loan) {
    if (_fullSchedule.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Tab bar
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monthly View', icon: Icon(Icons.calendar_month)),
            Tab(text: 'Yearly Summary', icon: Icon(Icons.calendar_today)),
          ],
        ),
        
        // Summary card at the top
        _buildSummaryCard(theme, loan),
        
        // Filter options (only show for Monthly View)
        if (!_showYearlySummary) _buildFilterOptions(theme),
        
        // Tabbed content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMonthlyTable(theme),
              _buildYearlyTable(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(ThemeData theme, LoanModel loan) {
    final totalInterest = loan.totalInterest;
    final totalAmount = loan.totalAmount;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Loan Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  theme,
                  'Principal',
                  CurrencyFormatter.formatCurrencyCompact(loan.loanAmount),
                  theme.colorScheme.primary,
                ),
                _buildSummaryItem(
                  theme,
                  'Total Interest',
                  CurrencyFormatter.formatCurrencyCompact(totalInterest),
                  theme.colorScheme.error,
                ),
                _buildSummaryItem(
                  theme,
                  'Total Amount',
                  CurrencyFormatter.formatCurrencyCompact(totalAmount),
                  theme.colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOptions(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Years'),
                      selected: _selectedYear == null,
                      onSelected: (selected) {
                        if (selected) _filterByYear(null);
                      },
                    ),
                    
                    const SizedBox(width: 8),
                    
                    ..._availableYears.map((year) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('Year ${year - DateTime.now().year + 1}'),
                        selected: _selectedYear == year,
                        onSelected: (selected) {
                          if (selected) _filterByYear(year);
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            IconButton(
              onPressed: () {
                setState(() {
                  _showYearlySummary = !_showYearlySummary;
                });
              },
              icon: Icon(_showYearlySummary ? Icons.expand_less : Icons.expand_more),
              tooltip: 'Toggle yearly summary',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTable(ThemeData theme) {
    if (_filteredSchedule.isEmpty) {
      return const Center(
        child: Text('No data available for the selected filter'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Month', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('EMI', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Principal', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Interest', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Balance', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    )),
                  ),
                ],
              ),
            ),
            
            // Table data
            ...(_filteredSchedule.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: index.isEven 
                      ? theme.colorScheme.surface 
                      : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${row['month']}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['emi']),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['principal']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.financialColors.principalGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['interest']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.financialColors.interestRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['balance']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.financialColors.principalGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyTable(ThemeData theme) {
    if (_yearlySummary.isEmpty) {
      return const Center(
        child: Text('No yearly summary available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Year', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Total EMI', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Principal', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Interest', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Balance', style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondaryContainer,
                    )),
                  ),
                ],
              ),
            ),
            
            // Table data
            ...(_yearlySummary.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: index.isEven 
                      ? theme.colorScheme.surface 
                      : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${row['year']}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['totalEMI']),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['totalPrincipal']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.financialColors.principalGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['totalInterest']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.financialColors.interestRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        CurrencyFormatter.formatCurrencyCompact(row['endingBalance']),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.financialColors.principalGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
          ],
        ),
      ),
    );
  }
}