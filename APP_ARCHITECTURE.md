# Home Loan Advisor - App Architecture

## 🏗️ Core Architecture

### Single Source of Truth Pattern
```
Calculator Tab (Control Center)
        ↓
    Stores all user inputs
    (Loan details + Personal info)
        ↓
    All screens reactively compute
    from these values
        ↓
    Change once = Update everywhere
```

## 📱 Navigation Structure

### 4-Tab Bottom Navigation
```
[🏠 Home] [💰 Strategies] [📈 Progress] [📊 Calculator]
```

- **Home (Dashboard)**: Daily interest loss, loan health, quick insights
- **Strategies**: 20 Indian-specific money-saving strategies
- **Progress**: Loan journey tracking (dual mode: Planning/Taken)
- **Calculator**: Control center for all settings and detailed calculations

### Header Design
```
┌─────────────────────────────────────┐
│ 🏠 Home Loan Advisor          [⚙️] │
└─────────────────────────────────────┘
```
- Clean, minimal header
- Settings icon (⚙️) navigates to Calculator tab
- No hamburger menu or notifications

## 🔄 User Flows

### First-Time User Flow
```
1. Onboarding Screen
   ├── Value proposition
   ├── Key features preview
   └── [Start Free Analysis] → Dashboard

2. Dashboard (with defaults)
   ├── Shows ₹696 daily loss (₹30L @ 8.5%)
   ├── "Using sample data" message
   └── Prompts to customize via ⚙️

3. Exploration
   ├── User explores strategies
   ├── Sees potential savings
   └── Motivated to personalize

4. Personalization (Calculator Tab)
   ├── Updates loan details
   ├── Adds optional info
   └── All screens update instantly
```

### Returning User Flow
```
1. App Opens → Dashboard
   ├── Shows personalized data
   ├── No onboarding
   └── Direct to insights

2. Regular Usage
   ├── Check daily loss
   ├── Explore new strategies
   └── Track progress
```

## 📊 Data Model

### Core Inputs (Required)
- **Loan Amount**: ₹10L - ₹5Cr (Default: ₹30L)
- **Interest Rate**: 6% - 12% (Default: 8.5%)
- **Tenure**: 5 - 30 years (Default: 20 years)

### Enhanced Inputs (Optional)
- **Monthly Income**: For EMI/Income ratio (Default: ₹1L)
- **Age**: For retirement planning (Default: 30)
- **Loan Status**: Planning/Taken (Default: Planning)
- **Months Paid**: If already taken (Default: 0)

### Smart Defaults
```javascript
{
  loanAmount: 3000000,    // ₹30 lakhs
  interestRate: 8.5,      // 8.5%
  tenure: 20,             // 20 years
  monthlyIncome: 100000,  // ₹1 lakh
  age: 30,                // 30 years
  loanStatus: 'planning', // Planning to buy
  monthsPaid: 0           // Not started
}
```

## 🎯 Key Features

### Dashboard Features
- **Daily Interest Burn Counter**: Live emotional trigger
- **Loan Health Score**: Gamified 0-10 rating
- **Quick Insights**: EMI, total interest, key metrics
- **Smart Tips**: Contextual daily recommendations

### Calculator Features
- **Loan Parameter Editing**: All inputs in one place
- **EMI Calculation**: Instant results
- **Breakdown Display**: Principal vs Interest
- **Amortization Schedule**: Year-wise breakdown
- **Visual Charts**: Pie chart for payment distribution

### Strategy Features
- **20 Indian Strategies**: Validated for Indian banking
- **Impact Display**: Exact savings for each strategy
- **Categories**: Organized by impact level
- **Implementation Guide**: Step-by-step instructions

### Progress Features
- **Dual Mode Display**:
  - Planning: Future milestones, preparation tips
  - Taken: Current progress, achievements
- **Milestone Tracking**: Key ownership points
- **Achievement System**: Gamified progress

## 🇮🇳 Indian Context Adaptations

### Removed Features (Not Applicable)
- ❌ Bi-weekly payments (Indian banks work monthly)
- ❌ Complex refinancing (limited in India)
- ❌ Market rate comparisons (no reliable data source)

### Added Features (India-Specific)
- ✅ Festival bonus prepayment strategies
- ✅ Tax benefit calculators (Section 80C/24b)
- ✅ Indian number formatting (lakhs/crores)
- ✅ Increment-based EMI increases
- ✅ Joint income optimization for couples

## 💾 State Management

### Local Storage
- User's loan parameters
- Optional personal information
- Selected strategies
- Achievement progress

### Session Management
- Persist data between app launches
- No server sync required
- Privacy-first approach

## 🎨 Design System

### Colors (from CSS variables)
```css
--primary-blue: #1565C0;
--growth-teal: #00796B;
--warning-orange: #FF8F00;
--success-green: #388E3C;
--error-red: #D32F2F;
```

### Typography
```css
--font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--font-size-headline: 32px;
--font-size-title: 24px;
--font-size-body: 18px;
```

### Spacing
```css
--space-xs: 4px;
--space-sm: 8px;
--space-md: 16px;
--space-lg: 24px;
--space-xl: 32px;
```

## 🚀 Implementation Priorities

### Phase 1: Core MVP
1. Onboarding flow
2. Dashboard with defaults
3. Calculator tab (control center)
4. Basic 5 strategies

### Phase 2: Full Features
1. All 20 strategies
2. Progress tracking
3. Achievement system
4. Amortization schedule

### Phase 3: Polish
1. Animations
2. Charts and visualizations ✅ (Added to Calculator)
3. Export features ✅ (CSV/PDF in Calculator)
4. Deep linking

## 🧮 Enhanced Calculator Features

### Visual Analytics
- **Pie Chart**: Principal vs Interest breakdown
- **Timeline Graph**: Loan balance reduction over years
- **Interactive**: Touch/hover for details
- **Library**: Chart.js or fl_chart for Flutter

### Amortization Schedule
- **Views**: Yearly (default), Monthly, Quarterly
- **Expandable**: Click year to see monthly breakdown
- **Full Schedule**: 240 months available
- **Smart Display**: Current year expanded for active loans

### Export Capabilities
- **CSV Export**: 
  - Full amortization schedule
  - Opens in Excel/Google Sheets
  - Includes summary statistics
- **PDF Export**:
  - Professional document format
  - Includes charts and visualizations
  - Suitable for CA/bank submission

### EMI Health Indicators
- **EMI-to-Income Ratio**: Automatic calculation
- **Health Status**:
  - Green (< 30%): Healthy
  - Yellow (30-40%): Manageable  
  - Red (> 40%): Risky
- **Visual Indicator**: Color-coded badge

## 📱 Technical Specifications

### Platform Requirements
- **Primary**: Android (5.0+)
- **Secondary**: iOS (future)
- **Screen Size**: Optimized for mobile (360-414px width)
- **Orientation**: Portrait only

### Performance Targets
- **App Size**: < 20MB
- **Calculation Speed**: < 100ms
- **Animation**: 60fps
- **Offline**: 100% functionality without internet

## 🔒 Privacy & Security

### Data Handling
- **No server communication**: All calculations local
- **No personal data collection**: Privacy-first
- **Optional analytics**: Anonymous usage only
- **Local storage only**: No cloud sync

### Security Measures
- Input validation for all fields
- Secure storage for user preferences
- No sensitive data in logs
- Clear data option available

---

**This architecture provides a clear, maintainable structure for the flutter-developer to implement the Home Loan Advisor app with Indian market focus and privacy-first approach.**