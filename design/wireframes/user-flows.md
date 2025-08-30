# User Flows & Navigation Patterns

> Complete user journey mapping for Home Loan Advisor app

## Primary User Flow

```
App Launch
    ↓
┌─────────────────────┐
│   CALCULATOR SCREEN │  ← Primary Entry Point
│                     │
│ 1. Input loan details│
│ 2. Configure tax     │
│ 3. Check PMAY        │
│ 4. Calculate EMI     │
└─────────────────────┘
    ↓ [CALCULATE EMI]
┌─────────────────────┐
│   RESULTS DISPLAY   │
│                     │
│ • Monthly EMI       │
│ • Cost breakdown    │
│ • Tax savings       │
│ • PMAY benefits     │
└─────────────────────┘
    ↓ [SEE STRATEGIES]
┌─────────────────────┐
│  STRATEGIES SCREEN  │
│                     │
│ • Prepayment plans  │
│ • Refinancing       │
│ • Optimization tips │
│ • Action plans      │
└─────────────────────┘
    ↓ [SHARE/SAVE]
┌─────────────────────┐
│   SHARING/EXPORT    │
│                     │
│ • PDF report        │
│ • WhatsApp share    │
│ • Email summary     │
│ • Save calculation  │
└─────────────────────┘
    ↓
Return to Calculator
```

## Detailed Flow Breakdowns

### 1. Calculator Input Flow

```
Calculator Screen Load
    ↓
┌─ Basic Loan Details ──────────┐
│ • Loan Amount (₹5L-₹2Cr)     │
│ • Interest Rate (6%-18%)      │  
│ • Tenure (5-30 years)        │
│ • Bank rate comparison        │
└───────────────────────────────┘
    ↓ [Optional: Advanced]
┌─ Tax Benefits Section ────────┐
│ • Enable toggle               │
│ • Annual income input         │
│ • Auto tax bracket calc       │
│ • Section 80C/24B preview     │
└───────────────────────────────┘
    ↓ [Optional: PMAY]
┌─ PMAY Eligibility ────────────┐
│ • First home buyer toggle     │
│ • Family income validation    │
│ • Auto subsidy calculation    │
│ • Eligibility confirmation    │
└───────────────────────────────┘
    ↓ [CALCULATE EMI]
Results Display with breakdown
```

### 2. Strategy Exploration Flow

```
Strategies Screen Entry
    ↓
┌─ Strategy Categories ─────────┐
│ [All] [Save More] [Lower EMI] │
│           [Faster]            │
└───────────────────────────────┘
    ↓ Filter Selection
┌─ Strategy Cards Display ──────┐
│ • Prepayment strategy         │
│ • Refinancing options         │
│ • Tenure optimization         │
│ • Hybrid approaches           │
└───────────────────────────────┘
    ↓ [VIEW DETAILED PLAN]
┌─ Strategy Detail View ────────┐
│ • Complete analysis           │
│ • Year-wise impact            │
│ • Implementation guide        │
│ • Pro tips & warnings         │
└───────────────────────────────┘
    ↓ [START THIS STRATEGY]
┌─ Action Plan Creation ────────┐
│ • Personalized timeline       │
│ • Milestone tracking          │
│ • Reminder settings           │
│ • Progress monitoring         │
└───────────────────────────────┘
```

## Navigation Patterns

### Bottom Navigation Structure

```
┌─────────────────────────────────────────────────┐
│              MAIN CONTENT AREA                  │
│                                                 │
│           (Calculator / Strategies)             │
│                                                 │
├─────────────────────────────────────────────────┤
│  [🧮]         [📊]         [⚡]                │
│Calculator   Strategies   Settings             │
│    ●                                           │
└─────────────────────────────────────────────────┘

States:
• Calculator Active: Primary calculation interface
• Strategies Active: Optimization recommendations  
• Settings Active: App preferences & about
```

## Key User Journeys

### First-Time User Journey

```
1. App Launch → Calculator Screen (Primary entry)
2. Input guidance → Helper tooltips on fields
3. Basic calculation → Simple EMI result
4. Tax benefits discovery → "Enable to save more!"
5. PMAY introduction → Eligibility check prompt
6. Enhanced results → Full breakdown with savings
7. Strategies discovery → "See optimization tips"
8. Strategy exploration → Implementation guidance
9. Share results → Export/social sharing
10. Return experience → Saved preferences
```

### Returning User Journey

```
1. App launch → Calculator (saved preferences)
2. Quick calculation → Previous inputs restored
3. Updated results → Compare with last calculation
4. Strategy updates → "New opportunities available"
5. Progress tracking → Monitor implementation
6. Refined scenarios → Iterate calculations
```

## Interaction Patterns

### Slider Input Interaction

```
1. Tap → Focus indicator appears
2. Drag → Real-time value updates
3. Release → Snaps to nearest increment  
4. Double-tap → Text input mode
5. Text edit → Validate → Update slider
6. Out of range → Auto-correct with animation
```

### Strategy Card Interaction

```
1. Card loads → Animate into view
2. Tap anywhere → Expand preview
3. Key metrics → Visual emphasis
4. "View Details" → Prominent CTA
5. Detail view → Full screen analysis
6. Implementation → Action-oriented UI
```

## Error Handling Flows

### Input Validation

```
Invalid Input Detected
    ↓
┌─ Inline Validation ───────────┐
│ • Real-time field highlighting│
│ • Helper text with ranges     │
│ • Auto-correction suggestions │
│ • Clear error messaging       │
└───────────────────────────────┘
    ↓
Valid Input → Continue Flow
```

### Network Error Handling

```
Network Issue
    ↓
┌─ Graceful Degradation ────────┐
│ • Cached data utilization     │
│ • Offline calculation mode    │
│ • Clear status indication     │
│ • Retry mechanisms            │
└───────────────────────────────┘
```

## Accessibility Considerations

### Screen Reader Support
- Semantic markup for all interactive elements
- Descriptive labels for complex financial data
- Structured navigation through calculation results
- Audio feedback for slider interactions

### Voice Control
- Voice input for loan parameters
- Spoken results summaries  
- Navigation commands support
- Hands-free operation capability

### Visual Accessibility
- High contrast mode adaptation
- Scalable typography (up to 200%)
- Focus indicators for keyboard navigation
- Reduced motion preferences support