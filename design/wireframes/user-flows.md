# User Flows & Navigation Patterns

## Primary User Flows

### Flow 1: Quick EMI Calculation (80% of users)
```
App Launch → Calculator Screen → Input Loan Details → View Results → (Optional) Share
    ↓
Entry Point: Calculator tab (default)
    ↓
Input Journey:
┌─ Loan Amount ₹50,00,000
├─ Interest Rate 8.5%
├─ Tenure 20 years
└─ [Advanced Options] → Processing fees, prepayments
    ↓
Results Display:
┌─ EMI: ₹41,822/month (prominent)
├─ Total Amount: ₹1,00,37,280
├─ Tax Benefits: ₹2,00,000/year
└─ [View Breakdown] → Charts & amortization
    ↓
Exit Points:
├─ Share results (PDF/image)
├─ Explore strategies (switch tab)
└─ Recalculate (modify inputs)
```

**Success Criteria**: User gets accurate EMI in <30 seconds

### Flow 2: Strategy Discovery & Implementation (15% of users)
```
Calculator Results → "Interested in Saving?" CTA → Strategies Tab → Strategy Cards → Detail View → Implementation
    ↓
Entry Path A: From Calculator
"Based on your loan, you could save ₹3,50,000 with balance transfer"
    ↓
Entry Path B: Direct Navigation  
Strategies Tab → Browse all 7 strategies
    ↓
Discovery Pattern:
┌─ Scan strategy cards (savings amounts prominent)
├─ Filter by impact/time (optional)
├─ Read quick descriptions
└─ Tap most relevant strategy
    ↓
Detail Exploration:
┌─ Hero savings number validation
├─ Before/after comparison
├─ Step-by-step implementation
├─ Risk assessment
└─ Break-even analysis
    ↓
Action Decision:
├─ Save strategy for later (bookmark)
├─ Calculate for my loan (back to calculator)
├─ Share with family/advisor
└─ Start implementation (external)
```

**Success Criteria**: User finds 1-2 applicable strategies, understands implementation

### Flow 3: Strategy Combination Planning (5% of users)
```
Strategies Tab → Combination Calculator → Select Multiple → View Combined Impact → Implementation Plan
    ↓
Advanced User Path:
┌─ Open combination calculator
├─ Select 2-3 applicable strategies
├─ See combined savings potential
├─ Understand interaction effects
└─ Get prioritized implementation order
    ↓
Planning Output:
┌─ Total combined savings: ₹9,75,000
├─ Implementation timeline: 2-6 months
├─ Priority order: Balance transfer → Tax optimization → Extra payments
└─ Risk assessment for combination
```

**Success Criteria**: User gets realistic combined savings estimate and actionable plan

## Navigation Patterns

### Tab Navigation (Bottom)
```
┌─────────────────────────────────────┐
│ [🧮] Calculator     [📋] Strategies │
│    (Default/Home)    (Discovery)    │
└─────────────────────────────────────┘
```

**Navigation Rules**:
- **Calculator tab**: Always default on app launch
- **Strategies tab**: Badge with number when new strategies match user's loan
- **Tab persistence**: Remember last viewed strategy
- **Deep linking**: Direct links to specific strategies

### Hierarchical Navigation
```
App Level:
├─ Calculator Screen (Tab 1)
│   ├─ Basic Calculator View
│   ├─ Advanced Options (slide up)
│   ├─ Results Breakdown (slide up)
│   └─ Share Sheet (modal)
│
└─ Strategies Screen (Tab 2)
    ├─ Strategy Grid View
    ├─ Filter/Sort Options (slide down)
    ├─ Combination Calculator (modal)
    └─ Strategy Detail Screens (push)
        ├─ Implementation Guide
        ├─ Risk Assessment
        ├─ Related Strategies
        └─ Share Options
```

### Cross-Screen Flow Patterns

#### Calculator → Strategies Integration
```
Calculator Screen:
    ↓
Results Section:
┌─────────────────────────────────────┐
│ 💡 Want to save more?               │
│ Based on your loan details:         │
│                                     │
│ 🔄 Balance Transfer: Save ₹3.5L     │
│ 💰 Extra Payments: Save ₹4.2L       │
│                                     │
│ [ View All Strategies ]             │ → Navigate to Strategies tab
└─────────────────────────────────────┘
```

#### Strategies → Calculator Integration  
```
Strategy Detail Screen:
    ↓
Action Buttons:
┌─────────────────────────────────────┐
│ [ 🧮 Calculate for My Loan ]        │ → Jump to Calculator with pre-filled values
│ [ 📤 Share This Strategy ]          │ → Share modal
│ [ ⭐ Save to Favorites ]            │ → Local storage
└─────────────────────────────────────┘
```

## Information Architecture

### Content Hierarchy
```
App Level (Tabs)
├─ Calculator (Primary function)
│   ├─ Basic Inputs (Always visible)
│   │   ├─ Loan Amount
│   │   ├─ Interest Rate  
│   │   └─ Tenure
│   ├─ Advanced Inputs (Collapsible)
│   │   ├─ Processing Fees
│   │   ├─ Prepayment Amount
│   │   └─ Tax Bracket
│   └─ Results (Dynamic)
│       ├─ EMI (Hero number)
│       ├─ Totals (Amount, Interest, Tax benefits)
│       └─ Visualizations (Charts, breakdown)
│
└─ Strategies (Secondary function)
    ├─ Overview (Grid of 7)
    │   ├─ High Impact (₹2L+)
    │   ├─ Medium Impact (₹75K-2L)
    │   └─ Low Impact (<₹75K)
    ├─ Filters/Sort (Optional)
    │   ├─ By Savings Amount
    │   ├─ By Implementation Time
    │   └─ By Difficulty
    └─ Details (Per strategy)
        ├─ Savings Calculation
        ├─ Implementation Guide
        ├─ Risk Assessment
        └─ Success Tips
```

