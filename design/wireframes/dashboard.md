# Dashboard Screen Wireframe

## Purpose
Main screen showing daily interest loss with smart defaults on first launch, personalized data on return visits. Serves as the emotional hook and summary view of loan status.

## Layout Structure

```
┌─────────────────────────────────────┐
│ 🏠 Home Loan Advisor            [⚙️] │
├─────────────────────────────────────┤
│                                     │
│ ℹ️ Using sample data - Tap ⚙️ to    │
│   customize for your loan           │
├─────────────────────────────────────┤
│                                     │
│ ⚡ LIVE MONEY BURN COUNTER ⚡       │
│ ┌─────────────────────────────────┐ │
│ │ ₹696                           │ │
│ │ LOST TODAY                     │ │
│ │ ₹21,000 this month            │ │
│ │ Loan: ₹30L @ 8.5% (20yr)      │ │
│ │ [View Breakdown]               │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 🏠 YOUR LOAN HEALTH SCORE          │
│ ┌─────────────────────────────────┐ │
│ │ 6.2/10  [●●●●●●○○○○]           │ │
│ │ Fair - Room for improvement     │ │
│ │ [See How to Improve]            │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 💡 TODAY'S MONEY-SAVING TIP        │
│ ┌─────────────────────────────────┐ │
│ │ Round up your EMI to ₹26,000   │ │
│ │ Save ₹2,47,000 over loan life  │ │
│ │ [Calculate Impact] [Dismiss]    │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 🚀 QUICK ACTIONS                   │
│ ┌─────────────────────────────────┐ │
│ │ [💡 Explore Strategies]         │ │
│ │ Discover 20 ways to save        │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [📊 View Full Calculator]       │ │
│ │ Customize all loan details      │ │
│ └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│ [🏠] [💰] [📈] [📊]               │
│ Home Strategies Progress Calculator │
└─────────────────────────────────────┘
```

## Component Breakdown

### Header (Clean & Simple)
- App title "🏠 Home Loan Advisor"
- Settings gear icon (navigates to Calculator tab)
- No hamburger menu or notifications
- Minimal, distraction-free design

### Daily Burn Counter (Hero Element)
- **Purpose**: Create emotional urgency, shock value
- **Content**: Live updating amount lost today (₹696 for ₹30L loan)
- **Secondary**: Monthly loss amount (₹21,000)
- **Context**: Shows loan parameters "₹30L @ 8.5% (20yr)"
- **Sample Data Notice**: Clear indication when using defaults
- **Psychology**: Fear of loss motivates action

### Loan Health Score (Gamification)
- **Purpose**: Gamify loan optimization
- **Display**: Score out of 10 (6.2/10)
- **Visual**: Progress bar with filled/empty circles
- **Status**: Text description "Fair - Room for improvement"
- **Action**: "See How to Improve" button
- **Psychology**: Progress visualization encourages improvement

### Money-Saving Tip (Personalized)
- **Purpose**: Provide actionable daily insight
- **Content**: Specific recommendation "Round up EMI to ₹26,000"
- **Impact**: Quantified savings "Save ₹2,47,000 over loan life"
- **Actions**: "Calculate Impact" and "Dismiss" buttons
- **Psychology**: Specific numbers feel achievable

### Quick Actions (Task-Oriented)
- **Purpose**: Direct navigation to main features
- **Layout**: 2 large action cards
- **Primary CTA**: "Explore Strategies" - drives engagement
- **Secondary CTA**: "View Full Calculator" - customization
- **Streamlined**: Focused on most important actions
- **Navigation**: Complements bottom tab bar

### Bottom Navigation (4-Tab System)
- **Purpose**: Always-accessible main navigation
- **Tabs**: [🏠 Home] [💰 Strategies] [📈 Progress] [📊 Calculator]
- **Active State**: Home tab highlighted
- **Calculator**: Primary control center for all settings
- **Psychology**: Familiar mobile navigation pattern

## Information Hierarchy

1. **Daily Burn Counter** (Highest emotional impact)
2. **Loan Health Score** (Gamification hook)
3. **Personalized Tip** (Actionable insight)
4. **Quick Actions** (Task completion)
5. **Navigation** (App exploration)

## User Actions

### Primary Flow
1. User sees burn counter → shocked by daily loss
2. Views loan health score → motivated to improve
3. Reads personalized tip → considers action
4. Taps "Calculate Savings" → moves to Calculator screen

### Secondary Flows
- Tap notification → view alerts/updates
- Tap settings → app preferences
- Tap health score → improvement strategies
- Tap "View Strategies" → 20 offline strategies
- Tap "EMI Calculator" → advanced calculations
- Tap "Track Progress" → savings journey

## Content Requirements

- Offline calculation based on user's loan data
- Personalized tips based on user behavior patterns
- Achievement badges for gamification
- Cultural elements (Indian festivals, local context)
- All features work without internet connectivity
- Data stored locally for privacy and speed

## Accessibility Considerations

- High contrast for burn counter (emergency color)
- Large tap targets for quick actions
- Clear visual hierarchy with proper spacing
- Screen reader friendly labels