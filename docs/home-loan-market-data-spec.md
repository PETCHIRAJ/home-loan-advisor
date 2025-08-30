# Home Loan Market Data API Specification

## Overview
This document defines the structure and update requirements for `home-loan-market-data.json` - the server-side data source for the Home Loan Advisor app's calculator and strategies features.

## JSON Structure

```json
{
  "metadata": {
    "version": "1.0.0",
    "last_updated": "2024-01-15T10:30:00Z",
    "next_update": "2024-01-15T16:30:00Z",
    "data_provider": "RBI/Market Aggregator",
    "update_frequency": "6_hours"
  },
  
  "market_rates": {
    "repo_rate": {
      "current": 6.50,
      "previous": 6.25,
      "effective_date": "2024-01-15",
      "change_percentage": 0.25
    },
    "average_home_loan_rate": 8.65,
    "rate_trend": "increasing",
    "forecast_next_quarter": "stable"
  },
  
  "banks": [
    {
      "bank_id": "SBI",
      "bank_name": "State Bank of India",
      "bank_type": "public",
      "logo_url": "https://api.homeloanadvisor.in/logos/sbi.png",
      "market_share": 28.5,
      
      "interest_rates": {
        "salaried": {
          "excellent_credit": {
            "min_rate": 8.40,
            "max_rate": 8.90,
            "effective_rate": 8.50
          },
          "good_credit": {
            "min_rate": 8.65,
            "max_rate": 9.15,
            "effective_rate": 8.75
          },
          "average_credit": {
            "min_rate": 8.90,
            "max_rate": 9.40,
            "effective_rate": 9.00
          }
        },
        "self_employed": {
          "excellent_credit": {
            "min_rate": 8.65,
            "max_rate": 9.15,
            "effective_rate": 8.75
          },
          "good_credit": {
            "min_rate": 8.90,
            "max_rate": 9.40,
            "effective_rate": 9.00
          },
          "average_credit": {
            "min_rate": 9.15,
            "max_rate": 9.65,
            "effective_rate": 9.25
          }
        },
        "women_special": {
          "discount": 0.05,
          "min_rate": 8.35,
          "conditions": "Primary applicant must be woman"
        }
      },
      
      "loan_features": {
        "max_ltv_ratio": 90,
        "max_tenure_years": 30,
        "min_loan_amount": 500000,
        "max_loan_amount": 50000000,
        "prepayment_allowed": true,
        "prepayment_charges": 0,
        "part_prepayment_minimum": 25000,
        "balance_transfer_allowed": true,
        "top_up_available": true,
        "floating_rate_available": true,
        "fixed_rate_available": true,
        "hybrid_rate_available": true
      },
      
      "processing_fees": {
        "percentage": 0.50,
        "minimum": 10000,
        "maximum": 50000,
        "gst_applicable": true,
        "gst_rate": 18,
        "negotiable": true,
        "waiver_offers": ["Government employees", "Defence personnel"]
      },
      
      "eligibility_criteria": {
        "min_age": 21,
        "max_age": 65,
        "min_income_salaried": 25000,
        "min_income_self_employed": 40000,
        "min_work_experience": 2,
        "min_business_vintage": 3,
        "credit_score_minimum": 650,
        "credit_score_preferred": 750
      },
      
      "special_offers": [
        {
          "offer_name": "Festival Special",
          "offer_type": "processing_fee_waiver",
          "discount_value": 100,
          "valid_till": "2024-01-31",
          "conditions": "Application before Jan 31"
        }
      ],
      
      "turnaround_time": {
        "pre_approval": "instant",
        "sanction_letter": "3_days",
        "disbursement": "7_days"
      },
      
      "customer_rating": 4.2,
      "total_reviews": 12543
    },
    {
      "bank_id": "HDFC",
      "bank_name": "HDFC Bank",
      "bank_type": "private",
      "market_share": 22.3
      // ... similar structure
    },
    {
      "bank_id": "ICICI",
      "bank_name": "ICICI Bank",
      "bank_type": "private",
      "market_share": 15.8
      // ... similar structure
    },
    {
      "bank_id": "AXIS",
      "bank_name": "Axis Bank",
      "bank_type": "private",
      "market_share": 10.2
      // ... similar structure
    },
    {
      "bank_id": "KOTAK",
      "bank_name": "Kotak Mahindra Bank",
      "bank_type": "private",
      "market_share": 6.5
      // ... similar structure
    },
    {
      "bank_id": "PNB",
      "bank_name": "Punjab National Bank",
      "bank_type": "public",
      "market_share": 5.8
      // ... similar structure
    },
    {
      "bank_id": "BOB",
      "bank_name": "Bank of Baroda",
      "bank_type": "public",
      "market_share": 4.2
      // ... similar structure
    },
    {
      "bank_id": "IDFC",
      "bank_name": "IDFC First Bank",
      "bank_type": "private",
      "market_share": 2.1
      // ... similar structure
    },
    {
      "bank_id": "LIC",
      "bank_name": "LIC Housing Finance",
      "bank_type": "nbfc",
      "market_share": 8.7
      // ... similar structure
    },
    {
      "bank_id": "BAJAJ",
      "bank_name": "Bajaj Housing Finance",
      "bank_type": "nbfc",
      "market_share": 3.4
      // ... similar structure
    }
  ],
  
  "tax_benefits": {
    "section_80c": {
      "max_deduction": 150000,
      "applicable_on": "principal_repayment",
      "conditions": ["Self-occupied property", "Within overall 80C limit"],
      "fy_2024_25": true
    },
    "section_24b": {
      "max_deduction_self_occupied": 200000,
      "max_deduction_let_out": "no_limit",
      "applicable_on": "interest_payment",
      "conditions": ["Property construction completed", "Possession taken"],
      "fy_2024_25": true
    },
    "section_80ee": {
      "max_deduction": 50000,
      "applicable_on": "interest_payment",
      "conditions": [
        "First time home buyer",
        "Loan amount < 35 lakhs",
        "Property value < 50 lakhs",
        "Loan sanctioned between Apr 2016 - Mar 2022"
      ],
      "active": false
    },
    "section_80eea": {
      "max_deduction": 150000,
      "applicable_on": "interest_payment",
      "conditions": [
        "First time home buyer",
        "Loan sanctioned between Apr 2019 - Mar 2022",
        "Not claimed 80EE"
      ],
      "active": false
    },
    "stamp_duty_deduction": {
      "available_under": "section_80c",
      "within_limit": true
    }
  },
  
  "government_schemes": {
    "pmay": {
      "scheme_name": "Pradhan Mantri Awas Yojana",
      "subsidy_available": true,
      "ews_lig": {
        "max_subsidy": 267000,
        "income_limit": 600000,
        "carpet_area_max": 60,
        "interest_subsidy_rate": 6.5
      },
      "mig_1": {
        "max_subsidy": 235000,
        "income_limit": 1200000,
        "carpet_area_max": 160,
        "interest_subsidy_rate": 4.0
      },
      "mig_2": {
        "max_subsidy": 230000,
        "income_limit": 1800000,
        "carpet_area_max": 200,
        "interest_subsidy_rate": 3.0
      },
      "valid_till": "2024-12-31"
    }
  },
  
  "insurance_rates": {
    "property_insurance": {
      "rate_per_lakh": 35,
      "min_premium": 2500,
      "coverage_type": "structure_only"
    },
    "life_insurance": {
      "term_insurance_rate": {
        "age_25_35": 0.08,
        "age_36_45": 0.12,
        "age_46_55": 0.18,
        "age_56_65": 0.25
      },
      "mandatory": false,
      "bank_tie_ups": ["SBI Life", "HDFC Life", "ICICI Prudential"]
    }
  },
  
  "legal_and_technical_charges": {
    "stamp_duty": {
      "maharashtra": 5.0,
      "karnataka": 5.0,
      "delhi": 6.0,
      "tamil_nadu": 7.0,
      "gujarat": 4.9,
      "default": 5.0
    },
    "registration_charges": {
      "maharashtra": 1.0,
      "karnataka": 1.0,
      "delhi": 1.0,
      "tamil_nadu": 1.0,
      "gujarat": 1.0,
      "default": 1.0
    },
    "legal_fees_range": {
      "min": 10000,
      "max": 50000,
      "average": 25000
    },
    "technical_evaluation": {
      "min": 3500,
      "max": 15000,
      "average": 7500
    }
  },
  
  "market_trends": {
    "average_property_prices": {
      "metro_cities": {
        "mumbai": 15500,
        "delhi_ncr": 8500,
        "bangalore": 7200,
        "chennai": 5800,
        "pune": 6500,
        "hyderabad": 6200
      },
      "tier_2_cities": {
        "average_per_sqft": 4200
      }
    },
    "loan_growth_rate": 12.5,
    "default_rate": 0.9,
    "average_loan_ticket": 4200000,
    "average_ltv": 75
  },
  
  "calculator_defaults": {
    "suggested_amounts": [2500000, 5000000, 7500000, 10000000],
    "popular_tenures": [10, 15, 20, 25, 30],
    "optimal_ltv": 80,
    "emergency_fund_months": 6,
    "investment_return_assumption": 12.0,
    "inflation_rate": 6.0,
    "property_appreciation_rate": 5.0
  },
  
  "prepayment_strategies": {
    "extra_emi": {
      "frequency": "yearly",
      "average_savings_percentage": 28,
      "tenure_reduction_years": 5
    },
    "step_up": {
      "annual_increase": 5,
      "average_savings_percentage": 35,
      "tenure_reduction_years": 7
    },
    "lumpsum": {
      "optimal_timing": "year_3_to_5",
      "average_savings_percentage": 22,
      "impact_factor": 1.8
    }
  }
}
```

