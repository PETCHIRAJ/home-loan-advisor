# Automated LLM Data Collection Prompt

## STRICT OUTPUT REQUIREMENTS

**IMPORTANT**: You MUST return data in EXACTLY this JSON format. Do not add, remove, or modify any field names or structure.

## Your Task

Collect current home loan market data for Indian banks and return it in the specified JSON format below. Use web search, official bank websites, and financial aggregators to gather the most recent information.

## EXACT JSON Template (DO NOT MODIFY STRUCTURE)

Return your response as valid JSON matching this exact structure:

```json
{
  "metadata": {
    "version": "1.0.0",
    "last_updated": "[CURRENT_ISO_TIMESTAMP]",
    "next_update": "[NEXT_DAY_MIDNIGHT_IST]",
    "data_provider": "Market Aggregation",
    "update_frequency": "daily",
    "data_completeness": [PERCENTAGE_AS_NUMBER]
  },
  
  "market_rates": {
    "repo_rate": {
      "current": [NUMBER],
      "previous": [NUMBER],
      "effective_date": "[YYYY-MM-DD]",
      "change_percentage": [NUMBER]
    },
    "average_home_loan_rate": [NUMBER],
    "rate_trend": "[stable|increasing|decreasing]",
    "rate_range": {
      "minimum": [NUMBER],
      "maximum": [NUMBER]
    }
  },
  
  "banks": [
    {
      "bank_id": "[UPPERCASE_SHORT_NAME]",
      "bank_name": "[FULL_NAME]",
      "bank_type": "[public|private|nbfc]",
      "market_share": [NUMBER],
      "last_updated": "[ISO_TIMESTAMP]",
      
      "interest_rates": {
        "salaried": {
          "excellent_credit": {
            "min_rate": [NUMBER],
            "max_rate": [NUMBER],
            "effective_rate": [NUMBER]
          },
          "good_credit": {
            "min_rate": [NUMBER],
            "max_rate": [NUMBER],
            "effective_rate": [NUMBER]
          },
          "average_credit": {
            "min_rate": [NUMBER],
            "max_rate": [NUMBER],
            "effective_rate": [NUMBER]
          }
        },
        "self_employed": {
          "excellent_credit": {
            "min_rate": [NUMBER],
            "max_rate": [NUMBER],
            "effective_rate": [NUMBER]
          },
          "good_credit": {
            "min_rate": [NUMBER],
            "max_rate": [NUMBER],
            "effective_rate": [NUMBER]
          },
          "average_credit": {
            "min_rate": [NUMBER],
            "max_rate": [NUMBER],
            "effective_rate": [NUMBER]
          }
        },
        "women_special": {
          "discount": [NUMBER_OR_NULL],
          "min_rate": [NUMBER_OR_NULL]
        }
      },
      
      "processing_fees": {
        "percentage": [NUMBER],
        "minimum": [NUMBER],
        "maximum": [NUMBER],
        "gst_applicable": [BOOLEAN],
        "gst_rate": [NUMBER]
      },
      
      "eligibility": {
        "min_age": [NUMBER],
        "max_age": [NUMBER],
        "min_income_salaried": [NUMBER],
        "min_income_self_employed": [NUMBER],
        "credit_score_minimum": [NUMBER]
      }
    }
  ],
  
  "tax_benefits": {
    "section_80c": {
      "max_deduction": 150000,
      "applicable_on": "principal_repayment",
      "conditions": [ARRAY_OF_STRINGS],
      "fy_2024_25": true,
      "tax_savings_by_bracket": {
        "5_percent": 7500,
        "10_percent": 15000,
        "20_percent": 30000,
        "30_percent": 45000
      }
    },
    "section_24b": {
      "max_deduction_self_occupied": 200000,
      "max_deduction_let_out": "no_limit",
      "applicable_on": "interest_payment",
      "conditions": [ARRAY_OF_STRINGS],
      "fy_2024_25": true,
      "pre_construction_interest": {
        "allowed": true,
        "claim_period": "5_years",
        "per_year_limit": 40000
      },
      "tax_savings_by_bracket": {
        "5_percent": 10000,
        "10_percent": 20000,
        "20_percent": 40000,
        "30_percent": 60000
      }
    }
  },
  
  "government_schemes": {
    "pmay": {
      "scheme_name": "Pradhan Mantri Awas Yojana",
      "subsidy_available": true,
      "ews_lig": {
        "category": "EWS/LIG",
        "max_subsidy": 267000,
        "income_limit_annual": 600000,
        "carpet_area_max_sqm": 60,
        "interest_subsidy_rate": 6.5,
        "max_loan_tenure": 20,
        "npv_calculation_rate": 9.0
      },
      "mig_1": {
        "category": "MIG-I",
        "max_subsidy": 235000,
        "income_limit_annual": 1200000,
        "carpet_area_max_sqm": 160,
        "interest_subsidy_rate": 4.0,
        "max_loan_amount": 900000,
        "max_loan_tenure": 20,
        "npv_calculation_rate": 9.0
      },
      "mig_2": {
        "category": "MIG-II",
        "max_subsidy": 230000,
        "income_limit_annual": 1800000,
        "carpet_area_max_sqm": 200,
        "interest_subsidy_rate": 3.0,
        "max_loan_amount": 1200000,
        "max_loan_tenure": 20,
        "npv_calculation_rate": 9.0
      },
      "valid_till": "[YYYY-MM-DD]",
      "application_process": "[STRING]",
      "documents_required": [ARRAY_OF_STRINGS]
    }
  },
  
  "stamp_duty_registration": {
    "[STATE_NAME]": {
      "stamp_duty": {
        "urban": [NUMBER],
        "rural": [NUMBER],
        "women_discount": [NUMBER]
      },
      "registration": [NUMBER],
      "max_registration": [NUMBER]
    }
  },
  
  "insurance_rates": {
    "property_insurance": {
      "rate_per_lakh_per_year": [NUMBER],
      "min_premium": [NUMBER],
      "coverage_type": "[STRING]"
    },
    "life_insurance": {
      "term_insurance_rate": {
        "age_25_35": [NUMBER],
        "age_36_45": [NUMBER],
        "age_46_55": [NUMBER],
        "age_56_65": [NUMBER]
      },
      "mandatory": [BOOLEAN]
    }
  },
  
  "market_trends": {
    "average_property_prices_per_sqft": {
      "[CITY_NAME]": [NUMBER]
    },
    "loan_statistics": {
      "average_loan_amount": [NUMBER],
      "average_tenure_years": [NUMBER],
      "average_ltv": [NUMBER],
      "prepayment_percentage": [NUMBER]
    }
  },
  
  "prepayment_strategies": {
    "extra_emi": {
      "average_savings_percentage": [NUMBER],
      "tenure_reduction_years": [NUMBER],
      "implementation_difficulty": "[easy|medium|hard]"
    },
    "step_up": {
      "average_savings_percentage": [NUMBER],
      "tenure_reduction_years": [NUMBER],
      "implementation_difficulty": "[easy|medium|hard]"
    },
    "lumpsum": {
      "average_savings_percentage": [NUMBER],
      "tenure_reduction_years": [NUMBER],
      "implementation_difficulty": "[easy|medium|hard]"
    },
    "round_up": {
      "average_savings_percentage": [NUMBER],
      "tenure_reduction_years": [NUMBER],
      "implementation_difficulty": "[easy|medium|hard]"
    }
  }
}
```

