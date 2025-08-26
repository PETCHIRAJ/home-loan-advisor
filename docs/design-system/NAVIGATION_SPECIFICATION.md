# Navigation Specification - Home Loan Advisor

## Design Brief
This specification resolves the navigation consistency issue by defining the exact 4-tab structure for the Home Loan Advisor app. The design consolidates Profile functionality into the Calculator tab for a streamlined user experience while maintaining easy access to all core features.

## Final Navigation Structure: 4 Tabs

### Tab 1: Home 🏠
- **Purpose**: Dashboard with live burn counter, loan health score, and quick insights
- **Material Icon**: `home` (rounded variant)
- **Active State**: Primary blue (#1565C0) with subtle background tint
- **Content**: 
  - Live money burn counter
  - Loan health score visualization
  - Daily money-saving tips
  - Quick loan insights
  - CTA to strategies

### Tab 2: Strategies 💰
- **Purpose**: Browse and explore 20 money-saving strategies
- **Material Icon**: `savings` (rounded variant)
- **Active State**: Primary blue (#1565C0) with subtle background tint
- **Content**:
  - Strategy categories (Prepayment, Refinancing, Tax Benefits, etc.)
  - Strategy cards with impact previews
  - Filtering and sorting options
  - Strategy detail views

### Tab 3: Progress 📈
- **Purpose**: Track loan progress and visualize savings
- **Material Icon**: `trending_up` (rounded variant)
- **Active State**: Primary blue (#1565C0) with subtle background tint
- **Content**:
  - Loan progress visualization
  - Interest vs principal breakdown
  - Strategy impact tracking
  - Milestone celebrations
  - Historical data charts

### Tab 4: Calculator 📊
- **Purpose**: EMI calculation, loan configuration, AND settings/profile
- **Material Icon**: `calculate` (rounded variant)
- **Active State**: Primary blue (#1565C0) with subtle background tint
- **Integrated Functionality**:
  - EMI calculator with sliders
  - Loan parameter configuration
  - Advanced calculations (prepayment, refinancing)
  - **Settings section**: Privacy policy, terms, about
  - **Profile section**: User preferences, calculation history
  - Data export options

## Smart Header Navigation
All screens include a smart header that shows current loan summary and provides quick access to calculator:

```
[₹30L @ 8.5% • 20yr] ............................ [⚙️]
```

- **Tap anywhere**: Navigate to Calculator tab
- **Settings icon**: Open calculator settings drawer
- **Dynamic content**: Updates based on current loan parameters

## Navigation Implementation Specs

### Bottom Tab Bar Design
```css
.bottom-nav {
  height: 64px;
  background: #FFFFFF;
  border-top: 1px solid #E0E0E0;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
  padding: 8px 16px;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 8px;
  border-radius: 8px;
  min-height: 48px; /* Accessibility touch target */
}

.nav-item.active {
  color: #1565C0;
  background-color: rgba(21, 101, 192, 0.08);
}

.nav-icon {
  font-size: 24px;
  margin-bottom: 2px;
}

.nav-label {
  font-size: 12px;
  font-weight: 500;
}
```

### Material Icon Specifications
| Tab | Emoji (Old) | Material Icon | Icon Code |
|-----|-------------|---------------|-----------|
| Home | 🏠 | home_rounded | `Icons.home_rounded` |
| Strategies | 💰 | savings_rounded | `Icons.savings_rounded` |
| Progress | 📈 | trending_up_rounded | `Icons.trending_up_rounded` |
| Calculator | 📊 | calculate_rounded | `Icons.calculate_rounded` |

### Accessibility Specifications
- **Touch Targets**: Minimum 48x48dp for all tab buttons
- **Focus Indicators**: 2px blue outline when focused via keyboard
- **Screen Reader Labels**: 
  - "Home tab, currently selected"
  - "Strategies tab, button"
  - "Progress tab, button"
  - "Calculator tab, button"
- **Semantic HTML**: Use `<nav>` with `role="tablist"` for web

### State Management
```dart
enum NavigationTab {
  home(0, 'Home', Icons.home_rounded),
  strategies(1, 'Strategies', Icons.savings_rounded),
  progress(2, 'Progress', Icons.trending_up_rounded),
  calculator(3, 'Calculator', Icons.calculate_rounded);

  const NavigationTab(this.index, this.label, this.icon);
  final int index;
  final String label;
  final IconData icon;
}
```

### Navigation Flow Logic
1. **App Launch**: Default to Home tab
2. **Deep Links**: Support direct navigation to any tab
3. **Back Button**: Within tab content only, not between tabs
4. **State Persistence**: Remember last active tab between sessions
5. **Smart Header**: Always available, navigates to Calculator

### Animation Specifications
- **Tab Switch**: 250ms ease-out transition
- **Icon Scale**: 1.0 → 1.1 → 1.0 on tap (150ms total)
- **Ripple Effect**: Material ripple on tab press
- **Content Transition**: Fade between tab contents (300ms)

### Responsive Considerations
- **Small screens (320px)**: Reduce padding, shorter labels
- **Large screens (414px+)**: Standard spacing as specified
- **Tablet mode**: Not supported (portrait only app)

## User Experience Rationale

### Why 4 Tabs Instead of 5
1. **Cognitive Load**: 4 tabs fit comfortably in mobile viewport
2. **Thumb Reach**: All tabs accessible with single thumb
3. **Feature Integration**: Settings naturally belong with Calculator
4. **User Testing**: Less navigation confusion with fewer tabs

### Profile Integration Benefits
- **Streamlined UX**: Settings accessed from context of use
- **Reduced Clutter**: Eliminates rarely-used profile page
- **Logical Grouping**: Calculator configurations and app settings together
- **Faster Access**: No separate navigation to change loan parameters

This navigation specification provides zero ambiguity for Flutter implementation while ensuring optimal user experience across all device sizes and accessibility requirements.