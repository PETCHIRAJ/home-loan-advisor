# Calculator Screen Wireframe

> Primary EMI calculation interface with tax benefits integration

## Screen Layout (Portrait - 375x812px base)

```
┌─────────────────────────────────────────────────────┐
│ Status Bar                                    4:30 PM│
├─────────────────────────────────────────────────────┤
│                                                     │
│   Home Loan Calculator                    [i] [⚙]   │
│   Calculate accurately, save smartly               │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ INPUT SECTION ────────────────────────────────┐  │
│ │                                               │  │
│ │  Loan Amount                          ₹ Required│  │
│ │  ┌─────────────────────────────────────────┐   │  │
│ │  │ ₹12,00,000           [━━━━━━●─────────]  │   │  │
│ │  └─────────────────────────────────────────┘   │  │
│ │  5L                                       2Cr   │  │
│ │                                               │  │
│ │  Interest Rate                      % per annum│  │
│ │  ┌─────────────────────────────────────────┐   │  │
│ │  │ 8.5%                 [━━━━●───────────]  │   │  │
│ │  └─────────────────────────────────────────┘   │  │
│ │  6%                                       18%   │  │
│ │                                               │  │
│ │  Loan Tenure                            Years  │  │
│ │  ┌─────────────────────────────────────────┐   │  │
│ │  │ 20                   [━━━━━●─────────]   │   │  │
│ │  └─────────────────────────────────────────┘   │  │
│ │  5                                        30    │  │
│ │                                               │  │
│ │  [Compare 15 Bank Rates ▼]                   │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ TAX BENEFITS SECTION ─────────────────────────┐  │
│ │                                               │  │
│ │  Enable Tax Benefits        [●] ON    [ ] OFF │  │
│ │                                               │  │
│ │  Annual Income                        ₹ Lakhs │  │
│ │  ┌─────────────────────────────────────────┐   │  │
│ │  │ ₹8.5L                [━━●────────────]   │   │  │
│ │  └─────────────────────────────────────────┘   │  │
│ │                                               │  │
│ │  Tax Bracket: 20%           [i] How it helps │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ PMAY ELIGIBILITY ─────────────────────────────┐  │
│ │                                               │  │
│ │  Check PMAY Subsidy         [●] Check [ ] Skip│  │
│ │                                               │  │
│ │  First Home Buyer           [●] Yes  [ ] No   │  │
│ │  Annual Family Income: ₹8.5L                  │  │
│ │                                               │  │
│ │  ✓ Eligible for MIG-I Subsidy                │  │
│ │  Potential Savings: ₹2.35L   [i] Learn More  │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│                [CALCULATE EMI]                      │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│       [🧮]         [📊]         [⚡]                │
│    Calculator    Strategies   Settings            │
│        ●                                           │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Results State (After Calculation)

```
┌─────────────────────────────────────────────────────┐
│ Status Bar                                    4:30 PM│
├─────────────────────────────────────────────────────┤
│                                                     │
│   Home Loan Results                      [🔄] [📤] │
│   Your smart calculation summary                  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ EMI BREAKDOWN ────────────────────────────────┐  │
│ │                                               │  │
│ │     Monthly EMI                               │  │
│ │     ₹1,01,385                                │  │
│ │     per month for 20 years                   │  │
│ │                                               │  │
│ │ ┌─ Component Breakdown ──────────────────┐    │  │
│ │ │ Principal Component      ₹42,385      │    │  │
│ │ │ Interest Component       ₹59,000      │    │  │
│ │ │ Tax Benefit Savings      -₹8,500      │    │  │
│ │ │ PMAY Subsidy Benefit    -₹978         │    │  │
│ │ └──────────────────────────────────────┘    │  │
│ │                                               │  │
│ │ Effective EMI: ₹91,907 (9% savings!)        │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ┌─ TOTAL COST ANALYSIS ──────────────────────────┐  │
│ │                                               │  │
│ │ Total Interest Payable    ₹1,41,64,400       │  │
│ │ Less: Tax Benefits        -₹20,40,000         │  │
│ │ Less: PMAY Subsidy        -₹2,35,000          │  │
│ │ ─────────────────────────────────────────     │  │
│ │ Net Interest Cost         ₹1,18,89,400       │  │
│ │                                               │  │
│ │ You save ₹22,75,000 over loan tenure!       │  │
│ │                                               │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│    [📋 VIEW AMORTIZATION]  [🔍 SEE STRATEGIES]     │
│                                                     │
│              [RECALCULATE]                          │
│                                                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│       [🧮]         [📊]         [⚡]                │
│    Calculator    Strategies   Settings            │
│        ●                                           │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Key Components Identified

### Input Components
1. **Hybrid Slider-TextInput**: Amount, rate, tenure with both control methods
2. **Toggle Switches**: Tax benefits, PMAY eligibility
3. **Bank Rate Comparison**: Expandable dropdown with 15 bank rates
4. **Smart Validation**: Real-time feedback on input ranges

### Display Components  
1. **EMI Summary Card**: Large, prominent monthly payment
2. **Breakdown Table**: Component-wise EMI breakdown
3. **Savings Highlight**: Tax + PMAY benefit visualization
4. **Total Cost Analysis**: Comprehensive loan cost summary

### Interaction Patterns
1. **Progressive Disclosure**: Basic → Advanced options
2. **Smart Defaults**: Pre-filled common values
3. **Contextual Help**: Info icons with explanatory popups
4. **One-Touch Calculation**: Single CTA button

### Information Hierarchy
1. **Primary**: Monthly EMI amount
2. **Secondary**: Component breakdown
3. **Tertiary**: Total cost analysis
4. **Supporting**: Help text and disclaimers

## Responsive Considerations

### Phone Landscape (667x375px)
- Horizontal layout for sliders
- Side-by-side input sections
- Condensed results display

### Tablet Portrait (768x1024px)
- Wider input sections
- Side-by-side tax benefits and PMAY
- Enhanced visual hierarchy

## Accessibility Features
- Minimum 44px touch targets
- High contrast ratios for financial data
- Screen reader labels for all inputs
- Voice-over support for calculation results
- Haptic feedback for slider interactions