## Data Collection Requirements

### MUST HAVE (Minimum 15 banks):
1. SBI (State Bank of India)
2. HDFC Bank
3. ICICI Bank
4. Axis Bank
5. Kotak Mahindra Bank
6. Punjab National Bank (PNB)
7. Bank of Baroda (BOB)
8. Canara Bank
9. Union Bank of India
10. IDFC First Bank
11. Yes Bank
12. IndusInd Bank
13. LIC Housing Finance
14. Bajaj Housing Finance
15. Bank of India

### For Each Bank, Collect:
- Current interest rates (as of today)
- Different rates for credit scores: 750+ (excellent), 700-749 (good), 650-699 (average)
- Separate rates for salaried vs self-employed
- Women special discount if available (null if not)
- Processing fees (percentage and min/max amounts)
- Basic eligibility (age limits, minimum income, minimum credit score)

### Fixed Data (Use These Exact Values):
- Section 80C limit: 150000
- Section 24B limit: 200000
- PMAY EWS/LIG subsidy: 267000
- PMAY MIG-I subsidy: 235000
- PMAY MIG-II subsidy: 230000
- GST on processing fees: 18%

### Data Validation Rules:
- Interest rates must be between 6% and 15%
- Processing fees typically 0.35% to 1%
- Credit score minimum usually 650-700
- All numbers should be actual numbers, not strings
- Dates in YYYY-MM-DD format
- Timestamps in ISO 8601 format

## Response Instructions:
1. Return ONLY valid JSON (no markdown, no explanations)
2. Include data for EXACTLY 15 banks minimum
3. Use null for unavailable optional fields
4. Ensure all required fields are present
5. Use realistic current market rates (8.4% - 10.5% typical range)
6. Include current RBI repo rate (check latest)
7. Validate JSON syntax before returning

## Error Handling:
If you cannot find specific data:
- Use reasonable estimates based on bank category
- Mark data_completeness percentage accordingly
- Never leave required fields empty
- Use null only for optional fields like women_special

Return the complete JSON data now.