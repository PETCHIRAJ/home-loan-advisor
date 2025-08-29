# Calculator Screen Wireframe

## Layout Overview
The calculator screen is the primary entry point and most frequently used feature. It prioritizes ease of input and clear result visualization.

## ASCII Wireframe

```
┌─────────────────────────────────────┐ ← StatusBar (iOS/Android)
│ 🏡 Home Loan Advisor           [📤] │ ← App Header (title + share)
├─────────────────────────────────────┤
│                                     │
│  💰 EMI CALCULATOR                  │ ← Section Title
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ Loan Amount (₹)             [i] │ │ ← Tooltip for help
│  │ ┌─────────────────────────────┐ │ │
│  │ │ 50,00,000               [×] │ │ │ ← Clear button
│  │ └─────────────────────────────┘ │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ Interest Rate (% per annum) [i] │ │
│  │ ┌─────────────────────────────┐ │ │
│  │ │ 8.5                     [×] │ │ │
│  │ └─────────────────────────────┘ │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ Loan Tenure                 [i] │ │
│  │ ┌──────────┐ ┌──────────────────┐│ │
│  │ │    20    │ │     Years     [v]││ │ ← Dropdown: Years/Months
│  │ └──────────┘ └──────────────────┘│ │
│  └─────────────────────────────────┘ │
│                                     │
│  [ Advanced Options... ]           │ ← Collapsible section
│                                     │
├─────────────────────────────────────┤
│                                     │
│  📊 RESULTS                         │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         YOUR EMI                │ │
│  │       ₹ 41,822                  │ │ ← Large, prominent EMI
│  │      per month                  │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌───────────────┬─────────────────┐ │
│  │ Total Amount  │ Tax Benefits    │ │
│  │ ₹ 1,00,37,280 │ ₹ 2,00,000     │ │ ← Key numbers
│  │               │ per year        │ │
│  └───────────────┴─────────────────┘ │
│                                     │
│  [  Amortization Chart  ]           │ ← Expandable visualization
│  [═══════════████████████]          │ ← Progress bar (Interest vs Principal)
│  Interest: 60% | Principal: 40%     │
│                                     │
│  [ View Breakdown ] [ Compare ]     │ ← Action buttons
│                                     │
├─────────────────────────────────────┤
│ [🧮]     Calculator     [📋]        │ ← Bottom Navigation
│          (Selected)     Strategies  │
└─────────────────────────────────────┘
```

## Interactive Elements

### Input Fields
- **Loan Amount**: Number input with Indian currency formatting (₹1,23,45,678)
- **Interest Rate**: Decimal input (8.5%) with validation (3-20% range)
- **Loan Tenure**: Number input + dropdown for Years/Months selection

### Advanced Options Panel (Collapsible)
```
┌─────────────────────────────────────┐
│ 🔧 Advanced Options                 │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Processing Fees (₹)         [i] │ │
│ │ ┌─────────────────────────────┐ │ │
│ │ │ 25,000                      │ │ │
│ │ └─────────────────────────────┘ │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Prepayment (₹/year)         [i] │ │
│ │ ┌─────────────────────────────┐ │ │
│ │ │ 1,00,000                    │ │ │
│ │ └─────────────────────────────┘ │ │
│ └─────────────────────────────────┘ │
│                                     │
│ □ Include insurance costs           │
│ □ Show tax benefit calculation      │
│                                     │
└─────────────────────────────────────┘
```

### Results Visualization (Expandable)
```
┌─────────────────────────────────────┐
│ 📈 Payment Breakdown                │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │    [Chart: Monthly Payments]    │ │
│ │         ╭─╮                     │ │
│ │      ╭──╯ ╰─╮   Principal       │ │
│ │   ╭──╯      ╰─╮ ||||||||       │ │
│ │ ──╯          ╰─────────────     │ │
│ │              Interest           │ │
│ │ Years: 1  5  10  15  20        │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Total Interest: ₹ 50,37,280         │
│ Total Principal: ₹ 50,00,000        │
│ Savings with Prepayment: ₹ 8,50,000│
│                                     │
│ [ Download PDF ] [ Share Results ]  │
│                                     │
└─────────────────────────────────────┘
```

## Interaction Patterns

### Input Interactions
- **Tap Input Field**: Focus with numeric keyboard
- **Clear Button (×)**: Reset field to empty
- **Info Button (i)**: Show contextual tooltip
- **Real-time Calculation**: Update results as user types

### Touch Targets
- **Minimum Size**: 44px × 44px (iOS) / 48dp × 48dp (Android)
- **Thumb-Friendly**: Inputs positioned for one-handed use
- **Clear Visual Feedback**: Pressed states, ripple effects

### Progressive Disclosure
1. **Basic Inputs**: Always visible (Loan, Rate, Tenure)
2. **Advanced Options**: Collapsed by default, expand on demand
3. **Detailed Results**: Show EMI immediately, expand for breakdown
4. **Visualizations**: Chart/graph hidden until "View Breakdown" tapped

## Content Hierarchy

### Primary Information (Always Visible)
1. **EMI Amount**: Largest text, center-aligned, bold
2. **Input Fields**: Clear labels, proper grouping
3. **Basic Results**: Total amount, tax benefits

### Secondary Information (On Demand)
1. **Advanced Inputs**: Processing fees, prepayments
2. **Detailed Breakdown**: Interest vs principal split
3. **Visualizations**: Charts, amortization schedule

### Helper Information (Contextual)
1. **Tooltips**: Explain complex terms
2. **Validation Messages**: Input errors, range limits
3. **Educational Content**: Why calculations matter

## Error States

### Input Validation
```
┌─────────────────────────────────────┐
│ Loan Amount (₹)                 [i] │
│ ┌─────────────────────────────────┐ │
│ │ 2,00,00,000                     │ │ ← Error state (red border)
│ └─────────────────────────────────┘ │
│ ⚠️ Maximum loan amount: ₹1,00,00,000│ ← Error message
└─────────────────────────────────────┘
```

### Empty States
```
┌─────────────────────────────────────┐
│         📊 RESULTS                  │
│                                     │
│    📱 Enter loan details above      │
│    to see your EMI calculation      │
│                                     │
│  [  Start with ₹50L, 8.5%, 20Y  ]  │ ← Quick start suggestion
│                                     │
└─────────────────────────────────────┘
```

## Mobile UX Considerations

### Thumb-Friendly Design
- Primary actions within thumb reach (bottom 2/3 of screen)
- Large touch targets for all interactive elements
- Swipe gestures for advanced options panel

### One-Handed Usage
- Input fields positioned for thumb typing
- Navigation elements at bottom
- Important actions accessible without stretching

### Performance
- Instant calculation updates (< 100ms)
- Smooth animations for expand/collapse
- Offline calculation capability

### Accessibility
- Screen reader labels for all inputs
- High contrast ratios (4.5:1 minimum)
- Focus indicators for keyboard navigation
- Semantic markup for calculations