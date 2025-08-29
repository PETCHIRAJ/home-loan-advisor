# Home Loan Advisor - Wireframe Documentation

## Project Overview

**App Name:** Home Loan Advisor  
**Tagline:** "Calculate accurately, save smartly"  
**Platform:** Flutter Mobile App (iOS/Android)  
**Target Audience:** Indian home loan borrowers  

## Design Philosophy

### Core Principles
- **Simplicity First**: Only 2 main screens to avoid overwhelm
- **Mobile-First**: Thumb-friendly interactions, scannable content
- **Trust & Transparency**: Clear calculations, no hidden features
- **Actionable Insights**: Focus on specific savings strategies with ₹ amounts

### App Scope
- **Pure Calculator + Strategies**: No login, no tracking, no complexity
- **Offline-Capable**: All calculations work without internet
- **Indian Context**: Tax benefits, local strategies, ₹ currency

## Navigation Structure

```
Home Loan Advisor App
├── Calculator Tab (Default)
│   ├── Basic EMI Calculator
│   ├── Advanced Options Panel
│   └── Results Visualization
└── Strategies Tab
    ├── Strategy Overview Grid (7 strategies)
    ├── Strategy Detail Screens (7 screens)
    └── Combination Calculator
```

## Screen Breakdown

### Primary Screens (2)
1. **Calculator Screen** - EMI calculation with visualizations
2. **Strategies Screen** - 7 money-saving strategies overview

### Secondary Screens (7)
- Strategy Detail Screens (one for each strategy)

## User Flow Summary

1. **Entry Point**: Calculator screen (most common use case)
2. **Quick Calculation**: Input loan details → Get EMI + tax benefits
3. **Explore Savings**: Switch to Strategies tab → Browse 7 strategies
4. **Deep Dive**: Tap strategy → See detailed implementation + savings
5. **Share Results**: Export/share calculations or strategy insights

## Key Features per Screen

### Calculator Screen
- Real-time EMI calculation
- Tax benefit calculator (80C, 24B)
- Prepayment scenarios
- Interactive charts/graphs
- Shareable results

### Strategies Screen
- 7 strategy cards with savings amounts
- Quick filtering/sorting
- Combination calculator
- Implementation difficulty indicators

### Strategy Detail Screens
- Hero savings number
- Before/after comparison
- Step-by-step implementation
- Risk factors
- Share functionality

## Success Metrics
- **Usability**: Can complete EMI calculation in < 30 seconds
- **Discoverability**: Users find at least 2 relevant strategies
- **Actionability**: Clear next steps for each strategy
- **Trust**: Transparent calculations with explanations

## Technical Considerations
- **Performance**: Instant calculations, smooth animations
- **Offline**: Core functionality works without internet
- **Accessibility**: Screen reader support, sufficient contrast
- **Localization**: Support for Indian number formats (₹1,23,45,678)