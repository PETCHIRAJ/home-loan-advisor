# External Data Requirements for Home Loan Advisor

## Overview
This document outlines all external data sources needed for the Home Loan Advisor app to function as a complete EMI calculator with money-saving strategies.

---

## 1. Essential External Data (MVP - Phase 1)

### 1.1 Current Interest Rates
**Purpose**: Show real-time bank rates for comparison

**Data Needed**:
```json
{
  "bank_rates": [
    {
      "bank_name": "SBI",
      "home_loan_rate": 8.5,
      "floating_rate": 8.3,
      "fixed_rate": 9.1,
      "last_updated": "2024-12-01",
      "processing_fee": 0.35,
      "prepayment_charges": 0
    }
  ]
}
```

**Sources**:
- RBI Database API (if available)
- Bank websites (web scraping)
- Financial aggregator APIs (BankBazaar, MyLoanCare)
- Manual updates (fallback)

**Update Frequency**: Daily

### 1.2 RBI Repo Rate History
**Purpose**: Show rate trends and predict future changes

**Data Needed**:
```json
{
  "repo_rates": [
    {
      "date": "2024-12-01",
      "repo_rate": 6.5,
      "reverse_repo": 3.35,
      "bank_rate": 6.75
    }
  ]
}
```

**Sources**:
- RBI official website API
- Financial data providers (Refinitiv, Bloomberg)
- Government data portals

**Update Frequency**: After each RBI policy meeting

### 1.3 Tax Slab Information
**Purpose**: Calculate tax benefits accurately

**Data Needed**:
```json
{
  "tax_slabs_2024": {
    "old_regime": [
      {"min": 0, "max": 250000, "rate": 0},
      {"min": 250001, "max": 500000, "rate": 5},
      {"min": 500001, "max": 1000000, "rate": 20},
      {"min": 1000001, "max": null, "rate": 30}
    ],
    "new_regime": [
      {"min": 0, "max": 300000, "rate": 0},
      {"min": 300001, "max": 600000, "rate": 5},
      {"min": 600001, "max": 900000, "rate": 10}
    ],
    "deductions": {
      "section_80C": 150000,
      "section_24b": 200000,
      "section_80EE": 50000
    }
  }
}
```

**Sources**:
- Income Tax Department API
- Government budget documents
- Tax consultancy firms

**Update Frequency**: Annual (after budget)

---

## 2. Enhanced Data (Phase 2)

### 2.1 Property Price Index
**Purpose**: Show property appreciation for refinancing decisions

**Data Needed**:
```json
{
  "city_wise_index": {
    "mumbai": {
      "current_index": 285,
      "yoy_change": 3.5,
      "avg_price_sqft": 15000
    }
  }
}
```

**Sources**:
- CREDAI Property Index
- MagicBricks/99acres Research
- NHB RESIDEX

**Update Frequency**: Quarterly

### 2.2 Credit Score Ranges
**Purpose**: Estimate loan eligibility and rates

**Data Needed**:
```json
{
  "credit_score_impact": [
    {
      "score_range": "750+",
      "rate_discount": 0.25,
      "approval_probability": 95
    },
    {
      "score_range": "700-750",
      "rate_discount": 0,
      "approval_probability": 80
    }
  ]
}
```

**Sources**:
- CIBIL/Experian guidelines
- Bank lending criteria
- Financial institution surveys

**Update Frequency**: Quarterly

### 2.3 Inflation Data
**Purpose**: Project future costs and savings value

**Data Needed**:
```json
{
  "inflation_rates": {
    "current_cpi": 5.4,
    "current_wpi": 4.2,
    "forecast_next_year": 5.0
  }
}
```

**Sources**:
- Ministry of Statistics API
- RBI inflation reports
- Economic surveys

**Update Frequency**: Monthly

---

## 3. Comparative Data (Phase 3)

### 3.1 Bank-Specific Features
**Purpose**: Detailed comparison of loan products

**Data Needed**:
```json
{
  "bank_features": {
    "SBI": {
      "max_tenure": 30,
      "max_loan_amount": 50000000,
      "min_income_required": 25000,
      "part_payment_allowed": true,
      "online_account": true,
      "overdraft_facility": "MaxGain",
      "insurance_mandatory": false
    }
  }
}
```

**Sources**:
- Bank product brochures
- Direct bank APIs
- Customer care verification

**Update Frequency**: Monthly

### 3.2 Processing Fee & Charges
**Purpose**: True cost calculation

**Data Needed**:
```json
{
  "additional_charges": {
    "processing_fee": {
      "min": 2500,
      "max": 10000,
      "percentage": 0.5
    },
    "legal_charges": 5000,
    "valuation_charges": 3500,
    "documentation": 2000
  }
}
```

**Sources**:
- Bank fee schedules
- Legal firm databases
- Property valuation companies

**Update Frequency**: Quarterly

### 3.3 Government Schemes
**Purpose**: Show subsidy benefits

**Data Needed**:
```json
{
  "pmay_scheme": {
    "subsidy_amount": {
      "lig": 600000,
      "mig_1": 900000,
      "mig_2": 1200000
    },
    "income_criteria": {
      "lig": {"min": 0, "max": 600000},
      "mig_1": {"min": 600001, "max": 1200000}
    },
    "interest_subsidy": 6.5
  }
}
```