## Update Frequency Requirements

### Real-Time Updates (Every 15 minutes)
- During market hours (9 AM - 5 PM IST)
- Only for rate ticker display
- Minimal data: current rates from top 5 banks

### High Frequency Updates (Every 6 hours)
- Bank interest rates
- Processing fees
- Special offers
- Eligibility criteria changes

### Daily Updates (Once at 12:01 AM IST)
- Government scheme changes
- Tax benefit updates
- Market trends
- Average property prices
- Insurance rates

### Weekly Updates (Every Monday)
- Customer ratings and reviews
- Bank market share data
- Loan growth statistics
- Default rates

### Monthly Updates (1st of each month)
- Legal and technical charges
- Stamp duty rates
- Registration charges
- Calculator defaults
- Prepayment strategy statistics

### Quarterly Updates
- Property appreciation rates
- Inflation adjustments
- Investment return assumptions
- Long-term market forecasts

## Data Sources

### Primary Sources
1. **RBI** - Repo rates, banking regulations
2. **Individual Banks** - Direct API integration for rates
3. **Government Portals** - PMAY, tax regulations
4. **Property Portals** - Average property prices
5. **Insurance Regulators** - IRDAI for insurance rates

### Secondary Sources
1. **Financial aggregators** - BankBazaar, PolicyBazaar
2. **Credit bureaus** - CIBIL for credit score ranges
3. **Market research** - Industry reports
4. **User feedback** - Ratings and reviews

