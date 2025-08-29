# Flutter Developer Checklist

## 🎯 Pre-Development Checklist

### Architecture Understanding
- [ ] Read `APP_ARCHITECTURE.md` for overall system design
- [ ] Review `PROJECT_SUMMARY.md` for business requirements
- [ ] Understand the 4-tab navigation structure (Home, Strategies, Progress, Calculator)
- [ ] Note: Profile/Settings functionality is integrated into Calculator tab

### Design Resources
- [ ] Review all 8 wireframes in `design/wireframes/`
- [ ] Test all 7 HTML mockups in `design/mockups/`
- [ ] Extract design tokens from HTML mockups (colors, typography, spacing)
- [ ] Study `BUTTON_DESIGN_SYSTEM.md` for consistent UI components

### Calculator Features (Priority)
- [ ] Review `CALCULATOR_ENHANCEMENTS.md` for complete feature list
- [ ] Implement basic EMI calculation first
- [ ] Add EMI-to-Income ratio with color indicators
- [ ] Integrate Chart.js or fl_chart for visualizations
- [ ] Build amortization schedule (yearly/monthly views)
- [ ] Add CSV/PDF export functionality
- [ ] Implement input sliders (₹5L-₹5Cr range)

### Strategy Implementation
- [ ] Study `STRATEGY_DETAIL_SPECS.md` for all 20 strategies
- [ ] Use `strategy-detail-extra-emi.html` as template
- [ ] Implement strategy list with categories
- [ ] Build reusable strategy detail component

### Icon Replacement
- [ ] Read `FLUTTER_IMPLEMENTATION_NOTES.md`
- [ ] Replace all emojis with Material Icons
- [ ] Use rounded icon variants for consistency

### Navigation Flow
- [ ] 4-tab bottom navigation (NOT 5 tabs)
- [ ] Tabs: Home | Strategies | Progress | Calculator
- [ ] Calculator tab contains all settings (no separate profile)
- [ ] Smart header shows loan summary everywhere

### Data Management
- [ ] Calculator is single source of truth
- [ ] Use Provider/Riverpod for state management
- [ ] Store in SharedPreferences for persistence
- [ ] All calculations must work offline

### Testing Requirements
- [ ] Test with minimum loan (₹5L)
- [ ] Test with maximum loan (₹5Cr)
- [ ] Verify Indian number formatting
- [ ] Test all 20 strategies calculations
- [ ] Ensure offline functionality

### Platform Configuration
- [ ] Target Android 5.0+ (API 21+)
- [ ] Configure for portrait mode only
- [ ] Set up Indian locale (en_IN)
- [ ] Configure proper app permissions (minimal)

### Analytics Integration
- [ ] Review `docs/analytics/ANALYTICS_REQUIREMENTS.md`
- [ ] Implement Firebase Analytics (optional)
- [ ] Track only anonymous usage
- [ ] No personal data collection

### Legal Compliance
- [ ] Include `docs/legal/PRIVACY_POLICY.md` in app
- [ ] Include `docs/legal/TERMS_OF_USE.md` in app
- [ ] Add links in Calculator settings section

### Play Store Preparation
- [ ] Use content from `docs/playstore/PLAY_STORE_LISTING.md`
- [ ]Generate screenshots from actual app
- [ ] Create app icon following Material guidelines
- [ ] Prepare feature graphic (1024x500)

## 📱 Development Priority Order

### Phase 1: Core (Week 1)
1. Bottom navigation with 4 tabs
2. Basic calculator with EMI calculation
3. Dashboard with burn counter
4. Smart header implementation

### Phase 2: Features (Week 2)
1. Calculator enhancements (charts, schedule)
2. All 20 strategies listing
3. Strategy detail pages
4. Progress tracking views

### Phase 3: Polish (Week 3)
1. Animations and transitions
2. Export functionality
3. Input validation
4. Error handling

### Phase 4: Release (Week 4)
1. Testing on multiple devices
2. Performance optimization
3. Play Store assets
4. Final documentation

## ⚠️ Important Notes

### What Changed from Original Design
- **No Profile Page**: Settings moved to Calculator tab
- **4 Tabs Only**: Not 5 tabs as some old docs might mention
- **Offline-First**: No server calls, no user accounts
- **Extended Ranges**: ₹5L-₹5Cr (not ₹10L-₹2Cr)

### Key Files to Start With
1. `design/mockups/calculator.html` - Most complex screen
2. `design/mockups/dashboard.html` - Home screen
3. `APP_ARCHITECTURE.md` - Technical guide
4. `CALCULATOR_ENHANCEMENTS.md` - Feature specifications

### Common Pitfalls to Avoid
- Don't create a profile page (it's deprecated)
- Don't use emojis (use Material Icons)
- Don't make network calls (fully offline)
- Don't forget Indian number formatting

## ✅ Definition of Done

- [ ] All 4 tabs functional with proper navigation
- [ ] Calculator with all enhanced features working
- [ ] All 20 strategies accessible with detail pages
- [ ] Progress tracking for both loan statuses
- [ ] Data persists between sessions
- [ ] Works completely offline
- [ ] Indian number formatting throughout
- [ ] Material Icons (no emojis)
- [ ] Responsive on 360-414px screens
- [ ] APK size < 20MB

---

**Questions?** Review the documentation or check HTML mockups for visual reference.