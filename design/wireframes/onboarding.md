# Onboarding Screen Wireframe

## Purpose
First screen users see - creates immediate value proposition awareness and guides them to calculator with default values for instant gratification.

## Layout Structure

```
┌─────────────────────────────────────┐
│                                     │
│            🏠💰                     │
│        Home Loan Advisor           │
│                                     │
│     Save Lakhs on Your Loan        │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 💡 Most Indians pay ₹8+ lakhs  │ │
│  │    EXTRA in home loan interest  │ │
│  │                                 │ │
│  │    Discover your hidden         │ │
│  │    savings opportunities        │ │
│  └─────────────────────────────────┘ │
│                                     │
│  📊 What You'll Get:               │
│  • Daily interest loss tracker      │
│  • 20 money-saving strategies      │
│  • Instant savings calculations    │
│  • 100% private, offline-first     │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │      [Start Free Analysis]      │ │
│  │           ↓                     │ │
│  │    See Sample Calculations      │ │
│  └─────────────────────────────────┘ │
│                                     │
│            Skip for now             │
└─────────────────────────────────────┘
```

## Component Breakdown

### Hero Section
- **App branding**: Logo + tagline "Save Lakhs on Your Loan"
- **Value hook**: Shocking statistic about extra interest paid
- **Promise**: Clear benefit proposition

### Feature Preview
- **4 key benefits** that address user pain points:
  - Daily tracking (urgency)
  - Strategies (solutions) 
  - Calculations (proof)
  - Privacy (trust)

### Primary CTA
- **"Start Free Analysis"** → Goes directly to Calculator
- **Subtitle**: "See Sample Calculations" (sets expectation)
- **Psychology**: Uses "free" and "analysis" (professional feel)

### Secondary Option
- **"Skip for now"** → Goes to Dashboard with sample data
- **Low pressure** for users who want to explore first

## User Flow After Onboarding

### Primary Path (Recommended)
1. User taps "Start Free Analysis"
2. → Calculator screen with realistic Tamil Nadu defaults:
   - Loan Amount: ₹30,00,000
   - Interest Rate: 8.5%
   - Tenure: 20 years
3. User immediately sees EMI calculation (₹25,415)
4. User can modify values → instant updates
5. User navigates to Dashboard → sees personalized data

### Secondary Path
1. User taps "Skip for now"  
2. → Dashboard with same default values pre-loaded
3. User sees sample burn counter, health score
4. Can navigate to Calculator to customize

## Technical Implementation Notes

### Smart Default Values (Tamil Nadu Context)
- **Loan Amount**: ₹30,00,000 (realistic for Chennai/Coimbatore)
- **Interest Rate**: 8.5% (current market average)
- **Tenure**: 20 years (common choice)
- **Monthly Income**: ₹1,00,000 (healthy 25% EMI ratio)
- **Age**: 30 years (typical first-time buyer)
- **EMI Result**: ₹25,415/month

### State Management
- Smart defaults stored immediately after onboarding
- Calculator tab becomes the "control center" for all settings
- All screens (Dashboard, Strategies, Progress) react to calculator changes
- Settings icon in header navigates to Calculator tab
- 4-tab bottom navigation: Home, Strategies, Progress, Calculator

## Content Requirements

### Emotional Hooks
- Use "₹8+ lakhs EXTRA" statistic (shocking, specific)
- "Hidden savings opportunities" (discovery motivation)
- "100% private" (trust building for financial data)

### Tamil Nadu Localization
- Currency format: ₹30,00,000 (Indian lakh notation)
- Cultural context: "Most Indians" (relatability)
- Conservative approach: "Free analysis" vs "Calculator" (professional)

## Accessibility Considerations
- Large tap targets for primary CTA
- High contrast text for readability
- Clear hierarchy: Hero → Benefits → Action
- Screen reader friendly content structure