## Implementation Notes

### Caching Strategy
```
- Full data: Cache for 6 hours
- Rate ticker: Cache for 15 minutes
- User-specific: Cache for session duration
- Offline mode: Store last 7 days of data
```

### API Endpoints
```
GET /api/v1/market-data/full
GET /api/v1/market-data/rates-ticker
GET /api/v1/market-data/bank/{bank_id}
GET /api/v1/market-data/tax-benefits
GET /api/v1/market-data/calculator-defaults
```

### Data Validation
- Schema validation on each update
- Rate sanity checks (3% < rate < 15%)
- Timestamp verification
- Checksum for data integrity

### Fallback Mechanism
1. Primary: Live API
2. Secondary: Cached data (< 24 hours old)
3. Tertiary: Static defaults in app
4. Show clear indication when using non-live data

## Security Considerations

1. **API Authentication**: OAuth 2.0 with refresh tokens
2. **Data Encryption**: TLS 1.3 for transport
3. **Rate Limiting**: 100 requests/minute per user
4. **Data Anonymization**: No PII in market data
5. **Audit Logging**: Track all data updates

## Size Optimization

### Full Dataset: ~150KB (minified JSON)
### Ticker Update: ~2KB
### Individual Bank: ~15KB
### Offline Bundle: ~500KB (7 days of data)

## Versioning Strategy

- Semantic versioning (major.minor.patch)
- Backward compatibility for 3 versions
- Deprecation notice 30 days in advance
- Version check on app startup

## Error Handling

```json
{
  "error": {
    "code": "RATE_UNAVAILABLE",
    "message": "Current rates temporarily unavailable",
    "fallback_data": true,
    "last_updated": "2024-01-15T10:30:00Z",
    "retry_after": 300
  }
}
```

## Monitoring & Analytics

### Key Metrics to Track
1. API response time (target < 200ms)
2. Data freshness (% requests with live data)
3. Cache hit ratio (target > 80%)
4. Error rate (target < 0.1%)
5. Update success rate (target > 99.9%)

### Alerts
- Rate change > 0.5% in single update
- API response time > 500ms
- Update failure for > 1 hour
- Data anomaly detection

---

**Note**: This specification enables the app to claim "most comprehensive EMI calculator" with real-time market intelligence, multi-bank comparison, and total cost transparency - the key differentiators identified in competitive analysis.