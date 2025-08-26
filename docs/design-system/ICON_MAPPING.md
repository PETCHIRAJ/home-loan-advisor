# Icon Mapping Specification - Home Loan Advisor

## Design Brief
This specification maps all emojis used in HTML mockups to specific Material Icons for consistent Flutter implementation. The design prioritizes rounded icon variants for a modern, approachable aesthetic while ensuring semantic accuracy and accessibility compliance.

## Complete Emoji to Material Icon Mapping

### Navigation Icons (Bottom Tab Bar)
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Home Tab | 🏠 | `home_rounded` | `Icons.home_rounded` | Dashboard/main screen |
| Strategies Tab | 💰 | `savings_rounded` | `Icons.savings_rounded` | Money-saving strategies |
| Progress Tab | 📈 | `trending_up_rounded` | `Icons.trending_up_rounded` | Growth/progress tracking |
| Calculator Tab | 📊 | `calculate_rounded` | `Icons.calculate_rounded` | Calculations/tools |

### Smart Header Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Settings Access | ⚙️ | `settings_rounded` | `Icons.settings_rounded` | App configuration |
| Loan Summary | 💳 | `credit_card_rounded` | `Icons.credit_card_rounded` | Loan information |

### Dashboard Content Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Burn Counter | ⚡ | `flash_on_rounded` | `Icons.flash_on_rounded` | Live/active burning |
| House/Loan | 🏠 | `home_rounded` | `Icons.home_rounded` | Property/loan reference |
| Light Bulb/Tip | 💡 | `lightbulb_rounded` | `Icons.lightbulb_rounded` | Ideas/suggestions |
| Chart/Insights | 📊 | `bar_chart_rounded` | `Icons.bar_chart_rounded` | Data visualization |
| Money/EMI | 💳 | `credit_card_rounded` | `Icons.credit_card_rounded` | Payment information |
| Target/Goals | 🎯 | `gps_fixed_rounded` | `Icons.gps_fixed_rounded` | Targets/milestones |

### Strategy Category Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Prepayment | 💰 | `account_balance_wallet_rounded` | `Icons.account_balance_wallet_rounded` | Extra payments |
| Refinancing | 🔄 | `sync_rounded` | `Icons.sync_rounded` | Loan switching |
| Tax Benefits | 📋 | `receipt_long_rounded` | `Icons.receipt_long_rounded` | Documentation/tax |
| Part Payment | ⚡ | `bolt_rounded` | `Icons.bolt_rounded` | Quick actions |
| Tenure Reduction | ⏰ | `timer_rounded` | `Icons.timer_rounded` | Time optimization |
| Interest Rate | 📈 | `trending_down_rounded` | `Icons.trending_down_rounded` | Rate reduction |

### Progress Tracking Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Progress Chart | 📈 | `show_chart_rounded` | `Icons.show_chart_rounded` | Progress visualization |
| Milestone | 🎉 | `celebration_rounded` | `Icons.celebration_rounded` | Achievement |
| Calendar | 📅 | `calendar_month_rounded` | `Icons.calendar_month_rounded` | Time tracking |
| Savings | 💎 | `diamond_rounded` | `Icons.diamond_rounded` | Value/savings |

### Calculator Screen Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Amount Input | 💰 | `currency_rupee_rounded` | `Icons.currency_rupee_rounded` | Indian currency |
| Interest Rate | 📊 | `percent_rounded` | `Icons.percent_rounded` | Percentage input |
| Time Period | ⏰ | `schedule_rounded` | `Icons.schedule_rounded` | Duration |
| Export | 📤 | `file_download_rounded` | `Icons.file_download_rounded` | Data export |
| History | 📋 | `history_rounded` | `Icons.history_rounded` | Past calculations |

### Action/Button Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Calculate/Compute | 🧮 | `functions_rounded` | `Icons.functions_rounded` | Mathematical operations |
| View Details | 👁️ | `visibility_rounded` | `Icons.visibility_rounded` | Show more information |
| Share Results | 📤 | `share_rounded` | `Icons.share_rounded` | Social sharing |
| Reset/Clear | 🔄 | `refresh_rounded` | `Icons.refresh_rounded` | Reset to defaults |
| Help/Info | ❓ | `help_rounded` | `Icons.help_rounded` | User assistance |

