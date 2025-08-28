import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/loan_provider.dart';
import '../../core/utils/theme_verification.dart';
import '../../screens/main_navigation.dart';

/// Unified header component for consistent app-wide header design
/// 
/// Features:
/// - Single, consistent design across all screens
/// - Smart loan summary display with dynamic data
/// - Professional horizontal layout with title on left and loan summary on right
/// - Responsive design with proper text overflow handling
/// - Visual separator between title and loan summary for clarity
/// - Optional back navigation
/// - Settings/action button support
/// - Consistent height, padding, colors, and fonts
/// - Loading and error states with appropriate visual indicators
class UnifiedHeader extends ConsumerWidget implements PreferredSizeWidget {
  const UnifiedHeader({
    super.key,
    this.title,
    this.showLoanSummary = true,
    this.showBackButton = false,
    this.actions,
    this.onBackPressed,
    this.showSettingsButton = true,
    this.currentTabIndex,
  });

  final String? title;
  final bool showLoanSummary;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showSettingsButton;
  final int? currentTabIndex;

  @override
  Size get preferredSize => const Size.fromHeight(56); // Increased height for better visual consistency

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loanAsync = ref.watch(loanNotifierProvider);
    
    // Debug: Print theme diagnostics in debug mode
    assert(() {
      ThemeVerification.printDiagnostics(context);
      return true;
    }());

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      leadingWidth: showBackButton ? null : 0,
      titleSpacing: showBackButton ? null : 16,
      
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              tooltip: 'Back',
            )
          : const SizedBox.shrink(),
      
      title: _buildTitle(context, theme, loanAsync),
      
      actions: actions ?? _buildDefaultActions(context, theme),
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context, ThemeData theme) {
    // Don't show settings button on Calculator tab (index 3)
    if (!showSettingsButton || currentTabIndex == 3) return [];
    
    return [
      IconButton(
        icon: const Icon(
          Icons.settings,
          size: 24,
        ),
        onPressed: () => _navigateToCalculator(context),
        tooltip: 'Calculator Settings',
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildTitle(BuildContext context, ThemeData theme, AsyncValue loanAsync) {
    if (showLoanSummary) {
      return loanAsync.when(
        data: (loan) => _buildLoanSummaryTitle(theme, loan),
        loading: () => _buildLoadingTitle(theme),
        error: (_, __) => _buildErrorTitle(theme),
      );
    }
    
    if (title != null) {
      return Text(
        title!,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: const Color(0xFF212121),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoanSummaryTitle(ThemeData theme, dynamic loan) {
    try {
      final amountInLakhs = (loan.loanAmount / 100000).round();
      final loanSummary = '₹${amountInLakhs}L @ ${loan.annualInterestRate.toStringAsFixed(1)}% • ${loan.tenureYears}yr';
    
    if (title != null) {
      return Row(
        children: [
          // Title on the left
          Flexible(
            flex: 2,
            child: Text(
              title!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF212121),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Spacing between title and loan summary
          const SizedBox(width: 12),
          
          // Vertical divider for visual separation
          Container(
            height: 20,
            width: 1,
            color: const Color(0xFFE0E0E0),
          ),
          
          const SizedBox(width: 12),
          
          // Loan summary on the right
          Flexible(
            flex: 3,
            child: Text(
              loanSummary,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: const Color(0xFF666666),
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    }
    
    return Text(
      loanSummary,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: const Color(0xFF212121),
      ),
    );
    } catch (e) {
      // Fallback in case of any errors with loan data
      return Text(
        'Invalid loan data',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: theme.colorScheme.error,
        ),
      );
    }
  }

  Widget _buildLoadingTitle(ThemeData theme) {
    if (title != null) {
      return Row(
        children: [
          // Title on the left
          Flexible(
            flex: 2,
            child: Text(
              title!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF212121),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Spacing between title and loading state
          const SizedBox(width: 12),
          
          // Vertical divider for visual separation
          Container(
            height: 20,
            width: 1,
            color: const Color(0xFFE0E0E0),
          ),
          
          const SizedBox(width: 12),
          
          // Loading state on the right
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Loading...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Loading...',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorTitle(ThemeData theme) {
    if (title != null) {
      return Row(
        children: [
          // Title on the left
          Flexible(
            flex: 2,
            child: Text(
              title!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF212121),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Spacing between title and error state
          const SizedBox(width: 12),
          
          // Vertical divider for visual separation
          Container(
            height: 20,
            width: 1,
            color: const Color(0xFFE0E0E0),
          ),
          
          const SizedBox(width: 12),
          
          // Error state on the right
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 12,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 6),
                Text(
                  'No loan data',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 14,
          color: theme.colorScheme.error,
        ),
        const SizedBox(width: 8),
        Text(
          'No loan data',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _navigateToCalculator(BuildContext context) {
    // Find the MainNavigation state and navigate to Calculator tab
    try {
      // Look for the MainNavigationState specifically
      final mainNavState = context.findAncestorStateOfType<State<MainNavigation>>();
      if (mainNavState != null && mainNavState is State<MainNavigation>) {
        // Cast to the specific state type and call the public navigation method
        final navState = mainNavState as dynamic;
        if (navState.navigateToTab != null) {
          navState.navigateToTab(3); // Navigate to Calculator tab (index 3)
          return;
        }
      }
    } catch (e) {
      // If navigation fails, fall back to showing a message
      print('Navigation failed: $e');
    }
    
    // Fallback: Show a helpful message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please go to the Calculator tab for loan settings'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}