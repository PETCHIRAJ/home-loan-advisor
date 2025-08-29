# Analytics Tracking Requirements
# Home Loan Advisor App

## Overview
This document defines what analytics data to track in the Home Loan Advisor app to improve user experience and guide development decisions.

## Implementation Approach
- **Silent tracking** - No user consent screens or toggles
- **Anonymous data only** - No personal information collected
- **Firebase Analytics** - Standard implementation
- **Offline-friendly** - Data synced when internet available

## Core Metrics to Track

### 1. App Usage Patterns
```dart
// App launches and sessions
FirebaseAnalytics.instance.logAppOpen();
FirebaseAnalytics.instance.logEvent(
  name: 'session_start',
  parameters: {
    'session_duration': durationInSeconds,
    'screens_viewed': screenCount,
  }
);
```

### 2. Calculator Usage
```dart
// Track which calculators are used most
FirebaseAnalytics.instance.logEvent(
  name: 'calculator_used',
  parameters: {
    'calculator_type': 'emi_basic', // emi_basic, prepayment, biweekly, etc.
    'loan_amount_range': '40-60L', // Ranges: 0-20L, 20-40L, 40-60L, 60L+
    'tenure_range': '15-25', // Ranges: 0-15, 15-25, 25+
    'interest_range': '7-9', // Ranges: 0-7, 7-9, 9-11, 11+
  }
);
```

### 3. Strategy Engagement  
```dart
// Track which saving strategies are popular
FirebaseAnalytics.instance.logEvent(
  name: 'strategy_viewed',
  parameters: {
    'strategy_name': 'biweekly_payment',
    'category': 'core_calculators', // core, eye_openers, comparisons, etc.
    'time_spent': durationInSeconds,
  }
);

// Track strategy activation/interest
FirebaseAnalytics.instance.logEvent(
  name: 'strategy_activated',
  parameters: {
    'strategy_name': 'extra_emi',
    'potential_savings': '2-5L', // Ranges: 0-2L, 2-5L, 5L+
  }
);
```

### 4. Screen Navigation
```dart
// Track user flows and popular paths
FirebaseAnalytics.instance.logScreenView(
  screenName: 'DashboardScreen',
  screenClass: 'DashboardScreen',
  parameters: {
    'previous_screen': 'CalculatorScreen',
    'time_on_screen': durationInSeconds,
  }
);
```

### 5. Feature Discovery
```dart
// Track which features users find and use
FirebaseAnalytics.instance.logEvent(
  name: 'feature_discovery',
  parameters: {
    'feature_name': 'daily_burn_counter',
    'discovery_method': 'dashboard_tap', // dashboard_tap, search, category_browse
    'first_time_user': true,
  }
);
```

### 6. Progress Tracking
```dart
// Track achievement and progress engagement
FirebaseAnalytics.instance.logEvent(
  name: 'progress_viewed',
  parameters: {
    'achievements_unlocked': 3,
    'active_strategies': 2,
    'time_in_app_days': 7, // 1, 7, 30, 90+ day ranges
  }
);
```

### 7. Search and Discovery
```dart
// Track search behavior in strategies
FirebaseAnalytics.instance.logEvent(
  name: 'strategy_search',
  parameters: {
    'search_term': 'prepayment', // anonymized popular terms
    'results_found': 4,
    'result_clicked': true,
  }
);
```

### 8. App Performance
```dart
// Track technical performance issues
FirebaseAnalytics.instance.logEvent(
  name: 'app_performance',
  parameters: {
    'screen_load_time': durationInMs,
    'calculation_time': durationInMs,
    'memory_usage': 'normal', // low, normal, high
  }
);
```

### 9. User Retention Patterns
```dart
// Track return visit patterns
FirebaseAnalytics.instance.logEvent(
  name: 'user_return',
  parameters: {
    'days_since_last_visit': 1, // 1, 2-7, 8-30, 30+
    'session_number': 5,
    'favorite_feature': 'calculator', // most used feature
  }
);
```

### 10. Conversion Events
```dart
// Track valuable user actions
FirebaseAnalytics.instance.logEvent(
  name: 'valuable_action',
  parameters: {
    'action_type': 'completed_calculation', // completed_calculation, explored_strategies, activated_strategy
    'user_segment': 'power_user', // new_user, regular_user, power_user
    'value_score': 85, // 0-100 engagement score
  }
);
```

## Data Ranges and Bucketing

### Loan Amount Ranges
- `0-20L`: ₹0 - ₹20,00,000
- `20-40L`: ₹20,00,001 - ₹40,00,000  
- `40-60L`: ₹40,00,001 - ₹60,00,000
- `60L+`: Above ₹60,00,000

### Interest Rate Ranges
- `below-7`: Below 7%
- `7-9`: 7% - 9%
- `9-11`: 9% - 11%
- `above-11`: Above 11%

### Tenure Ranges  
- `short-15`: 0-15 years
- `medium-25`: 15-25 years
- `long-25+`: Above 25 years

### User Segments
- `new_user`: 0-2 sessions
- `regular_user`: 3-10 sessions  
- `power_user`: 11+ sessions

## Privacy Protection

### What We DON'T Track
- ❌ Actual loan amounts (only ranges)
- ❌ Personal information
- ❌ Device identifiers
- ❌ Location data
- ❌ Contact information
- ❌ Bank names or personal details

### Data Retention
- **Analytics data**: 2 years maximum
- **Crash reports**: 90 days
- **Performance data**: 30 days

## Key Metrics Dashboard

### Primary KPIs
1. **Daily Active Users (DAU)**
2. **Calculator Completion Rate**
3. **Strategy Exploration Rate** (% who view strategies)  
4. **Feature Discovery Rate** (% who find key features)
5. **Session Duration Average**
6. **7-day User Retention**
7. **30-day User Retention**

### Feature Performance
1. **Most Used Calculators** (ranking)
2. **Most Popular Strategies** (ranking)  
3. **Screen Time Distribution**
4. **User Flow Patterns** (common paths)
5. **Search Success Rate**
6. **Achievement Unlock Rate**

### Technical Metrics
1. **App Crash Rate**
2. **Screen Load Times**
3. **Calculation Performance**
4. **Memory Usage Distribution**

## Implementation Notes

### Firebase Analytics Setup
```dart
// Initialize Firebase Analytics
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// Set user properties (anonymous segments only)
analytics.setUserProperty(
  name: 'user_segment',
  value: 'regular_user'
);

// Enable/disable based on user preference (default: enabled)
FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
```

### Event Naming Convention
- Use **snake_case** for event names
- Use **descriptive parameters** 
- Keep **event names consistent**
- Limit to **25 custom parameters** per event

### Testing Analytics
```dart
// Debug mode for development
FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(kDebugMode ? false : true);

// Test events in debug console
print('Analytics event: calculator_used');
```

## Success Metrics

### Month 1 Goals
- **500+ downloads**
- **70% calculator completion rate**  
- **40% strategy exploration rate**
- **3+ minute average session**

### Month 3 Goals  
- **2,000+ downloads**
- **60% 7-day retention**
- **25% 30-day retention**
- **5+ sessions per retained user**

This analytics implementation will provide actionable insights to improve the Home Loan Advisor app while maintaining user privacy and trust.