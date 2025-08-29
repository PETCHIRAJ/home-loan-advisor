# Strategy Detail Screen Wireframe

## Layout Overview
Detailed view of a specific strategy with hero savings number, implementation steps, and risk considerations. Focus on actionable guidance.

## ASCII Wireframe (Example: Balance Transfer Strategy)

```
┌─────────────────────────────────────┐ ← StatusBar
│ [<] Balance Transfer           [⋯] │ ← Back button + options menu
├─────────────────────────────────────┤
│                                     │
│  💰 YOU COULD SAVE                  │ ← Hero section
│      ₹ 3,50,000                     │ ← Large savings amount
│   over remaining loan tenure        │
│                                     │
│  💡 By reducing rate from 9.2%      │ ← Context for calculation
│      to 7.8% (1.4% lower)           │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │  BEFORE      →     AFTER        │ │ ← Before/After comparison
│  │                                 │ │
│  │  EMI: ₹41,822  →  EMI: ₹38,544 │ │
│  │  Rate: 9.2%    →  Rate: 7.8%   │ │
│  │  Total: ₹1.0Cr →  Total: ₹96.5L│ │
│  └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤ ← Separator
│                                     │
│  📋 HOW IT WORKS                    │ ← Implementation section
│                                     │
│  Balance transfer lets you move     │
│  your existing loan to a new bank   │
│  with lower interest rates.         │
│                                     │
│  ✨ Best for loans >2 years old     │
│  ✨ When rate difference >0.5%      │
│  ✨ Good credit score (750+)        │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  📝 STEP-BY-STEP GUIDE             │ ← Action steps
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ STEP 1   Research & Compare     │ │
│  │ ⏱️ 3-5 days                     │ │
│  │                                 │ │
│  │ • Check 5+ banks for rates      │ │
│  │ • Compare processing fees       │ │
│  │ • Calculate break-even point    │ │
│  │                                 │ │
│  │ [ Rate Comparison Tool ]        │ │ ← Link to external tool
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ STEP 2   Apply & Documentation  │ │
│  │ ⏱️ 7-10 days                    │ │
│  │                                 │ │
│  │ • Income proof (3 months)       │ │
│  │ • Property documents            │ │
│  │ • Existing loan statements      │ │
│  │ • Credit score report           │ │
│  │                                 │ │
│  │ [ Document Checklist ]          │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ STEP 3   Approval & Processing  │ │
│  │ ⏱️ 15-30 days                   │ │
│  │                                 │ │
│  │ • Property valuation            │ │
│  │ • Legal & technical clearance   │ │
│  │ • Loan approval & sanction      │ │
│  │ • Original bank payoff          │ │
│  │                                 │ │
│  │ ⚠️ Don't close old loan early   │ │ ← Important warning
│  └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ⚠️ THINGS TO CONSIDER              │ ← Risk/consideration section
│                                     │
│  COSTS INVOLVED:                    │
│  • Processing fee: ₹15,000-50,000   │
│  • Legal charges: ₹5,000-15,000     │
│  • Valuation fee: ₹2,000-5,000      │
│                                     │
│  POTENTIAL RISKS:                   │
│  • Rate may increase after 1-2 years│
│  • CIBIL inquiry impacts score      │
│  • Existing bank may offer counter  │
│                                     │
│  NOT SUITABLE IF:                   │
│  • Loan balance <₹10 lakhs          │
│  • Remaining tenure <3 years        │
│  • Recent payment delays (6 months) │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  📈 BREAK-EVEN ANALYSIS             │ ← Financial analysis
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ Cost of Transfer: ₹ 35,000      │ │
│  │ Monthly Savings: ₹ 3,278        │ │
│  │ Break-even Time: 11 months      │ │ ← Key insight
│  │                                 │ │
│  │ After 11 months, you start      │ │
│  │ saving ₹3,278 every month!      │ │
│  └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  🏆 SUCCESS TIPS                    │ ← Practical advice
│                                     │
│  • Negotiate with current bank first│
│  • Apply to 2-3 banks simultaneously│
│  • Time it with your income hike    │
│  • Keep all original docs ready     │
│  • Get pre-approval before applying │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  📚 RELATED STRATEGIES              │ ← Cross-references
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ Extra Principal  Save ₹4,25,000 │ │
│  │ Combine for maximum impact  [>] │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ Rate Review      Save ₹75,000   │ │
│  │ Try this first before transfer[>]│ │
│  └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  [ 📤 Share This Strategy ]         │ ← Sharing options
│  [ 🧮 Calculate for My Loan ]       │ ← Jump to calculator
│  [ ⭐ Save to Favorites ]           │ ← Personal organization
│                                     │
└─────────────────────────────────────┘
```

## Hero Section Components

### Savings Calculation Display
```
┌─────────────────────────────────────┐
│  💰 YOU COULD SAVE                  │
│      ₹ 3,50,000                     │ ← 32sp, bold, primary color
│   over remaining loan tenure        │ ← 14sp, subtitle
│                                     │
│  💡 By reducing rate from 9.2%      │ ← Context explanation
│      to 7.8% (1.4% lower)           │ ← Specific numbers
│                                     │
│  [ Recalculate for My Loan ]        │ ← Personalization CTA
└─────────────────────────────────────┘
```

