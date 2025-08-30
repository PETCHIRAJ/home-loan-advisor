# Strategies Screen Wireframe

> Loan optimization recommendations based on calculation results

## Screen Layout (Portrait - 375x812px base)

```
┌─────────────────────────────────────────────────────┐
│ Status Bar                                    4:30 PM│
├─────────────────────────────────────────────────────┤
│                                                     │
│   Smart Strategies                       [🔄] [📤] │
│   Optimized recommendations for you                │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ CURRENT SCENARIO ─────────────────────────────┐  │
│ │                                               │  │
│ │  Your Loan: ₹12L @ 8.5% for 20 years        │  │
│ │  Monthly EMI: ₹1,01,385                      │  │
│ │  Effective EMI: ₹91,907 (with benefits)     │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ [ All ]  [ Save More ]  [ Lower EMI ]  [ Faster ] │
│    ●                                               │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ 💰 PREPAYMENT STRATEGY ──────────────────────┐  │
│ │                                               │  │
│ │  Annual Prepayment of ₹50,000               │  │
│ │                                               │  │
│ │  💵 Save ₹8,45,000 in interest              │  │
│ │  ⏱️ Reduce tenure by 6.2 years              │  │
│ │  📊 Effective rate drops to 6.8%            │  │
│ │                                               │  │
│ │  Best Time: Year 3-7 (maximum impact)       │  │
│ │                                               │  │
│ │  [📈 VIEW DETAILED PLAN]                     │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ 🏦 REFINANCING OPPORTUNITY ───────────────────┐  │
│ │                                               │  │
│ │  Bank of Maharashtra: 7.95%                  │  │
│ │  (0.55% lower than current rate)             │  │
│ │                                               │  │
│ │  💵 Save ₹4,32,000 over tenure               │  │
│ │  📉 EMI reduces to ₹98,650                   │  │
│ │  ⚡ Processing fee: ₹15,000                   │  │
│ │                                               │  │
│ │  Net Savings: ₹4,17,000                      │  │
│ │                                               │  │
│ │  [🔍 COMPARE ALL BANKS]                      │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ 📅 TENURE OPTIMIZATION ───────────────────────┐  │
│ │                                               │  │
│ │  Extend to 25 years (5 years more)          │  │
│ │                                               │  │
│ │  📉 EMI reduces to ₹87,240                   │  │
│ │  💰 Free up ₹4,665/month cash flow          │  │
│ │  ⚠️ Additional interest: ₹6,54,000           │  │
│ │                                               │  │
│ │  Good if: You have better investment options │  │
│ │                                               │  │
│ │  [📊 COMPARE SCENARIOS]                      │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│       [🧮]         [📊]         [⚡]                │
│    Calculator    Strategies   Settings            │
│                      ●                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Filtered View - "Save More" Tab

```
┌─────────────────────────────────────────────────────┐
│ Status Bar                                    4:30 PM│
├─────────────────────────────────────────────────────┤
│                                                     │
│   Smart Strategies                       [🔄] [📤] │
│   Optimized recommendations for you                │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ CURRENT SCENARIO ─────────────────────────────┐  │
│ │  Your Loan: ₹12L @ 8.5% for 20 years        │  │
│ │  Monthly EMI: ₹1,01,385 | Effective: ₹91,907│  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ [ All ]  [ Save More ]  [ Lower EMI ]  [ Faster ] │
│             ●                                      │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ 🏆 BEST SAVINGS STRATEGY                           │
│                                                     │
│ ┌─ 🎯 HYBRID APPROACH ───────────────────────────┐  │
│ │                                               │  │
│ │  Refinance @ 7.95% + ₹30k annual prepayment │  │
│ │                                               │  │
│ │  💰 Total Savings: ₹12,67,000                │  │
│ │  ⏱️ Loan tenure: 16.5 years                 │  │
│ │  📊 Effective EMI: ₹84,230                   │  │
│ │                                               │  │
│ │  Implementation Timeline:                     │  │
│ │  ▸ Year 1: Refinance to lower rate          │  │
│ │  ▸ Year 2-15: Annual prepayments            │  │
│ │                                               │  │
│ │  [🚀 START THIS STRATEGY]                    │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ 📈 SIP + PREPAYMENT COMBO ────────────────────┐  │
│ │                                               │  │
│ │  Invest EMI savings in equity SIP (12% CAGR) │  │
│ │                                               │  │
│ │  💵 Corpus after 20 years: ₹18,45,000       │  │
│ │  🎯 Use for prepayment in year 15-20         │  │
│ │  💰 Net wealth creation: ₹8,90,000           │  │
│ │                                               │  │
│ │  Risk: Market volatility                     │  │
│ │  Reward: Higher returns than loan savings    │  │
│ │                                               │  │
│ │  [📊 SEE PROJECTION]                         │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ 🎁 TAX OPTIMIZATION BOOST ────────────────────┐  │
│ │                                               │  │
│ │  Maximize Section 24B deduction              │  │
│ │                                               │  │
│ │  💡 Strategy: Structure loan optimally       │  │
│ │  🏠 Keep loan > ₹35L for maximum deduction   │  │
│ │  💰 Additional tax savings: ₹42,000/year    │  │
│ │                                               │  │
│ │  [ℹ️ TAX STRUCTURING GUIDE]                  │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│       [🧮]         [📊]         [⚡]                │
│    Calculator    Strategies   Settings            │
│                      ●                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Strategy Detail View

