# Strategy Detail Page Wireframe

## Purpose
Detailed view of a specific strategy showing calculations, implementation steps, and personalized impact based on user's loan parameters.

## Example: Extra EMI Strategy (12+1)

```
┌─────────────────────────────────────┐
│ ← Back to Strategies           [×] │
├─────────────────────────────────────┤
│                                     │
│ 💎 Extra EMI Strategy              │
│ Pay 13 EMIs per year               │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ YOUR POTENTIAL SAVINGS           │ │
│ │                                 │ │
│ │ 💰 Interest Saved: ₹7.2 Lakhs   │ │
│ │ ⏰ Time Saved: 5 years          │ │
│ │ 📊 Extra Payment: ₹26,085/year  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 📈 IMPACT VISUALIZATION             │
│ ┌─────────────────────────────────┐ │
│ │ [Graph showing loan timeline]   │ │
│ │ Original: 20 years = ₹62.6L    │ │
│ │ With Strategy: 15 years = ₹55.4L│ │
│ └─────────────────────────────────┘ │
│                                     │
│ 🎯 HOW TO IMPLEMENT                 │
│ ┌─────────────────────────────────┐ │
│ │ 1. Save ₹2,200 monthly          │ │
│ │    (₹26,085 ÷ 12 months)        │ │
│ │                                 │ │
│ │ 2. Use annual bonus/increment   │ │
│ │                                 │ │
│ │ 3. Make extra payment in Dec    │ │
│ │    (or any month you prefer)    │ │
│ │                                 │ │
│ │ 4. Inform bank it's for         │ │
│ │    principal reduction          │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 💡 PRO TIPS                         │
│ • Best time: After annual bonus    │
│ • Check prepayment charges (if any)│
│ • Get receipt for tax benefits     │
│                                     │
│ ⚠️ CONSIDERATIONS                   │
│ • Ensure emergency fund intact     │
│ • Don't strain monthly budget      │
│ • Some banks waive charges yearly  │
│                                     │
│ [Try Calculator] [Set Reminder]     │
│                                     │
├─────────────────────────────────────┤
│ [🏠] [💰] [📈] [📊]                │
│ Home Strategies Progress Calculator │
└─────────────────────────────────────┘
```

## Page Sections

### 1. Header Bar
- **Back navigation**: "← Back to Strategies" 
- **Close button**: [×] to return to strategies list
- **No loan summary header** (to maximize content space)

### 2. Strategy Title Section
- **Icon + Strategy Name**: Clear identification
- **Brief tagline**: One-line description

### 3. Savings Impact Box (Personalized)
- **Interest Saved**: Calculated for user's loan
- **Time Saved**: Years/months reduced
- **Required Payment**: Exact amount needed

### 4. Visual Impact Graph
- **Before/After comparison**: Timeline and total payment
- **Interactive elements**: Hover for details
- **Clear visual difference**: Original vs optimized

### 5. Implementation Steps
- **Step-by-step guide**: Numbered, actionable steps
- **Calculations shown**: Break down complex math
- **Specific to user**: Uses their loan parameters

### 6. Pro Tips Section
- **Best practices**: When and how to execute
- **Bank-specific notes**: Common policies
- **Tax implications**: If applicable

### 7. Considerations/Warnings
- **Risk factors**: What to watch out for
- **Prerequisites**: Emergency fund, etc.
- **Bank charges**: Prepayment fees info

### 8. Action Buttons
- **Try Calculator**: Deep link to calculator with this strategy
- **Set Reminder**: Add to calendar (if applicable)

### 9. Bottom Navigation
- Standard 4-tab navigation remains

## Content Variations by Strategy Type

### For "Instant Eye-Openers" (like Daily Burn):
- Focus on visualization and shock value
- Less implementation steps, more awareness

### For "Tax Strategies":
- Include tax calculation tables
- Show tax bracket impact
- Link to relevant tax sections

### For "Life Event Strategies":
- Timeline-based visualization
- Scenario comparisons
- Future projections

## Navigation Flow

```
Strategies List → Tap Strategy → Detail Page
                                      ↓
                              [Try Calculator] → Calculator Tab
                                      ↓
                              [Back] → Strategies List
```

## Technical Notes

- **Data source**: All calculations from Calculator tab settings
- **Personalization**: Updates when loan parameters change
- **Offline capable**: All calculations local
- **Responsive**: Adapts to screen size

## Accessibility

- **Back navigation**: Clear escape route
- **High contrast**: Important numbers highlighted
- **Readable fonts**: Calculation details legible
- **Touch targets**: Minimum 44px for buttons