# Calculator Screen Wireframe

## Purpose
Control center for ALL loan and personal settings. 4th tab in bottom navigation where users customize their complete profile including loan details, personal information, and view comprehensive calculation results with amortization schedule.

## Layout Structure

```
┌─────────────────────────────────────┐
│ ₹30L @ 8.5% • 20yr            [⚙️] │
├─────────────────────────────────────┤
│                                     │
│ 💰 LOAN DETAILS                     │
│ ┌─────────────────────────────────┐ │
│ │ Loan Amount                     │ │
│ │ ₹ [30,00,000________] [Edit]    │ │
│ │                                 │ │
│ │ Interest Rate                   │ │
│ │ [8.5_______] % per year [Edit]  │ │
│ │                                 │ │
│ │ Loan Tenure                     │ │
│ │ [20_______] years [Edit]        │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 👤 PERSONAL DETAILS                 │
│ ┌─────────────────────────────────┐ │
│ │ Monthly Income                  │ │
│ │ ₹ [1,00,000_____] [Edit]        │ │
│ │                                 │ │
│ │ Current Age                     │ │
│ │ [30_______] years [Edit]        │ │
│ │                                 │ │
│ │ Loan Status                     │ │
│ │ ○ Planning to buy ● Taken       │ │
│ │ Months paid: [0___] [Edit]      │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 📈 CALCULATION RESULTS              │
│ ┌─────────────────────────────────┐ │
│ │ Monthly EMI: ₹25,415           │ │
│ │ Total Payment: ₹61,00,000      │ │
│ │ Total Interest: ₹31,00,000     │ │
│ │ Daily Interest: ₹696           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [📊 View Amortization Schedule]    │
│ [💰 Explore Strategies]            │
│                                     │
├─────────────────────────────────────┤
│ [🏠] [💰] [📈] [📊]               │
│ Home Strategies Progress Calculator │
└─────────────────────────────────────┘
```

## Component Breakdown

### Header (Smart Compact - Edit Mode)
- Loan summary "₹30L @ 8.5% • 20yr" (shows current parameters being edited)
- Settings gear icon (additional settings and help)
- Entire header is tappable (can highlight to show edit mode)
- Height: 48px (compact design)
- Shows "Edit mode" or highlights when user is actively editing
- Consistent with other screens for navigation clarity

### Loan Details Section
- **Purpose**: Core loan parameter configuration
- **Fields**: 3 primary loan inputs
  - Loan Amount: ₹30,00,000 (realistic Tamil Nadu default)
  - Interest Rate: 8.5% per year (market average)
  - Loan Tenure: 20 years (common choice)
- **Input Style**: Inline editing with [Edit] buttons
- **Real-time Updates**: Calculations update as values change
- **Psychology**: Always-accessible editing reduces friction

### Personal Details Section (NEW)
- **Purpose**: Complete user profile for personalized insights
- **Monthly Income**: ₹1,00,000 (for EMI-to-income ratio)
- **Current Age**: 30 years (for life planning)
- **Loan Status**: Planning vs Already Taken (changes app behavior)
- **Months Paid**: For existing loan holders (affects calculations)
- **Benefit**: Enables personalized strategies and progress tracking

### Calculation Results (NEW)
- **Purpose**: Comprehensive loan impact summary
- **Monthly EMI**: ₹25,415 (for ₹30L loan)
- **Total Payment**: ₹61,00,000 (EMI × tenure)
- **Total Interest**: ₹31,00,000 (shocking reality)
- **Daily Interest**: ₹696 (daily burn counter input)
- **Clean Layout**: Clear, digestible financial summary

## Information Hierarchy

1. **Loan Details** (Core financial parameters)
2. **Personal Details** (User profile for personalization)
3. **Calculation Results** (Immediate financial impact)
4. **Action Buttons** (Navigate to deeper features)
5. **Bottom Navigation** (Access other app sections)

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

### Smart Default Values (Tamil Nadu Context)
- **Loan Amount**: ₹30,00,000 (realistic for Chennai/Coimbatore)
- **Interest Rate**: 8.5% (current market average)
- **Tenure**: 20 years (popular choice)
- **Income**: ₹1,00,000 (healthy EMI-to-income ratio)
- **Age**: 30 (typical first-time buyer)
- **Status**: Planning to buy (most common entry point)

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