```
┌─────────────────────────────────────────────────────┐
│ Status Bar                                    4:30 PM│
├─────────────────────────────────────────────────────┤
│                                                     │
│   [←] Prepayment Strategy                  [📤] [❤️] │
│   Detailed analysis and action plan               │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ STRATEGY OVERVIEW ────────────────────────────┐  │
│ │                                               │  │
│ │  💰 Annual Prepayment of ₹50,000             │  │
│ │                                               │  │
│ │  Current Scenario     vs.    With Prepayment │  │
│ │  ────────────────           ─────────────────  │  │
│ │  EMI: ₹1,01,385             EMI: ₹1,01,385   │  │
│ │  Tenure: 20 years           Tenure: 13.8 yrs │  │
│ │  Interest: ₹24,33,240        Interest: ₹15,88,240│ │
│ │                              SAVINGS: ₹8,45,000│  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ YEAR-WISE IMPACT ─────────────────────────────┐  │
│ │                                               │  │
│ │  Year 1: Principal ↗️ ₹52,000 (vs ₹42,385)    │  │
│ │  Year 3: Outstanding ↘️ ₹9,50,000 (vs ₹10,85,000)│ │
│ │  Year 5: Interest saved so far: ₹2,15,000    │  │
│ │  Year 10: Loan closes 6.2 years early       │  │
│ │                                               │  │
│ │  [📈 VIEW DETAILED AMORTIZATION]             │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ IMPLEMENTATION GUIDE ─────────────────────────┐  │
│ │                                               │  │
│ │  ✅ Best Time to Start: Year 2 (after settling)│  │
│ │  💡 Optimal Amount: ₹50K-₹1L annually        │  │
│ │  📅 Timing: End of financial year (March)    │  │
│ │  🏦 Method: Direct bank transfer/cheque      │  │
│ │                                               │  │
│ │  Pro Tips:                                   │  │
│ │  • Use bonus/increment money                 │  │
│ │  • Prepay towards principal, not EMI        │  │
│ │  • Keep 6-month emergency fund first        │  │
│ │                                               │  │
│ │  [📋 CREATE ACTION PLAN]                     │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│        [📊 COMPARE WITH OTHER STRATEGIES]           │
│                                                     │
│              [🚀 START THIS STRATEGY]               │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│       [🧮]         [📊]         [⚡]                │
│    Calculator    Strategies   Settings            │
│                      ●                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Key Components Identified

### Strategy Components
1. **Strategy Cards**: Visual summary with key metrics
2. **Filter Tabs**: All, Save More, Lower EMI, Faster
3. **Comparison Tables**: Current vs. Optimized scenarios
4. **Action Plans**: Step-by-step implementation guides
5. **Impact Calculators**: Projections and savings visualization

### Interaction Patterns
1. **Card-based Layout**: Easy scanning of options
2. **Progressive Disclosure**: Summary → Details → Action plan
3. **Filter Navigation**: Quick access to relevant strategies
4. **Contextual Actions**: CTA buttons specific to each strategy

### Content Strategy
1. **Benefit-First**: Lead with savings/impact numbers
2. **Risk Transparency**: Clear pros and cons
3. **Implementation Clarity**: Practical next steps
4. **Visual Hierarchy**: Icons and typography for quick scanning

## Strategy Categories

### Save More Strategies
- Prepayment optimization
- Refinancing opportunities
- Tax benefit maximization
- Investment + prepayment combos

### Lower EMI Strategies  
- Tenure extension options
- Rate negotiation tips
- Balance transfer opportunities
- Income-based restructuring

### Faster Repayment
- Accelerated payment plans
- Principal-focused strategies
- Windfall optimization
- Career growth alignment

### Smart Combinations
- Hybrid approaches
- Risk-balanced strategies
- Life stage adaptations
- Goal-based planning

## Responsive Considerations

### Phone Landscape
- Horizontal strategy comparison
- Side-by-side current vs. optimized
- Condensed card layouts

### Tablet Portrait
- 2-column strategy grid
- Enhanced visualization space
- Detailed comparison tables

## Accessibility Features
- Clear strategy hierarchies
- Screen reader-friendly comparisons
- High contrast for financial data
- Voice-over support for calculations
- Simple language for complex concepts