### Status/State Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Success/Good | ✅ | `check_circle_rounded` | `Icons.check_circle_rounded` | Positive outcome |
| Warning/Caution | ⚠️ | `warning_rounded` | `Icons.warning_rounded` | Attention needed |
| Error/Problem | ❌ | `error_rounded` | `Icons.error_rounded` | Issue/problem |
| Information | ℹ️ | `info_rounded` | `Icons.info_rounded` | Neutral information |

### Utility Icons
| Context | Emoji | Material Icon | Flutter Code | Semantic Meaning |
|---------|-------|---------------|--------------|------------------|
| Search | 🔍 | `search_rounded` | `Icons.search_rounded` | Find/filter content |
| Filter | 📝 | `tune_rounded` | `Icons.tune_rounded` | Refine results |
| Sort | 🔀 | `sort_rounded` | `Icons.sort_rounded` | Organize content |
| Menu | ☰ | `menu_rounded` | `Icons.menu_rounded` | Navigation drawer |

## Implementation Guidelines

### Icon Size Standards
```dart
// Icon size constants
class AppIconSizes {
  static const double small = 16.0;      // Inline text icons
  static const double medium = 24.0;     // Standard UI icons
  static const double large = 32.0;      // Section headers
  static const double extraLarge = 48.0; // Hero icons
}
```

### Color Specifications
```dart
// Icon colors based on context
class AppIconColors {
  static const Color primary = Color(0xFF1565C0);      // Active/selected
  static const Color secondary = Color(0xFF757575);    // Inactive/normal
  static const Color success = Color(0xFF388E3C);      // Positive actions
  static const Color warning = Color(0xFFFF8F00);      // Caution
  static const Color error = Color(0xFFD32F2F);        // Errors
  static const Color surface = Color(0xFF212121);      // On light backgrounds
  static const Color onSurface = Color(0xFFFFFFFF);    // On dark backgrounds
}
```

### Accessibility Implementation
```dart
// Semantic labels for screen readers
Map<IconData, String> iconSemanticLabels = {
  Icons.home_rounded: 'Home',
  Icons.savings_rounded: 'Money saving strategies',
  Icons.trending_up_rounded: 'Progress tracking',
  Icons.calculate_rounded: 'Calculator and settings',
  Icons.settings_rounded: 'Settings menu',
  Icons.lightbulb_rounded: 'Money saving tip',
  // ... continue for all icons
};
```

### Usage Examples
```dart
// Standard icon usage
Icon(
  Icons.home_rounded,
  size: AppIconSizes.medium,
  color: AppIconColors.primary,
  semanticLabel: 'Home',
)

// Icon button with proper accessibility
IconButton(
  onPressed: () => navigateToHome(),
  icon: Icon(Icons.home_rounded),
  iconSize: AppIconSizes.medium,
  color: AppIconColors.primary,
  tooltip: 'Go to home screen',
)

// Icon with text combination
Row(
  children: [
    Icon(
      Icons.currency_rupee_rounded,
      size: AppIconSizes.small,
      color: AppIconColors.secondary,
    ),
    SizedBox(width: 4),
    Text('30,00,000'),
  ],
)
```

## Design System Integration

### Icon Component Wrapper
```dart
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  
  const AppIcon({
    Key? key,
    required this.icon,
    this.size,
    this.color,
    this.semanticLabel,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? AppIconSizes.medium,
      color: color ?? AppIconColors.secondary,
      semanticLabel: semanticLabel ?? iconSemanticLabels[icon],
    );
  }
}
```

### Consistency Rules
1. **Always use rounded variants** when available
2. **Consistent sizing** using AppIconSizes constants
3. **Semantic labels** for all decorative icons
4. **Color inheritance** from parent theme when possible
5. **Touch targets** minimum 48x48dp for interactive icons

### Testing Requirements
- [ ] All emojis replaced with Material Icons
- [ ] Icons render correctly in both light and dark themes
- [ ] Screen readers announce icon purposes correctly
- [ ] Icons scale properly across different screen sizes
- [ ] Touch targets meet accessibility guidelines (48x48dp minimum)
- [ ] Icons maintain visual hierarchy (size indicates importance)

## Migration Checklist
- [ ] Replace all emoji references in HTML mockups
- [ ] Update wireframe documentation with Material Icon names
- [ ] Verify icon availability in target Flutter version
- [ ] Test icon readability on all background colors
- [ ] Ensure semantic labels are culturally appropriate
- [ ] Document any custom icons needed (none currently)

This comprehensive mapping eliminates any ambiguity about icon usage and ensures consistent, accessible implementation across the entire Home Loan Advisor app.