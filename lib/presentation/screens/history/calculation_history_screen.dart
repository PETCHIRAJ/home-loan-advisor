import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';
import '../../../domain/entities/calculation_history.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';
import 'widgets/history_item_card.dart';
import 'widgets/history_filter_sheet.dart';
import 'widgets/history_stats_card.dart';

class CalculationHistoryScreen extends ConsumerStatefulWidget {
  const CalculationHistoryScreen({super.key});

  @override
  ConsumerState<CalculationHistoryScreen> createState() => _CalculationHistoryScreenState();
}

class _CalculationHistoryScreenState extends ConsumerState<CalculationHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Listen to search changes
    _searchController.addListener(() {
      ref.read(historyFilterNotifierProvider.notifier).updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Calculation History',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: Icon(Icons.tune, color: colorScheme.primary),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_csv',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 12),
                    Text('Export CSV'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_text',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 12),
                    Text('Share as Text'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Clear All', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Bookmarked'),
            Tab(text: 'Statistics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllHistoryTab(),
          _buildBookmarkedTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildAllHistoryTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final groupedHistoryAsync = ref.watch(groupedHistoryItemsProvider);
              
              return groupedHistoryAsync.when(
                data: (groupedHistory) => _buildHistoryList(groupedHistory),
                loading: () => const LoadingWidget(),
                error: (error, stack) => AppErrorWidget(
                  error: error.toString(),
                  onRetry: () => ref.refresh(groupedHistoryItemsProvider),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkedTab() {
    return Consumer(
      builder: (context, ref, child) {
        final bookmarkedAsync = ref.watch(bookmarkedHistoryProvider);
        
        return bookmarkedAsync.when(
          data: (bookmarkedHistory) {
            if (bookmarkedHistory.isEmpty) {
              return _buildEmptyState(
                icon: Icons.bookmark_border,
                title: 'No Bookmarked Calculations',
                subtitle: 'Bookmark important calculations to access them quickly.',
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedHistory.length,
              itemBuilder: (context, index) {
                final history = bookmarkedHistory[index];
                final item = HistoryItem.fromCalculationHistory(history);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HistoryItemCard(
                    item: item,
                    onTap: () => _loadCalculation(history),
                    onBookmark: () => _toggleBookmark(item.id),
                    onDelete: () => _deleteHistory(item.id),
                    onShare: () => _shareCalculation(history),
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, stack) => AppErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(bookmarkedHistoryProvider),
          ),
        );
      },
    );
  }

  Widget _buildStatsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final statsAsync = ref.watch(historyStatsProvider);
        
        return statsAsync.when(
          data: (stats) => Padding(
            padding: const EdgeInsets.all(16),
            child: HistoryStatsCard(stats: stats),
          ),
          loading: () => const LoadingWidget(),
          error: (error, stack) => AppErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(historyStatsProvider),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search calculations...',
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(historyFilterNotifierProvider.notifier).updateSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  Widget _buildHistoryList(Map<String, List<HistoryItem>> groupedHistory) {
    if (groupedHistory.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Calculation History',
        subtitle: 'Your calculated EMIs will appear here for easy reference.',
      );
    }

    // Sort groups by priority (Today, Yesterday, This Week, Older)
    final sortedGroups = groupedHistory.entries.toList()
      ..sort((a, b) {
        const order = ['Today', 'Yesterday', 'This Week', 'Older'];
        return order.indexOf(a.key).compareTo(order.indexOf(b.key));
      });

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: sortedGroups.length,
      itemBuilder: (context, groupIndex) {
        final group = sortedGroups[groupIndex];
        final groupName = group.key;
        final items = group.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                groupName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            // Group items
            ...items.map((item) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: HistoryItemCard(
                item: item,
                onTap: () => _loadCalculationFromItem(item),
                onBookmark: () => _toggleBookmark(item.id),
                onDelete: () => _deleteHistory(item.id),
                onShare: () => _shareCalculationFromItem(item),
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HistoryFilterSheet(),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_csv':
        _exportCSV();
        break;
      case 'export_text':
        _exportText();
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
    }
  }

  Future<void> _exportCSV() async {
    try {
      final csv = await ref.read(historyActionsProvider.notifier).exportAsCSV();
      await Clipboard.setData(ClipboardData(text: csv));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('CSV data copied to clipboard'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _exportText() async {
    try {
      final text = await ref.read(historyActionsProvider.notifier).exportAsText();
      await Clipboard.setData(ClipboardData(text: text));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Text data copied to clipboard'),
            action: SnackBarAction(
              label: 'Share',
              onPressed: () {
                // TODO: Implement native sharing
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showClearAllDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to delete all calculation history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllHistory();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllHistory() async {
    try {
      await ref.read(historyActionsProvider.notifier).clearAllHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All history cleared successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear history: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleBookmark(String id) async {
    try {
      await ref.read(historyActionsProvider.notifier).toggleBookmark(id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bookmark updated'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update bookmark: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteHistory(String id) async {
    try {
      await ref.read(historyActionsProvider.notifier).deleteHistory(id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('History item deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // TODO: Implement undo functionality
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadCalculation(CalculationHistory history) async {
    // TODO: Navigate back to calculator with these parameters
    Navigator.of(context).pop(history);
  }

  Future<void> _loadCalculationFromItem(HistoryItem item) async {
    try {
      final history = await ref.read(historyActionsProvider.notifier).getHistoryById(item.id);
      if (history != null) {
        await _loadCalculation(history);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load calculation: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _shareCalculation(CalculationHistory history) async {
    final summary = history.generateSummary();
    await Clipboard.setData(ClipboardData(text: summary));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Calculation summary copied to clipboard'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () {
              // TODO: Implement native sharing
            },
          ),
        ),
      );
    }
  }

  Future<void> _shareCalculationFromItem(HistoryItem item) async {
    try {
      final history = await ref.read(historyActionsProvider.notifier).getHistoryById(item.id);
      if (history != null) {
        await _shareCalculation(history);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}