**Sources**:
- PMAY official website
- NHB circulars
- Government notifications

**Update Frequency**: As announced

---

## 4. Market Intelligence Data

### 4.1 Competitor Rates
**Purpose**: Show competitive positioning

**Data Needed**:
```json
{
  "nbfc_rates": {
    "Bajaj_Housing": 8.85,
    "HDFC_Ltd": 8.75,
    "LIC_Housing": 8.90
  }
}
```

**Sources**:
- NBFC websites
- Industry reports
- Rate comparison platforms

**Update Frequency**: Weekly

### 4.2 User Behavior Analytics
**Purpose**: Personalized recommendations

**Data Needed**:
```json
{
  "user_patterns": {
    "avg_loan_amount": 4500000,
    "popular_tenure": 20,
    "prepayment_percentage": 35,
    "refinance_trigger_rate_diff": 0.5
  }
}
```

**Sources**:
- App analytics (internal)
- Industry surveys
- Banking reports

**Update Frequency**: Monthly

---

## 5. Educational Content Data

### 5.1 Financial Literacy Content
**Purpose**: User education

**Data Needed**:
- EMI calculation formulas
- Loan terminology glossary
- Tax saving tips
- Prepayment strategies
- Case studies

**Sources**:
- Financial advisors
- Banking experts
- Tax consultants
- Content partnerships

**Update Frequency**: Monthly

### 5.2 Success Stories
**Purpose**: Build trust and engagement

**Data Needed**:
- User testimonials
- Savings achieved
- Strategy adoption rates
- Before/after scenarios

**Sources**:
- User submissions
- App reviews
- Social media
- Surveys

**Update Frequency**: Weekly

---

## 6. Technical Integration Data

### 6.1 API Rate Limits
**Purpose**: Manage external API usage

| API Provider | Free Tier | Rate Limit | Cost |
|-------------|-----------|------------|------|
| RBI Data | Yes | 1000/day | Free |
| Bank APIs | Limited | 100/hour | ₹5000/month |
| Tax Data | Yes | 500/day | Free |
| Property Index | No | - | ₹10000/month |

### 6.2 Fallback Data Sources
**Purpose**: Ensure app functionality when APIs fail

1. **Static JSON files**: Last known good data
2. **Manual updates**: Critical rate changes
3. **Cached responses**: 7-day validity
4. **User-reported**: Crowd-sourced updates

---

## 7. Data Storage Requirements

### 7.1 Local Storage (On Device)
```
- User's loan details (encrypted)
- Calculation history
- Saved scenarios
- Strategy progress
- Cached rate data (1 week)
```

### 7.2 Remote Storage (Optional Cloud Backup)
```
- Anonymous usage analytics
- Aggregated savings data
- Performance metrics
- Error logs
```

---

## 8. Data Privacy & Compliance

### 8.1 No Personal Data Collection
- No user registration required
- No phone/email mandatory
- No Aadhaar/PAN storage
- No location tracking

### 8.2 Optional Data Sharing
- Opt-in analytics
- Voluntary testimonials
- Optional cloud backup
- Shareable calculations

### 8.3 Compliance Requirements
- RBI guidelines adherence
- Income Tax Act compliance
- Consumer protection laws
- Data localization norms

---

## 9. Implementation Priority

### Phase 1 (MVP - Must Have)
1. **Current bank rates** (top 10 banks)
2. **Basic tax slabs** (current year)
3. **RBI repo rate** (current only)
4. **Static educational content**

### Phase 2 (Enhancement - Should Have)
1. **Historical rate data**
2. **All bank rates** (50+ banks)
3. **Property indices**
4. **Government schemes**

### Phase 3 (Growth - Nice to Have)
1. **Credit score integration**
2. **Real-time rate updates**
3. **Personalized insights**
4. **Market predictions**

---

## 10. Data Acquisition Strategy

### 10.1 Free Sources (Start Here)
- RBI website scraping
- Government portals
- Bank websites
- Public APIs

### 10.2 Partnership Opportunities
- BankBazaar API partnership
- MyLoanCare data exchange
- CIBIL educational partnership
- Bank referral programs

### 10.3 Paid Sources (When Scaling)
- Professional data feeds
- Real-time rate APIs
- Premium analytics
- Custom research reports

---

## 11. Offline Functionality

### Critical Offline Features
✅ EMI calculation
✅ Prepayment scenarios
✅ Tax benefit calculation
✅ Strategy recommendations
✅ Saved calculations
✅ Educational content

### Online-Only Features
- Live rate comparison
- Rate alerts
- Market updates
- New government schemes
- Community features

---

## 12. Summary

### Minimum External Data for Launch:
1. **10 major bank rates** (manual update acceptable)
2. **Current tax slabs** (static JSON)
3. **RBI repo rate** (quarterly update)
4. **5 strategy templates** (static content)

### Total External Data Size:
- Initial download: ~500KB
- Weekly updates: ~50KB
- Monthly full refresh: ~2MB

### Estimated Data Costs:
- Phase 1: ₹0 (free sources)
- Phase 2: ₹5,000/month
- Phase 3: ₹20,000/month

This approach ensures the app can launch quickly with minimal external dependencies while building towards comprehensive data integration as the user base grows.