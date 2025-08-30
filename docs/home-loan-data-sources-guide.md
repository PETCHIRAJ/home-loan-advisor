# Home Loan Market Data Sources & Collection Guide

## Executive Summary

This document provides comprehensive guidance for collecting and maintaining home loan market data for India's most comprehensive EMI calculator. It includes data sources, collection strategies, sample JSON format, and implementation guidelines.

---

## Table of Contents

1. [Data Categories & Sources](#data-categories--sources)
2. [Primary Data Sources](#primary-data-sources)
3. [Secondary Data Sources](#secondary-data-sources)
4. [Update Frequency Matrix](#update-frequency-matrix)
5. [Sample JSON Structure](#sample-json-structure)
6. [Data Collection Prompt](#data-collection-prompt)
7. [Implementation Guidelines](#implementation-guidelines)
8. [Quality Assurance](#quality-assurance)

---

## Data Categories & Sources

### 1. Interest Rates & Bank Information

| Data Point | Primary Source | Secondary Source | Alternative Source | Update Frequency |
|------------|---------------|------------------|-------------------|------------------|
| **Base Interest Rates** | Bank websites/APIs | RBI Database | BankBazaar API | 6 hours |
| **Credit Score Based Rates** | Bank rate cards | CIBIL partnerships | Manual verification | Daily |
| **Special Offers** | Bank promotions page | Email newsletters | Partner notifications | Daily |
| **Processing Fees** | Bank fee schedule | Product brochures | Customer care | Weekly |
| **Eligibility Criteria** | Bank eligibility tools | API documentation | Manual testing | Weekly |
| **Customer Ratings** | Google Reviews | Bank's app ratings | Social media | Monthly |

**Primary Sources:**
- **SBI**: https://sbi.co.in/web/interest-rates/interest-rates/loan-schemes/home-loans
- **HDFC**: https://www.hdfc.com/home-loan-interest-rate
- **ICICI**: https://www.icicibank.com/personal-banking/loans/home-loan/interest-rate
- **Axis**: https://www.axisbank.com/retail/loans/home-loan/interest-rates-and-charges
- **Kotak**: https://www.kotak.com/en/personal-banking/loans/home-loan/interest-rates.html

### 2. Government & Regulatory Data

| Data Point | Primary Source | Secondary Source | Alternative Source | Update Frequency |
|------------|---------------|------------------|-------------------|------------------|
| **Repo Rate** | RBI Website | RBI API | Financial news | Real-time |
| **PMAY Subsidy** | PMAY Official | NHB Portal | Partner banks | Monthly |
| **Tax Benefits** | Income Tax Portal | CA associations | Tax consultants | Quarterly |
| **Stamp Duty** | State registrar | IGR websites | Legal firms | Quarterly |

**Primary Sources:**
- **RBI Rates**: https://www.rbi.org.in/Scripts/BS_ViewMonetaryPolicyReport.aspx
- **PMAY Portal**: https://pmaymis.gov.in/
- **Income Tax**: https://www.incometax.gov.in/
- **Maharashtra Stamp Duty**: https://igrmaharashtra.gov.in/

### 3. Market Intelligence

| Data Point | Primary Source | Secondary Source | Alternative Source | Update Frequency |
|------------|---------------|------------------|-------------------|------------------|
| **Property Prices** | 99acres/MagicBricks | PropTiger | Local brokers | Weekly |
| **Market Trends** | CREDAI Reports | Knight Frank | JLL Research | Monthly |
| **Loan Statistics** | IBA Reports | Credit bureaus | Bank reports | Quarterly |
| **Demographics** | Census Data | NCAER | Survey firms | Yearly |

**Primary Sources:**
- **99acres API**: https://www.99acres.com/api/v1/
- **MagicBricks**: https://www.magicbricks.com/
- **CREDAI**: https://credai.org/reports/
- **IBA**: https://www.iba.org.in/

### 4. Insurance & Additional Costs

| Data Point | Primary Source | Secondary Source | Alternative Source | Update Frequency |
|------------|---------------|------------------|-------------------|------------------|
| **Life Insurance** | IRDAI Portal | Insurance companies | Aggregators | Monthly |
| **Property Insurance** | General insurers | PolicyBazaar | Direct APIs | Monthly |
| **Legal Fees** | Bar associations | Legal firms | Market surveys | Quarterly |
| **Technical Charges** | Valuation firms | Bank panels | Industry average | Quarterly |

**Primary Sources:**
- **IRDAI**: https://www.irdai.gov.in/
- **LIC**: https://licindia.in/
- **HDFC ERGO**: https://www.hdfcergo.com/

---

## Primary Data Sources

### Tier 1: Direct Bank APIs (Where Available)

```javascript
// Example API endpoints structure
const bankAPIs = {
  "HDFC": {
    "endpoint": "https://api.hdfc.com/v2/home-loan/rates",
    "auth": "OAuth2.0",
    "rateLimit": "100/hour",
    "dataPoints": ["rates", "fees", "eligibility"]
  },
  "ICICI": {
    "endpoint": "https://api.icicibank.com/loans/home/current-rates",
    "auth": "API_KEY",
    "rateLimit": "500/hour",
    "dataPoints": ["rates", "offers", "calculator"]
  }
}
```

### Tier 2: Web Scraping Targets

```python
# Scraping configuration
SCRAPING_TARGETS = {
    "SBI": {
        "url": "https://sbi.co.in/web/interest-rates/",
        "selectors": {
            "rate": ".rate-table tbody tr",
            "processing_fee": ".fee-structure",
            "eligibility": ".eligibility-criteria"
        },
        "frequency": "6_hours"
    }
}
```

### Tier 3: Manual Data Collection

- Quarterly surveys via mystery shopping
- Phone verification of rates
- Branch visit validations
- Customer feedback integration

---

## Secondary Data Sources

### Financial Aggregators

| Platform | Data Available | API Access | Cost | Reliability |
|----------|---------------|------------|------|-------------|
| **BankBazaar** | Rates, eligibility, calculators | Yes (Partner) | Paid | High |
| **PolicyBazaar** | Insurance rates | Limited | Free tier | Medium |
| **Paisabazaar** | Credit scores, rates | Yes | Paid | High |
| **MyLoanCare** | Comprehensive | No | Scraping | Medium |

### Government Databases

| Database | Data Available | Access Method | Update Freq | Reliability |
|----------|---------------|---------------|-------------|-------------|
| **RBI DBIE** | Policy rates, statistics | API/CSV | Daily | Very High |
| **PMAY MIS** | Subsidy data | Portal | Monthly | High |
| **State IGR** | Stamp duty, registration | Web | Quarterly | High |
| **Census** | Demographics | Download | Decennial | High |

---

## Update Frequency Matrix

| Data Category | Real-time | 6-Hour | Daily | Weekly | Monthly | Quarterly |
|---------------|-----------|---------|--------|---------|----------|-----------|
| **Repo Rate** | ✅ | | | | | |
| **Bank Rates** | | ✅ | | | | |
| **Special Offers** | | | ✅ | | | |
| **Eligibility** | | | | ✅ | | |
| **Market Prices** | | | | ✅ | | |
| **Insurance** | | | | | ✅ | |
| **Tax Rules** | | | | | | ✅ |
| **Demographics** | | | | | | ✅ |

---

## Sample JSON Structure

See [sample-home-loan-market-data.json](./sample-home-loan-market-data.json) for complete structure.

### Key Structure Highlights:

```json
{
  "metadata": {
    "version": "1.0.0",
    "last_updated": "ISO_8601_TIMESTAMP",
    "data_quality_score": 98.5
  },
  "banks": [
    {
      "bank_id": "UNIQUE_ID",
      "interest_rates": {
        "salaried": {},
        "self_employed": {}
      },
      "processing_fees": {},
      "eligibility_criteria": {}
    }
  ],
  "tax_benefits": {},
  "government_schemes": {},
  "market_trends": {}
}
```

---

## Data Collection Prompt

### For Automated Systems

```
OBJECTIVE: Collect comprehensive home loan market data for Indian banks

REQUIREMENTS:
1. Collect data for 50+ banks/NBFCs
2. Update every 6 hours for rates
3. Validate against multiple sources
4. Maintain 99.5% accuracy

DATA POINTS:
- Interest rates by credit score (650-850)
- Processing fees (percentage + caps)
- Eligibility (age, income, experience)
- Special offers (time-bound)
- Tax benefits (80C, 24B)
- Government schemes (PMAY)

OUTPUT FORMAT: JSON as per schema v1.0.0
VALIDATION: Cross-verify with 3 sources
ERROR HANDLING: Fallback to cached data
```

### For Manual Researchers

```
TASK: Verify and update home loan data

STEPS:
1. Visit bank website
2. Navigate to home loan section
3. Record current rates
4. Check special offers
5. Verify processing fees
6. Test eligibility calculator
7. Note last update time

VALIDATION:
- Call customer care for verification
- Compare with previous data
- Flag anomalies > 0.5%
```

---

## Implementation Guidelines

### Phase 1: Core Data Setup (Week 1-2)
1. Set up scraping infrastructure
2. Implement top 10 banks
3. Create validation pipeline
4. Test data accuracy

### Phase 2: Scale & Automate (Week 3-4)
1. Add remaining banks
2. Implement real-time updates
3. Set up monitoring
4. Create fallback systems

### Phase 3: Intelligence Layer (Week 5-6)
1. Add predictive analytics
2. Implement trend analysis
3. Create recommendation engine
4. Set up alerts system

### Technical Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Data Sources  │────▶│   Collection    │────▶│    Validation   │
│  (Banks, RBI)   │     │   (Scrapers)    │     │   (QA Rules)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                          │
                                                          ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Mobile App    │◀────│   API Gateway   │◀────│   Data Store    │
│   (Flutter)     │     │   (CDN Cache)   │     │   (Database)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## Quality Assurance

### Data Validation Rules

| Validation Type | Rule | Action on Failure |
|----------------|------|-------------------|
| **Rate Range** | 3% < rate < 15% | Flag for review |
| **Cross-Source** | Difference < 0.1% | Use average |
| **Temporal** | Change < 2% daily | Investigate |
| **Completeness** | All fields present | Use previous |
| **Format** | JSON schema valid | Reject update |

### Accuracy Metrics

- **Target Accuracy**: 99.5%
- **Acceptable Delay**: < 6 hours
- **Validation Sources**: Minimum 3
- **Manual Verification**: Monthly
- **User Feedback Loop**: Continuous

### Monitoring Dashboard

```
Key Metrics:
├── Data Freshness: % updated < 6 hours
├── Accuracy Score: Validation pass rate
├── Coverage: Banks with complete data
├── API Health: Response times
└── User Trust: Feedback score
```

---

## ROI & Business Impact

### Why This Data Matters

| Data Point | User Benefit | Business Impact |
|------------|--------------|-----------------|
| **Real-time Rates** | Save ₹2-5 lakhs via best rates | 40% higher conversions |
| **Eligibility Check** | 80% approval certainty | 3x user engagement |
| **Tax Calculator** | ₹50-100k additional savings | Premium feature opportunity |
| **Total Cost View** | Complete transparency | Market differentiation |
| **Smart Strategies** | ₹10-15 lakh lifetime savings | User retention |

### Competitive Advantage

- **50+ data points** vs competitors' 10-15
- **6-hour updates** vs daily/weekly
- **Multi-bank comparison** vs single bank
- **Personalized rates** vs generic
- **Complete transparency** vs hidden fees

---

## Compliance & Legal

### Data Usage Guidelines

1. **RBI Compliance**: Follow all regulatory guidelines
2. **Privacy Laws**: No PII storage without consent
3. **Rate Accuracy**: Disclaimer for time-sensitive data
4. **Partner Agreements**: Respect API terms of service
5. **User Consent**: Clear data usage policies

### Disclaimers Required

```
"Interest rates are indicative and subject to change. 
Please verify with respective banks before making decisions. 
Last updated: [TIMESTAMP]"
```

---

## Appendix

### API Rate Limits

| Source | Free Tier | Paid Tier | Enterprise |
|--------|-----------|-----------|------------|
| RBI | 1000/day | N/A | N/A |
| BankBazaar | None | 10000/day | Unlimited |
| 99acres | 100/day | 5000/day | Custom |
| MagicBricks | 500/day | 10000/day | Custom |

### Data Storage Estimates

- **Full Dataset**: 150KB (compressed)
- **Daily Updates**: 2MB
- **Monthly Storage**: 60MB
- **Yearly with History**: 720MB

### Support Contacts

- **RBI Data**: dbie@rbi.org.in
- **PMAY**: support@pmay.gov.in
- **Technical Issues**: Create GitHub issue
- **Data Partnerships**: partnerships@homeloanadvisor.in

---

**Last Updated**: January 2024
**Version**: 1.0.0
**Maintained By**: Home Loan Advisor Data Team