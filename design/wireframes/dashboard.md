# Dashboard Screen Wireframe

## Purpose
Main entry point that creates immediate emotional impact through the Daily Interest Burn Counter, shows loan health gamification, and provides quick access to key features.

## Layout Structure

```
┌─────────────────────────────────────┐
│ [☰] Home Loan Advisor      [🔔][⚙] │
├─────────────────────────────────────┤
│                                     │
│ ⚡ LIVE MONEY BURN COUNTER ⚡       │
│ ┌─────────────────────────────────┐ │
│ │ ₹847                           │ │
│ │ LOST TODAY                     │ │
│ │ ₹25,410 this month            │ │
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
│ ┌───────────┐ ┌───────────────────┐ │
│ │ Calculate │ │ View Strategies   │ │
│ │ Savings   │ │                   │ │
│ └───────────┘ └───────────────────┘ │
│ ┌───────────┐ ┌───────────────────┐ │
│ │ EMI       │ │ Track Progress    │ │
│ │ Calculator│ │                   │ │
│ └───────────┘ └───────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│ [🏠] [📊] [🎯] [⚙️] [👤]           │
│ Home Calc Strategy Progress Profile │
└─────────────────────────────────────┘
```

## Component Breakdown

### Header (High Priority)
- Hamburger menu (navigation drawer)
- App title "Home Loan Advisor"
- Notifications bell icon
- Settings gear icon

### Daily Burn Counter (Hero Element)
- **Purpose**: Create emotional urgency, shock value
- **Content**: Live updating amount lost today (₹847)
- **Secondary**: Monthly loss amount (₹25,410)
- **Action**: "View Breakdown" button
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
- **Purpose**: Direct access to key features
- **Layout**: 2x2 grid of action cards
- **Options**: 
  - Calculate Savings (primary action)
  - View Strategies (offline optimization)
  - EMI Calculator (offline calculations)
  - Track Progress (motivation)

### Bottom Navigation (Persistent)
- **Purpose**: Always-accessible main navigation
- **Icons**: Home, Calculator, Strategy, Progress, Profile
- **Active State**: Home tab highlighted
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