### Before/After Comparison
Visual comparison with clear contrast:
- **Left Column**: Current situation (darker/muted colors)
- **Right Column**: Improved situation (brighter/success colors)  
- **Arrow (→)**: Clear visual flow indicator
- **Key Metrics**: EMI, Rate, Total Amount

## Step-by-Step Implementation Guide

### Step Card Structure
Each step contains:
1. **Step Number + Title**: Clear progression
2. **Time Estimate**: Realistic timeline
3. **Action Items**: Bulleted checklist
4. **Helper Links**: Tools, checklists, calculators
5. **Warnings**: Important cautions (⚠️ icon)

### Progressive Disclosure
```
┌─────────────────────────────────────┐
│ STEP 1   Research & Compare     [v] │ ← Expandable header
│ ⏱️ 3-5 days                         │
├─────────────────────────────────────┤
│ • Check 5+ banks for rates          │ ← Expanded content
│ • Compare processing fees           │
│ • Calculate break-even point        │
│                                     │
│ 💡 Pro tip: Use bank's website      │
│    rate calculators for accuracy    │
│                                     │
│ [ Rate Comparison Tool ]            │
│ [ Document Checklist ]              │
└─────────────────────────────────────┘
```

## Risk Assessment Section

### Three Categories of Considerations
1. **Costs Involved**: All upfront and hidden costs
2. **Potential Risks**: Things that could go wrong
3. **Not Suitable If**: Clear exclusion criteria

### Warning Callouts
```
┌─────────────────────────────────────┐
│ ⚠️ IMPORTANT WARNING                │ ← Red/orange background
│                                     │
│ Don't close your existing loan      │
│ until the new loan is fully        │
│ approved and disbursed.             │
│                                     │
└─────────────────────────────────────┘
```

## Break-Even Analysis Widget

### Financial Summary
```
┌─────────────────────────────────────┐
│ 📈 YOUR BREAK-EVEN ANALYSIS         │
│                                     │
│ One-time Cost:    ₹ 35,000          │
│ Monthly Savings:  ₹ 3,278           │ ← Highlighted
│ Break-even:       11 months         │ ← Key metric
│                                     │
│ ┌─────────────────────────────────┐ │
│ │         MONTHLY TIMELINE        │ │
│ │                                 │ │
│ │ Months 1-11:  -₹3,500 (cost)   │ │
│ │ Months 12+:   +₹3,278 (save)   │ │ ← Positive color
│ │                                 │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Success Tips Section

### Practical Advice Format
- **Bullet Points**: Scannable format
- **Actionable Language**: Specific verbs (negotiate, apply, time)
- **Insider Knowledge**: Professional insights
- **Order by Priority**: Most important tips first

## Related Strategies Cross-Reference

### Strategy Cards (Compact)
```
┌─────────────────────────────────────┐
│ 💰 Extra Principal Payments     [>] │
│ SAVE ₹4,25,000 • Combine for max   │ ← Benefits of combining
└─────────────────────────────────────┘
```

### Combination Suggestions
- **Complementary Strategies**: Work well together
- **Alternative Strategies**: Try before/instead of current
- **Sequential Strategies**: Do in order for maximum benefit

## Interactive Elements

### Action Buttons
- **Primary CTA**: "Calculate for My Loan" (blue/prominent)
- **Secondary Actions**: Share, Save (outline style)
- **Helper Links**: Underlined text links

### Navigation
- **Back Button**: Return to strategies list
- **Options Menu (⋯)**: Share, print, report issue
- **Related Strategy Links**: Navigate to other strategy details

## Mobile UX Considerations

### Scrolling Behavior
- **Sticky Header**: Keep strategy name and savings visible
- **Progressive Loading**: Load sections as user scrolls
- **Smooth Transitions**: Between expanded/collapsed states

### Touch Interactions
- **Expandable Sections**: Tap to show/hide details
- **Swipe Navigation**: Left/right for prev/next strategy
- **Pull-to-Refresh**: Update calculations with latest rates

### Content Chunking
- **Visual Breaks**: Clear section separators
- **Scannable Format**: Headlines, bullets, short paragraphs
- **Key Information**: Highlighted boxes and callouts

## Personalization Features

### Dynamic Content
- **Savings Calculations**: Based on user's loan details from calculator
- **Applicable Criteria**: Highlight if strategy suits user
- **Time Estimates**: Adjust based on user profile/region

### Smart Suggestions
- **Next Best Strategy**: After completing current one
- **Combination Opportunities**: Multiple strategies together
- **Risk Warnings**: Personalized to user situation

## Accessibility Features

### Content Structure
- **Heading Hierarchy**: H1 (strategy name) → H2 (sections) → H3 (steps)
- **Alt Text**: Descriptive text for all icons and images
- **Focus Order**: Logical tab sequence through content

### Visual Design
- **High Contrast**: Text meets WCAG AA standards
- **Scalable Text**: Works at 200% zoom
- **Color Independence**: Information not dependent on color alone