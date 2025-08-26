# User Flow Diagrams

## Primary User Journey

```
START → Dashboard → Calculator → Strategies → Progress → REPEAT
  ↑         ↓          ↓          ↓          ↓
  ←─────────────────────────────────────────────
```

### Journey Details

**Dashboard (Entry Point)**
- User opens app
- Sees Daily Interest Burn Counter (₹847 lost today)
- Emotional impact → motivated to act
- **Next**: Taps "Calculate Savings" → Calculator

**Calculator (Reality Check)**  
- User inputs loan details (3 fields)
- Sees shocking total interest (₹50+ lakhs)
- Realizes loan cost doubles the principal
- **Next**: Taps strategy OR "View All Strategies" → Strategies

**Strategies (Solution Discovery)**
- User explores 20 money-saving features
- Finds applicable strategies (bi-weekly, round-up)
- Learns about potential savings
- **Next**: Activates strategy → Progress tracking

**Progress (Motivation Loop)**
- User tracks activated strategies
- Sees actual savings accumulation
- Unlocks achievements and badges
- **Next**: Returns to Dashboard → Cycle continues

## Secondary User Flows

### Quick Action Flows

```
Dashboard → Quick Actions → Direct Feature Access
    ↓              ↓              ↓
View Strategies → Strategy Hub → Savings Optimization
EMI Calculator → Advanced Calc → Scenario Analysis  
Track Progress → Progress Screen → Achievement View
```

### Discovery Flows

```
Strategies → Category Browse → Feature Deep Dive
    ↓              ↓              ↓
Core Calculators → Bi-Weekly → Implementation Guide
Eye-Openers → 78% Rule → Educational Content
Life Planning → Marriage → Dual Income Optimization
```

## Task-Based Flows

### First Time User Flow

```
App Launch → Onboarding → Loan Input → Shock Value → Strategy Selection → Setup Complete
     ↓            ↓           ↓          ↓              ↓                ↓
Welcome → 3-Screen Tour → Calculator → Reality Check → Choose 2-3 → Progress Tracking
```

### Returning User Flow

```
App Launch → Dashboard → Quick Update → Action
     ↓           ↓          ↓            ↓
Daily Check → Burn Counter → See Progress → Adjust Strategy
```

### Feature Discovery Flow

```
Curiosity → Strategies Hub → Category Filter → Feature Detail → Implementation
    ↓           ↓              ↓               ↓              ↓
"What else?" → 20 Features → Behavioral → Coffee-EMI → Calculator Integration
```

## Navigation Patterns

### Bottom Tab Navigation (Always Accessible)

```
🏠 Home ←→ 📊 Calculator ←→ 🎯 Strategies ←→ ⚙️ Progress ←→ 👤 Profile
   ↓            ↓               ↓              ↓           ↓
Dashboard → Input/Results → Feature Hub → Tracking → Settings
```

### Information Architecture Flow

```
App Root
├── 🏠 Home (Dashboard)
│   ├── Daily Burn Counter
│   ├── Health Score → Improvement Tips
│   ├── Daily Tip → Impact Calculator
│   └── Quick Actions → Direct Features
│
├── 📊 Calculator
│   ├── 3-Input Form
│   ├── Reality Check Display
│   ├── Top 3 Strategies
│   └── All Strategies Link → Strategies Hub
│
├── 🎯 Strategies
│   ├── Core Calculators (4)
│   ├── Eye-Openers (4) 
│   ├── Smart Analysis (3)
│   ├── Behavioral Motivators (3)
│   ├── Life Event Planning (3)
│   └── Advanced Predictions (3)
│
├── ⚙️ Progress
│   ├── Current Savings
│   ├── Active Strategies
│   ├── Achievement Badges
│   └── Consistency Tracking
│
└── 👤 Profile
    ├── Loan Settings
    ├── Notification Preferences
    ├── Sharing Features
    └── Help/Support
```

## User Intent Mapping

### High Intent (Ready to Act)
**Trigger**: Saw shocking numbers, wants immediate action
**Flow**: Calculator → Top Strategies → Implementation Guide → Progress Setup
**Key Metric**: Strategy activation rate

### Medium Intent (Exploring Options)
**Trigger**: Curious about savings possibilities
**Flow**: Dashboard → Strategies Hub → Feature Comparison → Bookmarking
**Key Metric**: Feature exploration depth

### Low Intent (Passive Learning)
**Trigger**: Daily habit check-in
**Flow**: Dashboard → Progress Review → Achievement Check → Daily Tip
**Key Metric**: Return visit frequency

## Critical Decision Points

### Moment 1: First Impression (Dashboard)
**User Question**: "Is this app worth my time?"
**Design Response**: Daily burn counter shows immediate value
**Success Metric**: Time spent on dashboard > 30 seconds

### Moment 2: Calculation Results (Calculator)
**User Question**: "Is this accurate? Can I really save this much?"
**Design Response**: Detailed breakdown with credible numbers
**Success Metric**: Progression to strategies screen > 60%

### Moment 3: Strategy Selection (Strategies)
**User Question**: "Which strategy should I actually use?"
**Design Response**: Clear impact ranking with difficulty indication
**Success Metric**: Strategy activation > 40%

### Moment 4: Implementation (Progress)
**User Question**: "Is this actually working?"
**Design Response**: Real progress tracking with achievement rewards
**Success Metric**: 30-day retention > 70%

## Error Recovery Flows

### Invalid Input Recovery
```
Calculator → Validation Error → Helpful Message → Corrected Input → Success
    ↓              ↓               ↓              ↓             ↓
Empty Field → "Enter amount" → Example shown → User fixes → Calculation
```

### Network Error Recovery
```
Feature Access → Network Error → Offline Message → Cached Content → Full Experience
     ↓               ↓              ↓               ↓              ↓
API Call → Connection Failed → "Working offline" → Local calc → Seamless UX
```

### Incomplete Setup Recovery
```
Strategy Activation → Missing Data → Quick Input → Setup Complete → Feature Active
       ↓                 ↓            ↓             ↓              ↓
"Enable bi-weekly" → "Need bank info" → 2-field form → Data saved → Tracking starts
```

## Success Metrics by Flow

### Engagement Flow
- **Dashboard → Calculator**: 70% of users
- **Calculator → Strategies**: 60% of users  
- **Strategies → Progress**: 40% of users
- **Progress → Return Visit**: 80% of users

### Conversion Flow
- **Discovery → Strategy Selection**: 45%
- **Selection → Implementation**: 35%
- **Implementation → 7-day retention**: 60%
- **7-day → 30-day retention**: 70%

### Satisfaction Flow
- **Feature Discovery Rate**: 80% find relevant feature
- **Implementation Success**: 70% successfully activate
- **Perceived Value**: 85% report actual savings
- **Recommendation Rate**: 75% would recommend app

These flows prioritize emotional engagement first, then education, then action, creating a sustainable motivation loop for long-term behavior change.