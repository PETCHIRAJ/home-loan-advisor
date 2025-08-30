import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/calculation_history.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const HistoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onBookmark,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name/date and bookmark
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.name != null) ...[
                          Text(
                            item.name!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          _formatDate(item.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bookmark and more actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onBookmark,
                        icon: Icon(
                          item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: item.isBookmarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      PopupMenuButton<String>(
                        onSelected: _handleMenuAction,
                        icon: Icon(
                          Icons.more_vert,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: const EdgeInsets.all(4),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share, size: 20),
                                SizedBox(width: 12),
                                Text('Share'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 12),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Loan details grid
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Loan Amount',
                      '₹${_formatCurrency(item.loanAmount)}',
                      colorScheme,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailItem(
                      'Monthly EMI',
                      '₹${_formatCurrency(item.monthlyEMI)}',
                      colorScheme,
                      theme,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Interest Rate',
                      '${item.interestRate.toStringAsFixed(2)}%',
                      colorScheme,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailItem(
                      'Tenure',
                      '${item.tenureYears} years',
                      colorScheme,
                      theme,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Total Interest',
                      '₹${_formatCurrency(item.totalInterest)}',
                      colorScheme,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDetailItem(
                      'Tax Savings',
                      '₹${_formatCurrency(item.taxSavings)}/year',
                      colorScheme,
                      theme,
                    ),
                  ),
                ],
              ),
              
              // Benefits badges
              if (item.hasPMAY || item.taxSavings > 0) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    if (item.hasPMAY)
                      Chip(
                        label: const Text('PMAY Eligible'),
                        backgroundColor: colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: 12,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    if (item.taxSavings > 0)
                      Chip(
                        label: const Text('Tax Benefits'),
                        backgroundColor: colorScheme.tertiaryContainer,
                        labelStyle: TextStyle(
                          color: colorScheme.onTertiaryContainer,
                          fontSize: 12,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        onShare();
        break;
      case 'delete':
        onDelete();
        break;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (date.year == now.year) {
      return DateFormat('MMM d, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) { // 1 crore
      return '${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) { // 1 lakh
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) { // 1 thousand
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}