import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/history_provider.dart';
import '../../../../domain/entities/calculation_history.dart';

class HistoryFilterSheet extends ConsumerStatefulWidget {
  const HistoryFilterSheet({super.key});

  @override
  ConsumerState<HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends ConsumerState<HistoryFilterSheet> {
  late HistoryFilterState _filterState;
  DateTime? _tempStartDate;
  DateTime? _tempEndDate;

  @override
  void initState() {
    super.initState();
    _filterState = ref.read(historyFilterNotifierProvider);
    _tempStartDate = _filterState.startDate;
    _tempEndDate = _filterState.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Filter & Sort',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _resetFilters,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter section
                      _buildSectionHeader('Filter by'),
                      const SizedBox(height: 12),
                      _buildFilterOptions(),
                      
                      const SizedBox(height: 24),
                      
                      // Date range section (only show if custom range is selected)
                      if (_filterState.currentFilter == HistoryFilter.customRange) ...[
                        _buildSectionHeader('Date Range'),
                        const SizedBox(height: 12),
                        _buildDateRangeSelector(),
                        const SizedBox(height: 24),
                      ],
                      
                      // Sort section
                      _buildSectionHeader('Sort by'),
                      const SizedBox(height: 12),
                      _buildSortOptions(),
                      
                      const SizedBox(height: 80), // Space for apply button
                    ],
                  ),
                ),
              ),
              
              // Apply button
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _applyFilters,
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildFilterOptions() {
    final filterOptions = [
      (HistoryFilter.all, 'All Calculations', Icons.list),
      (HistoryFilter.bookmarked, 'Bookmarked Only', Icons.bookmark),
      (HistoryFilter.today, 'Today', Icons.today),
      (HistoryFilter.thisWeek, 'This Week', Icons.date_range),
      (HistoryFilter.thisMonth, 'This Month', Icons.calendar_month),
      (HistoryFilter.lastMonth, 'Last Month', Icons.calendar_view_month),
      (HistoryFilter.customRange, 'Custom Range', Icons.date_range_outlined),
    ];

    return Column(
      children: filterOptions.map((option) {
        final (filter, title, icon) = option;
        final isSelected = _filterState.currentFilter == filter;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: isSelected 
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ) 
                : null,
            onTap: () {
              setState(() {
                _filterState = _filterState.copyWith(currentFilter: filter);
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateRangeSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(true),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              _tempStartDate != null
                  ? '${_tempStartDate!.day}/${_tempStartDate!.month}/${_tempStartDate!.year}'
                  : 'Start Date',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'to',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(false),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              _tempEndDate != null
                  ? '${_tempEndDate!.day}/${_tempEndDate!.month}/${_tempEndDate!.year}'
                  : 'End Date',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    final sortOptions = [
      (HistorySortBy.dateNewest, 'Date (Newest First)', Icons.schedule),
      (HistorySortBy.dateOldest, 'Date (Oldest First)', Icons.history),
      (HistorySortBy.loanAmountHigh, 'Loan Amount (High to Low)', Icons.trending_down),
      (HistorySortBy.loanAmountLow, 'Loan Amount (Low to High)', Icons.trending_up),
      (HistorySortBy.emiHigh, 'EMI (High to Low)', Icons.money_off),
      (HistorySortBy.emiLow, 'EMI (Low to High)', Icons.attach_money),
      (HistorySortBy.interestRateHigh, 'Interest Rate (High to Low)', Icons.percent),
      (HistorySortBy.interestRateLow, 'Interest Rate (Low to High)', Icons.low_priority),
    ];

    return Column(
      children: sortOptions.map((option) {
        final (sortBy, title, icon) = option;
        final isSelected = _filterState.sortBy == sortBy;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: isSelected 
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ) 
                : null,
            onTap: () {
              setState(() {
                _filterState = _filterState.copyWith(sortBy: sortBy);
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final initialDate = isStartDate ? _tempStartDate : _tempEndDate;
    final firstDate = DateTime(2020);
    final lastDate = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _tempStartDate = selectedDate;
        } else {
          _tempEndDate = selectedDate;
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _filterState = const HistoryFilterState();
      _tempStartDate = null;
      _tempEndDate = null;
    });
  }

  void _applyFilters() {
    final notifier = ref.read(historyFilterNotifierProvider.notifier);
    
    notifier.updateFilter(_filterState.currentFilter);
    notifier.updateSortBy(_filterState.sortBy);
    
    if (_filterState.currentFilter == HistoryFilter.customRange) {
      notifier.updateDateRange(_tempStartDate, _tempEndDate);
    }
    
    Navigator.of(context).pop();
  }
}