### Mental Models & User Expectations

#### Calculator Mental Model
Users expect:
1. **Immediate Results**: EMI calculation as they type
2. **Familiar Inputs**: Standard loan terms (amount, rate, tenure)
3. **Indian Context**: ₹ currency, tax benefits, realistic rates
4. **Comparison Ability**: Different scenarios, what-if analysis
5. **Export/Share**: Results they can save or share

#### Strategies Mental Model
Users expect:
1. **Browsable Catalog**: Like shopping for savings opportunities
2. **Clear ROI**: Specific rupee amounts, not percentages
3. **Implementation Difficulty**: How hard/time-consuming
4. **Applicable Criteria**: When strategy works for their situation
5. **Step-by-step Guidance**: Not just concepts, but actions

## State Management & Data Flow

### User Session Data
```
Session State:
├─ Calculator Inputs
│   ├─ loanAmount: number
│   ├─ interestRate: number
│   ├─ tenure: {years, months}
│   ├─ processingFee: number
│   └─ prepaymentAmount: number
├─ Calculation Results
│   ├─ monthlyEMI: number
│   ├─ totalAmount: number
│   ├─ totalInterest: number
│   └─ taxBenefits: number
├─ Strategy Preferences
│   ├─ viewedStrategies: string[]
│   ├─ favoriteStrategies: string[]
│   └─ appliedFilters: object
└─ App Preferences
    ├─ defaultTab: string
    ├─ shareFormat: string
    └─ notificationSettings: object
```

### Data Persistence
- **Local Storage**: User inputs, preferences, favorites
- **Session Storage**: Current calculation results, filter states
- **No Cloud Sync**: Pure offline app, no accounts

### Cross-Component Communication
```
Calculator Updates → Strategy Recommendations
    ↓
User Loan Profile:
┌─ Amount: ₹50L
├─ Rate: 8.5%
├─ Tenure: 20 years
└─ Remaining: 18 years
    ↓
Applicable Strategies:
├─ Balance Transfer (rate >8%, tenure >15 years) ✅
├─ Extra Principal (stable income, long tenure) ✅
├─ Tax Optimization (high tax bracket) ✅
├─ Bi-weekly Payments (flexible budget) ❓
├─ Rate Review (good credit score) ❓
├─ Restructuring (income changed) ❌
└─ Offset Account (high savings balance) ❌
```

## Error Handling & Edge Cases

### Input Validation Flow
```
User Input → Real-time Validation → Error Display → Correction Guidance
    ↓
Validation Rules:
├─ Loan Amount: ₹1L - ₹5Cr
├─ Interest Rate: 3% - 20%
├─ Tenure: 1 - 30 years
└─ Processing Fee: ₹0 - ₹2L
    ↓
Error States:
├─ Empty Fields: Placeholder guidance
├─ Out of Range: Specific limits shown
├─ Invalid Format: Input mask correction
└─ Calculation Error: Fallback to defaults
```

### Strategy Applicability Flow
```
User Profile → Strategy Filtering → Applicability Check → Recommendation
    ↓
Profile Analysis:
├─ Loan Age: 2 years (from start date)
├─ Remaining Balance: ₹45L
├─ Credit Score: Unknown (user input optional)
└─ Income Stability: Unknown
    ↓
Smart Recommendations:
├─ Show All Strategies (default)
├─ Highlight Most Applicable (green)
├─ Mark Questionable (yellow)
└─ Hide Inappropriate (criteria not met)
```

## Performance & Loading States

### Progressive Loading Pattern
```
App Launch (0ms):
├─ Show splash screen
├─ Load calculator interface
└─ Initialize default values

Calculator Ready (200ms):
├─ Enable input fields
├─ Show placeholder guidance
└─ Prepare calculation engine

Strategies Loading (500ms):
├─ Show strategy cards skeleton
├─ Load strategy metadata
└─ Prepare filtering/sorting

Full App Ready (800ms):
├─ All interactions enabled
├─ Smooth animations active
└─ Background data loaded
```

### Offline Behavior
- **Core Functions**: Calculator works fully offline
- **Strategy Content**: Pre-loaded, cached locally
- **Share Features**: Generate sharable images/PDFs locally
- **Updates**: Graceful degradation when network unavailable

## Accessibility & Inclusive Design

### Screen Reader Navigation Flow
```
Tab Navigation Order:
1. App title and search (if visible)
2. Primary action buttons
3. Input fields (in logical order)
4. Results section (with live region updates)
5. Secondary actions (share, advanced options)
6. Bottom navigation tabs
```

### Voice Control Patterns
- **Calculator**: "Set loan amount to fifty lakhs"
- **Navigation**: "Go to strategies", "Show balance transfer"
- **Actions**: "Calculate EMI", "Share results"

### Motor Accessibility
- **Large Touch Targets**: 44px minimum
- **Gesture Alternatives**: All swipe actions have button alternatives
- **Voice Input**: Support for speech-to-text in input fields

This comprehensive flow documentation ensures the app provides intuitive navigation patterns while maintaining focus on the core calculator and strategies functionality.