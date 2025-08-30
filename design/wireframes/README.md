# Home Loan Advisor - Design Wireframes

> ASCII wireframes for India's first tax-aware EMI calculator with PMAY benefits

**Purpose**: Establish information architecture and user experience flows for a 2-screen Flutter app targeting Indian home loan borrowers aged 25-45.

**Target Audience**: Indian professionals seeking accurate home loan calculations with tax benefits and PMAY subsidy integration.

**Last Updated**: 2025-08-30

## App Overview

**Unique Value Proposition**: "Calculate accurately, save smartly" - India's first tax-aware EMI calculator with PMAY benefits integration.

### Key Features
- Tax benefits integration (Section 80C, 24B)
- PMAY subsidy calculator
- 15 bank interest rates comparison
- Hybrid slider+text input system
- Strategy recommendations

### Target Users
- Age: 25-45 years
- Profile: Indian home loan borrowers
- Tech comfort: Moderate to high
- Financial literacy: Beginner to intermediate

### Technical Context
- Platform: Flutter mobile app
- Design System: Material 3
- Screens: 2 primary (Calculator, Strategies)
- Navigation: Bottom navigation
- Orientation: Portrait-first with landscape support

### Design Principles
1. **Trust & Accuracy**: Professional design conveying financial reliability
2. **Simplicity**: Complex calculations made approachable
3. **Indian Context**: Culturally relevant (₹, lakhs/crores, PMAY)
4. **Accessibility**: WCAG 2.1 AA compliance for inclusive design

## Screen Architecture

### Primary Screens
1. **Calculator Screen**: EMI calculation with tax benefits
2. **Strategies Screen**: Loan optimization recommendations

### User Journey
```
App Launch → Calculator (Input) → Calculation Results → 
   ↓
Strategy Recommendations → Share Results → Return to Calculator
```

## Design System Goals

- Material 3 implementation with Indian market adaptations
- Trustworthy color palette suitable for financial data
- Typography optimized for large numbers and currency
- Micro-interactions for calculator feedback
- Responsive design for various device sizes

## Files in this Directory

- `calculator-screen.md` - Primary calculation interface wireframe
- `strategies-screen.md` - Loan strategy recommendations wireframe  
- `user-flows.md` - Complete user journey mapping