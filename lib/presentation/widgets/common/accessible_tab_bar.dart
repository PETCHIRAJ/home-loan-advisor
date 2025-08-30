import 'package:flutter/material.dart';

/// Enhanced TabBar with minimum 48dp touch targets and improved accessibility
class AccessibleTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController? controller;
  final Function(int)? onTap;
  final Color? backgroundColor;
  final double height;
  final EdgeInsets? padding;
  final bool isScrollable;

  const AccessibleTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.backgroundColor,
    this.height = 56.0, // Comfortable touch target
    this.padding,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: tabs.map((tab) => _buildAccessibleTab(context, tab)).toList(),
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurface,
        labelStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        isScrollable: isScrollable,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      ),
    );
  }

  Widget _buildAccessibleTab(BuildContext context, Tab tab) {
    return SizedBox(
      height: height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child:
              tab.child ??
              Text(
                tab.text ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        ),
      ),
    );
  }
}

/// Enhanced button component with proper touch targets and Material 3 styling
enum ButtonType { primary, secondary, outlined, text, small, large }

class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const AccessibleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? _getButtonHeight();
    final buttonStyle = _getButtonStyle(context);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(context)),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _getTextColor(context),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: Padding(
          padding: padding ?? _getDefaultPadding(),
          child: buttonChild,
        ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (type) {
      case ButtonType.large:
        return 64.0; // Large touch target
      case ButtonType.small:
        return 40.0; // Still accessible but compact
      default:
        return 48.0; // Standard comfortable touch target
    }
  }

  EdgeInsets _getDefaultPadding() {
    switch (type) {
      case ButtonType.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonType.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      default:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(context),
      foregroundColor: _getTextColor(context),
      elevation: _getElevation(),
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: type == ButtonType.outlined
            ? BorderSide(color: colorScheme.outline)
            : BorderSide.none,
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return _getTextColor(context).withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return _getTextColor(context).withValues(alpha: 0.12);
        }
        return null;
      }).resolve({}),
    );
  }

  double _getElevation() {
    switch (type) {
      case ButtonType.primary:
        return 2.0;
      case ButtonType.secondary:
        return 1.0;
      default:
        return 0.0;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ButtonType.primary:
        return colorScheme.primary;
      case ButtonType.secondary:
        return colorScheme.secondaryContainer;
      case ButtonType.outlined:
      case ButtonType.text:
        return Colors.transparent;
      default:
        return colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ButtonType.primary:
        return colorScheme.onPrimary;
      case ButtonType.secondary:
        return colorScheme.onSecondaryContainer;
      case ButtonType.outlined:
      case ButtonType.text:
        return colorScheme.primary;
      default:
        return colorScheme.onPrimary;
    }
  }
}
