# Calculator Screen Wireframe

## Purpose
Core tool for loan calculations with simple 3-input form, instant shocking results, and top money-saving strategies. Creates "aha moment" through total interest revelation.

## Layout Structure

```
┌─────────────────────────────────────┐
│ [←] Smart Loan Calculator    [🔔][?] │
├─────────────────────────────────────┤
│                                     │
│ 💰 LOAN DETAILS                     │
│ ┌─────────────────────────────────┐ │
│ │ Loan Amount                     │ │
│ │ ₹ [50,00,000________] [₹]       │ │
│ │                                 │ │
│ │ Interest Rate                   │ │
│ │ [8.5_______] % per year         │ │
│ │                                 │ │
│ │ Loan Tenure                     │ │
│ │ [20_______] years               │ │
│ │                                 │ │
│ │ [📱 CALCULATE IMPACT]           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ⚡ INSTANT REALITY CHECK            │
│ ┌─────────────────────────────────┐ │
│ │ Current EMI: ₹41,822           │ │
│ │ Total Interest: ₹50,37,280     │ │
│ │ 👆 You'll pay DOUBLE!          │ │
│ │                                 │ │
│ │ Daily Interest Burn: ₹1,147    │ │
│ │ Per Hour Loss: ₹48             │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 🎯 SMART STRATEGIES (Tap to Apply) │
│ ┌───────────────────────────────┐   │
│ │ ✅ Bi-Weekly Payments         │   │
│ │ Save ₹7,23,450 | 3.2yr early │   │
│ └───────────────────────────────┘   │
│ ┌───────────────────────────────┐   │
│ │ ✅ One Extra EMI/Year         │   │
│ │ Save ₹5,89,120 | 2.8yr early │   │
│ └───────────────────────────────┘   │
│ ┌───────────────────────────────┐   │
│ │ ✅ Round Up to ₹45,000        │   │
│ │ Save ₹4,12,890 | 2.1yr early │   │
│ └───────────────────────────────┘   │
│                                     │
│ [📊 VIEW ALL 20 STRATEGIES]        │
│                                     │
├─────────────────────────────────────┤
│ [🏠] [📊] [🎯] [⚙️] [👤]           │
└─────────────────────────────────────┘
```

## Component Breakdown

### Header (Navigation)
- Back arrow (return to previous screen)
- Screen title "Smart Loan Calculator"
- Notification bell
- Help icon (calculation explanations)

### Loan Details Input (Primary Form)
- **Purpose**: Minimal friction data entry
- **Fields**: Only 3 required inputs
  - Loan Amount: ₹50,00,000 (Indian formatting)
  - Interest Rate: 8.5% per year
  - Loan Tenure: 20 years
- **Input Style**: Large, clear input fields
- **CTA Button**: "CALCULATE IMPACT" (action-oriented)
- **Psychology**: Simple form reduces abandonment

### Instant Reality Check (Shock Value)
- **Purpose**: Create emotional impact through harsh reality
- **Current EMI**: ₹41,822 (monthly payment)
- **Total Interest**: ₹50,37,280 (lifetime cost)
- **Emphasis**: "You'll pay DOUBLE!" (shocking revelation)
- **Granular Impact**: 
  - Daily Interest Burn: ₹1,147
  - Per Hour Loss: ₹48
- **Psychology**: Specific numbers create urgency

### Smart Strategies (Actionable Solutions)
- **Purpose**: Provide immediate actionable solutions
- **Layout**: Top 3 strategies as cards
- **Content Per Strategy**:
  - Strategy name (Bi-Weekly Payments)
  - Savings amount (₹7,23,450)
  - Time saved (3.2 years early)
  - Check mark (visual approval)
- **CTA**: "VIEW ALL 20 STRATEGIES" button
- **Psychology**: Solutions immediately after problem creates hope

## Information Hierarchy

1. **Input Form** (User provides data)
2. **Reality Check** (Shocking revelation)
3. **Top Solutions** (Immediate hope/action)
4. **All Strategies** (Further exploration)

## User Flow

### Primary Path
1. User enters loan details (Amount, Rate, Tenure)
2. Taps "CALCULATE IMPACT" button
3. Sees shocking total interest amount
4. Reviews top 3 strategies with savings
5. Taps individual strategy OR "VIEW ALL 20 STRATEGIES"

### Input Behavior
- Real-time formatting (₹50,00,000 → ₹ 50,00,000)
- Input validation (rate 0-20%, tenure 1-30 years)
- Auto-calculation on field change
- Save data for future sessions

### Error Handling
- Empty fields: "Please enter loan amount"
- Invalid rates: "Interest rate should be between 1-20%"
- Invalid tenure: "Loan tenure should be 1-30 years"

## Content Requirements

### Default Values (Indian Market)
- Loan Amount: ₹50,00,000 (average home loan)
- Interest Rate: 8.5% (current market average)
- Tenure: 20 years (popular choice)

### Calculation Formulas
- EMI = P × R × (1+R)^N / ((1+R)^N - 1)
- Total Interest = (EMI × Tenure in months) - Principal
- Daily Interest = Total Interest / (Tenure × 365)
- Hourly Interest = Daily Interest / 24

### Strategy Calculations
- **Bi-Weekly**: 26 payments/year vs 12 monthly
- **Extra EMI**: 13 EMIs per year vs 12
- **Round-Up**: Higher EMI amount impact

## Accessibility Features

- Large input fields (minimum 44pt touch targets)
- High contrast for shock value content
- Clear labels with proper spacing
- Screen reader announcements for calculations
- Haptic feedback on calculation completion

## Performance Requirements

- Instant calculation (< 100ms)
- Smooth animations for result reveal
- Offline calculation capability
- Data persistence across sessions

## Cultural Considerations

- Indian currency formatting (₹50,00,000)
- Festival bonus timing for extra EMI suggestions
- Local banking terminology
- Conservative financial advice approach