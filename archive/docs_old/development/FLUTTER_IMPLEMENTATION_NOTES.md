# Flutter Implementation Notes

## 🎨 IMPORTANT: Icon Guidelines

### Use Native Material Icons, NOT Emojis

The HTML mockups use emojis (🏠, 💰, 📈, etc.) for quick prototyping, but the Flutter implementation should use proper Material icons for professional quality.

### Icon Replacements

#### Bottom Navigation Icons
```dart
// Instead of emojis, use Material Icons:
'🏠' → Icons.home_rounded
'💰' → Icons.savings_rounded or Icons.account_balance_wallet_rounded
'📈' → Icons.trending_up_rounded
'📊' → Icons.calculate_rounded or Icons.assessment_rounded
```

#### Strategy Category Icons
```dart
// Category icons:
'🔥' → Icons.local_fire_department_rounded  // Instant Eye-openers
'📈' → Icons.trending_up_rounded             // Core Savings
'🧠' → Icons.psychology_rounded              // Tax & Investment
'🎯' → Icons.track_changes_rounded          // Behavioral
'👨‍👩‍👧' → Icons.family_restroom_rounded      // Life Planning
```

#### Dashboard Icons
```dart
// Dashboard elements:
'⚡' → Icons.bolt_rounded                    // Daily burn counter
'💡' → Icons.lightbulb_rounded              // Tips and insights
'🏆' → Icons.emoji_events_rounded           // Achievements
'⚙️' → Icons.settings_rounded               // Settings
```

#### Strategy Detail Icons
```dart
// Detail page sections:
'💰' → Icons.monetization_on_rounded        // Savings
'⏰' → Icons.schedule_rounded               // Time saved
'📊' → Icons.bar_chart_rounded             // Graphs
'💡' → Icons.tips_and_updates_rounded      // Pro tips
'⚠️' → Icons.warning_amber_rounded         // Warnings
```

### Why Native Icons?

1. **Performance**: Vector icons scale perfectly, smaller file size
2. **Consistency**: Material Design consistency across Android
3. **Accessibility**: Better screen reader support
4. **Theming**: Responds to dark/light mode automatically
5. **Professionalism**: Looks more polished than emojis
6. **Cross-platform**: Consistent rendering across devices

### Icon Implementation Example

```dart
// Bottom Navigation
BottomNavigationBarItem(
  icon: Icon(Icons.home_rounded),        // NOT Text('🏠')
  label: 'Home',
),

// List Items
ListTile(
  leading: Icon(
    Icons.savings_rounded,
    color: Theme.of(context).primaryColor,
    size: 24,
  ),
  title: Text('Extra EMI Strategy'),
  subtitle: Text('Save ₹7.2L'),
)
```

### Icon Sizing Guidelines

- **Bottom Navigation**: 24dp
- **List Icons**: 24dp
- **Header Icons**: 20dp
- **Large Feature Icons**: 48dp
- **Small Inline Icons**: 16dp

### Icon Colors

```dart
// Use theme colors, not hardcoded:
primary: Theme.of(context).primaryColor
success: Colors.green[600]
warning: Colors.orange[600]
error: Colors.red[600]
```

## 📱 Additional Implementation Notes

### Number Formatting
```dart
// Use Indian number formatting:
import 'package:intl/intl.dart';

final indianFormat = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

// Example: ₹30,00,000 (not ₹3000000)
```

### Navigation Pattern
```dart
// Use IndexedStack for bottom navigation to preserve state:
IndexedStack(
  index: _selectedIndex,
  children: [
    DashboardScreen(),
    StrategiesScreen(),
    ProgressScreen(),
    CalculatorScreen(),
  ],
)
```

### State Management
```dart
// Calculator is the single source of truth
// Use Provider/Riverpod to share loan data:
class LoanData extends ChangeNotifier {
  double loanAmount = 3000000;  // ₹30L default
  double interestRate = 8.5;    // 8.5% default
  int tenure = 20;               // 20 years default
  
  // Optional fields
  double? monthlyIncome = 100000;
  int? age = 30;
  LoanStatus status = LoanStatus.planning;
  int monthsPaid = 0;
}
```

### Animations
```dart
// Keep animations subtle and meaningful:
Duration: 250-350ms for most transitions
Curves: Curves.easeOutCubic for enter
        Curves.easeInCubic for exit
```

### Colors (Material 3)
```dart
// Use the CSS variables as reference:
primaryBlue: Color(0xFF1565C0)
growthTeal: Color(0xFF00796B)
warningOrange: Color(0xFFFF8F00)
successGreen: Color(0xFF388E3C)
errorRed: Color(0xFFD32F2F)
```

### Responsive Design
```dart
// Support these breakpoints:
Mobile: 360-414 width (primary target)
Tablet: 600+ width (future enhancement)

// Use MediaQuery for responsive sizing:
final width = MediaQuery.of(context).size.width;
final isMobile = width < 600;
```

### Offline-First Architecture
```dart
// All calculations must work offline:
- No API calls for core features
- Use SharedPreferences for persistence
- Optional Firebase Analytics only
- All 20 strategies calculate locally
```

### Testing Checklist
- [ ] All calculations match mockup values
- [ ] Navigation preserves state
- [ ] Loan parameters persist between sessions
- [ ] All 20 strategies show correct savings
- [ ] Progress tracking works for both loan statuses
- [ ] No emojis - all native icons
- [ ] Indian number formatting throughout
- [ ] Smooth animations (60fps)
- [ ] Works offline completely

---

**Remember**: The HTML mockups are visual references. The Flutter implementation should use native components and follow Material Design guidelines while maintaining the same user experience.