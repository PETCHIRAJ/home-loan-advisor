# Strategies Screen Wireframe

## Layout Overview
The strategies screen presents 7 actionable money-saving strategies with clear savings amounts. Focus on scannable cards with progressive disclosure.

## ASCII Wireframe

```
┌─────────────────────────────────────┐ ← StatusBar
│ 💡 Savings Strategies          [🔍] │ ← Header with search
├─────────────────────────────────────┤
│                                     │
│  💰 Total Potential Savings         │ ← Hero section
│      ₹ 12,50,000                    │
│   across all applicable strategies  │
│                                     │
│  [ Combination Calculator ]         │ ← CTA for multiple strategies
│                                     │
├─────────────────────────────────────┤
│  🏷️ Quick Filters                   │
│  [All] [<₹2L] [₹2L-5L] [>₹5L] [⚡] │ ← Filter tabs
├─────────────────────────────────────┤
│                                     │
│ STRATEGIES (7)                      │ ← Section title with count
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔄 Balance Transfer         [>] │ │
│ │ SAVE ₹ 3,50,000                │ │ ← Prominent savings
│ │ Lower your rate by 0.5-1.5%    │ │
│ │                                 │ │
│ │ 🟢 High Impact • 📅 30 days    │ │ ← Impact + Time
│ │ Works best if: Rate >8.5%      │ │ ← Applicability
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 💰 Extra Principal Payments[>] │ │
│ │ SAVE ₹ 4,25,000                │ │
│ │ Pay extra ₹5,000/month          │ │
│ │                                 │ │
│ │ 🟡 Medium Impact • 📅 Ongoing  │ │
│ │ Works best if: Stable income    │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 📋 Tax Optimization        [>] │ │
│ │ SAVE ₹ 2,00,000                │ │
│ │ Max deductions under 80C, 24B   │ │
│ │                                 │ │
│ │ 🟢 High Impact • 📅 Yearly     │ │
│ │ Works best if: Tax bracket >20% │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🏠 Bi-weekly Payments      [>] │ │
│ │ SAVE ₹ 1,80,000                │ │
│ │ 26 payments instead of 12       │ │
│ │                                 │ │
│ │ 🟡 Medium Impact • 📅 Ongoing  │ │
│ │ Works best if: Flexible budget  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ⚡ Rate Review & Negotiation[>] │ │
│ │ SAVE ₹ 75,000                  │ │
│ │ Annual rate review with bank    │ │
│ │                                 │ │
│ │ 🔴 Low Impact • 📅 Yearly      │ │
│ │ Works best if: Good credit score│ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔄 Loan Restructuring      [>] │ │
│ │ SAVE ₹ 1,25,000                │ │
│ │ Extend/reduce tenure optimally  │ │
│ │                                 │ │
│ │ 🟡 Medium Impact • 📅 One-time │ │
│ │ Works best if: Income changed   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 💳 Offset Account          [>] │ │
│ │ SAVE ₹ 45,000                  │ │
│ │ Link savings to reduce interest │ │
│ │                                 │ │
│ │ 🔴 Low Impact • 📅 Ongoing     │ │
│ │ Works best if: High savings     │ │
│ └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│ [🧮]     Calculator     [📋]        │ ← Bottom Navigation
│          Strategies    (Selected)   │
└─────────────────────────────────────┘
```

## Strategy Card Components

### Card Structure
Each strategy card contains:
1. **Icon + Strategy Name**: Visual identifier and clear title
2. **Savings Amount**: Large, prominent ₹ amount
3. **Quick Description**: One-line explanation
4. **Impact Indicator**: High/Medium/Low with color coding
5. **Time Commitment**: One-time, ongoing, yearly
6. **Applicability Criteria**: When this strategy works best
7. **Chevron (>)**: Indicates tap for details

### Impact Color Coding
- **🟢 Green (High Impact)**: ₹2L+ savings potential
- **🟡 Yellow (Medium Impact)**: ₹75K-2L savings potential  
- **🔴 Red (Low Impact)**: <₹75K savings potential

### Time Commitment Icons
- **📅 One-time**: Single action required
- **📅 Ongoing**: Regular monthly/bi-weekly actions
- **📅 Yearly**: Annual review/action needed
- **📅 30 days**: Implementation timeframe

