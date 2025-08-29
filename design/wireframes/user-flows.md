# User Flows & Progressive Disclosure - Navigation Wireframes

## Overview
This document outlines how users navigate through home loan strategy content, with emphasis on progressive disclosure patterns that prevent information overwhelm while supporting informed decision-making.

## Primary User Journey: Strategy Discovery to Implementation

```
Entry Point → Overview → Detail → Action
    ↓           ↓         ↓        ↓
[Dashboard] → [7 Strategies] → [Deep Dive] → [Implementation]
    ↑                ↓              ↓           ↓
[Profile]    [Quick Filter]   [Comparison] → [Plan Creation]
    ↑                ↓              ↓           ↓
[Setup]      [Category View] → [Combination] → [Tracking]
```

## Flow 1: Quick Discovery (Power Users)
**Duration**: 30 seconds - 2 minutes
**Goal**: Find and start implementing a simple strategy

```
┌─ DASHBOARD ─┐    ┌─ STRATEGY LIST ─┐    ┌─ QUICK ACTION ─┐
│ Loan Status  │ →  │ QUICK WINS      │ →  │ Implementation  │
│ $X savings   │    │ 💰 Extra Pays   │    │ Steps 1-3       │
│ available    │    │ Save $18,400    │    │ [Start Now]     │
│              │    │ ▶ Easy•No Risk  │    │                │
│ [See Options]│    │ [Select]        │    │ [Add to Plan]   │
└──────────────┘    └─────────────────┘    └─────────────────┘
     2-3 sec              10-15 sec              15-30 sec
```

**Content Strategy**:
- Hero savings number immediately visible
- One-click access to simple strategies
- Minimal information to get started
- "Learn more" option available but not required

## Flow 2: Thorough Research (Cautious Users)
**Duration**: 5-15 minutes
**Goal**: Understand multiple options before committing

```
┌─ STRATEGY LIST ─┐   ┌─ DETAILED VIEW ─┐   ┌─ COMPARISON ─┐   ┌─ DECISION ─┐
│ All 7 Options   │→  │ Extra Repayments │→  │ Extra vs Refi│→  │ Selected:   │
│ Sorted by Impact│   │ How It Works     │   │ Risk Compare │   │ Extra Pays  │
│ Filter: Easy    │   │ Implementation   │   │ Effort Level │   │ + Offset    │
│ [Learn More]    │   │ Considerations   │   │ [Select Both]│   │ $24K savings│
└─────────────────┘   └──────────────────┘   └──────────────┘   └─────────────┘
     1-2 min               3-5 min              2-3 min           30 sec
```

**Content Strategy**:
- Full information available on demand
- Easy comparison between options
- Risk/benefit analysis prominent
- Multiple exit points to action

## Flow 3: Expert Analysis (Investment Property Owners)
**Duration**: 10-30 minutes
**Goal**: Optimize complex financial situation with multiple strategies

```
┌─ ADVANCED VIEW ─┐   ┌─ CALCULATOR ─┐   ┌─ TAX ANALYSIS ─┐   ┌─ EXPERT PLAN ─┐
│ Split Loans     │→  │ Debt Recycle │→  │ Tax Benefits  │→  │ 4-Strategy    │
│ Debt Recycling  │   │ Custom Rates │   │ Deductions    │   │ Combination   │
│ Tax Implications│   │ Scenarios    │   │ Timing        │   │ Professional  │
│ [Deep Analysis] │   │ [Calculate]  │   │ [Optimize]    │   │ Review Rec.   │
└─────────────────┘   └──────────────┘   └───────────────┘   └───────────────┘
     3-5 min              5-10 min           3-5 min            2-5 min
```

**Content Strategy**:
- Advanced calculations and scenarios
- Tax implications clearly explained
- Professional advice integration
- Complex strategy sequencing

## Progressive Disclosure Patterns

### Pattern 1: Expandable Cards
**Use Case**: Strategy overview to detail transition
**Interaction**: Tap card to expand in-place

```
┌─ COLLAPSED STATE ─┐     ┌─ EXPANDED STATE ─┐
│ 💰 Extra Repayments│ →   │ 💰 Extra Repayments      │
│ Save $18,400       │     │ Save $18,400             │
│ Easy•No Risk       │     │ ⚡ QUICK SUMMARY          │
│ [Expand ▼]         │     │ • Add $200/month         │
└────────────────────┘     │ • Start immediately      │
                           │ • No paperwork needed    │
                           │ Easy•No Risk•High Impact │
                           │                          │
                           │ 📊 YOUR NUMBERS          │
                           │ Current: $2,500/month    │
                           │ New: $2,700/month        │
                           │ Extra: $200/month        │
                           │                          │
                           │ [Full Details] [Start]   │
                           │ [Collapse ▲]             │
                           └──────────────────────────┘
```

### Pattern 2: Drill-Down Navigation
**Use Case**: Moving from overview to specific details
**Interaction**: Navigate to dedicated detail screen