## Hero Section (Combination Calculator)

### Expanded State
```
┌─────────────────────────────────────┐
│ 🎯 Strategy Combination Calculator  │
│                                     │
│ Select applicable strategies:       │
│                                     │
│ ☑️ Balance Transfer      ₹3,50,000  │
│ ☑️ Extra Principal       ₹4,25,000  │
│ ☑️ Tax Optimization      ₹2,00,000  │
│ ☐ Bi-weekly Payments     ₹1,80,000  │
│ ☐ Rate Review            ₹75,000    │
│ ☐ Loan Restructuring     ₹1,25,000  │
│ ☐ Offset Account         ₹45,000    │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │       COMBINED SAVINGS          │ │
│ │        ₹ 9,75,000               │ │ ← Dynamic calculation
│ │    Loan tenure reduced by       │ │
│ │         7 years 4 months        │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [ Get Implementation Plan ]         │ ← CTA for detailed steps
│                                     │
└─────────────────────────────────────┘
```

## Filter System

### Quick Filter Tabs
- **All**: Show all 7 strategies
- **<₹2L**: Low-impact strategies (for budget-conscious users)
- **₹2L-5L**: Medium-impact strategies
- **>₹5L**: High-impact strategies  
- **⚡ Quick Wins**: Strategies implementable in <30 days

### Search Functionality
```
┌─────────────────────────────────────┐
│ 🔍 Search Strategies                │
│ ┌─────────────────────────────────┐ │
│ │ balance transfer            [×] │ │ ← Search input
│ └─────────────────────────────────┘ │
│                                     │
│ Recent: "prepayment" "tax benefit"  │ ← Search history
│                                     │
└─────────────────────────────────────┘
```

## Empty/Loading States

### Loading State
```
┌─────────────────────────────────────┐
│ 💡 Savings Strategies               │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            │ │ ← Loading skeleton
│ │ ▓▓▓▓▓▓▓▓▓▓▓▓                    │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            │ │
│ │ ▓▓▓▓▓▓▓▓▓▓▓▓                    │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

### No Results State (Search)
```
┌─────────────────────────────────────┐
│ 🔍 Search: "refinancing"            │
│                                     │
│        🔍 No strategies found       │
│                                     │
│ Try searching for:                  │
│ • "balance transfer"                │
│ • "prepayment"                      │
│ • "tax benefits"                    │
│                                     │
│ [ Browse All Strategies ]           │
│                                     │
└─────────────────────────────────────┘
```

## Interaction Patterns

### Card Interactions
- **Tap Card**: Navigate to strategy detail screen
- **Swipe Left/Right**: Quick actions (favorite, share)
- **Long Press**: Show quick preview popup

### Sorting Options
```
┌─────────────────────────────────────┐
│ Sort by:                            │
│ ● Savings Amount (High to Low)      │
│ ○ Implementation Time               │
│ ○ Difficulty (Easy to Hard)         │
│ ○ Most Popular                      │
│                                     │
│ [ Apply ] [ Cancel ]                │
└─────────────────────────────────────┘
```

### Quick Actions
- **Favorite Strategy**: Heart icon, save for later
- **Share Strategy**: Quick share savings amount
- **Calculate Impact**: Jump to calculator with pre-filled values

## Mobile UX Considerations

### Thumb-Friendly Navigation
- Filter tabs easily reachable with thumb
- Swipe gestures for horizontal scrolling
- Bottom sheet for sort/filter options

### Scannable Design
- Savings amounts prominently displayed
- Color-coded impact levels for quick identification
- Consistent card layout for pattern recognition

### Performance Optimization
- Lazy loading of strategy cards
- Smooth scroll with momentum
- Instant filter response (<100ms)

### Progressive Disclosure
1. **Overview Level**: Savings amount + quick description
2. **Card Level**: All card information (current view)
3. **Detail Level**: Full implementation guide (next screen)

## Accessibility Features

### Screen Reader Support
- Card descriptions include all relevant information
- Filter states announced clearly
- Savings amounts emphasized in speech

### Visual Accessibility
- High contrast for impact indicators
- Alternative text for all icons
- Proper heading hierarchy (H1, H2, H3)

### Keyboard Navigation
- Tab order follows visual flow
- Focus indicators clearly visible
- Skip links for repetitive elements