```
LEVEL 1: Overview    LEVEL 2: Summary     LEVEL 3: Details     LEVEL 4: Implementation
┌─────────────┐     ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│ 7 Strategies│ →   │ Extra Pays  │  →   │ How it Works│  →   │ Step 1 of 3 │
│ $47K Total  │     │ $18K Savings│      │ Calculations│      │ Call Lender │
│ [See All]   │     │ 4-Level Info│      │ Examples    │      │ Script Help │
└─────────────┘     └─────────────┘      └─────────────┘      └─────────────┘
```

### Pattern 3: Layered Tabs
**Use Case**: Different information types for same strategy
**Interaction**: Horizontal swipe or tab selection

```
┌─ EXTRA REPAYMENTS ────────────────────────────────┐
│ [Summary] [Numbers] [Steps] [Considerations]      │
├───────────────────────────────────────────────────┤
│                                                   │
│ Content changes based on selected tab             │
│ • Summary: Quick overview and benefits            │
│ • Numbers: Calculations and comparisons           │
│ • Steps: Implementation guidance                  │
│ • Considerations: Risks, alternatives, fit        │
│                                                   │
└───────────────────────────────────────────────────┘
```

### Pattern 4: Contextual Help
**Use Case**: Additional information without leaving main flow
**Interaction**: Tap info icons or help buttons

```
┌─ MAIN CONTENT ────────────────────────────────────┐
│ Refinancing Strategy                              │
│ Lower your rate by 0.25% [ℹ️]                     │
│                                                   │
│ When tapped: ┌─ TOOLTIP ──────────┐              │
│              │ Rate reduction      │              │
│              │ depends on:         │              │
│              │ • Credit score      │              │
│              │ • Loan-to-value     │              │
│              │ • Market conditions │              │
│              │ [Got it]            │              │
│              └─────────────────────┘              │
└───────────────────────────────────────────────────┘
```

## Information Architecture by User Type

### First-Time Homeowners (Beginner)
**Entry Point**: Guided tutorial
**Path**: Overview → Simple strategies → Single selection → Implementation
**Content Focus**: Education, risk mitigation, simple language

```
Tutorial → Quick Wins → Extra Repayments → Start Implementation
    ↓          ↓             ↓                    ↓
Education   Simple       Step-by-step       Success tracking
```

### Experienced Homeowners (Intermediate)  
**Entry Point**: Strategy comparison
**Path**: All strategies → Comparison → Combination → Implementation plan
**Content Focus**: Efficiency, comparison, multiple options

```
All Strategies → Side-by-side → Combination → Implementation Plan
      ↓              ↓            ↓              ↓
  Filter/sort    Trade-offs    Synergies     Prioritization
```

### Investment Property Owners (Advanced)
**Entry Point**: Advanced calculator
**Path**: Complex strategies → Tax analysis → Professional integration → Execution
**Content Focus**: Optimization, tax implications, professional support

```
Advanced Strategies → Tax Calculator → Professional Review → Execution
         ↓                 ↓               ↓                ↓
    Debt recycling    Deductions      Expert validation   Complex setup
```

## Error States & Edge Cases

### Insufficient Information
**Scenario**: User hasn't provided complete loan details
**Solution**: Progressive form with smart defaults

```
┌─ INCOMPLETE DATA ─┐
│ We need more info │
│ to show accurate  │
│ savings numbers   │
│                   │
│ [Complete Profile]│
│ [See Estimates]   │
└───────────────────┘
```

### No Suitable Strategies
**Scenario**: User's situation doesn't benefit from available strategies
**Solution**: Educational content and alternative resources

```
┌─ NO RECOMMENDATIONS ─┐
│ Your current loan is  │
│ already optimized     │
│                       │
│ • Rate: Excellent     │
│ • Term: Appropriate   │
│ • Structure: Optimal  │
│                       │
│ [Monitor Changes]     │
│ [Explore Investments] │
└───────────────────────┘
```

### Implementation Blockers
**Scenario**: User can't complete recommended steps
**Solution**: Alternative paths and professional referral

```
┌─ IMPLEMENTATION HELP ─┐
│ Having trouble with    │
│ refinancing approval?  │
│                        │
│ Try these alternatives:│
│ • Negotiate current    │
│ • Wait 6 months        │
│ • Get professional help│
│                        │
│ [Alternative Strategies]│
│ [Connect with Expert]   │
└────────────────────────┘
```

## Navigation Best Practices

### Breadcrumb Strategy
- Always show current location in information hierarchy
- Provide quick back/up navigation
- Maintain context when drilling down

### State Preservation
- Remember user selections across sessions
- Maintain scroll position when returning
- Preserve comparison selections

### Exit Points
- Clear exit to action at every level
- "Save for later" options throughout
- Easy return to overview from any screen

### Performance Considerations
- Lazy load detailed calculations
- Cache frequently accessed content
- Progressive image loading for charts/graphs

This navigation structure ensures users can find information at their preferred level of detail while maintaining clear paths to action, regardless of their experience level or decision-making style.