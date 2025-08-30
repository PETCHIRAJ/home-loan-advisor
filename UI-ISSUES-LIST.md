# UI/UX Issues List - Home Loan Advisor App

## Testing Environment
- Device: Samsung Galaxy S21
- Screen Size: 1080x2340 (6.2" display)
- Flutter Version: 3.35.1
- Testing Date: 2025-08-30

## 🔴 Critical Issues (Affecting Core Functionality)

### 1. Chart Legend Overlapping (PARTIALLY FIXED)
- **Location**: All chart visualizations
- **Issue**: Axis labels still overlap on very small devices
- **Impact**: Data unreadable on charts
- **Suggested Fix**: Implement responsive chart sizing or horizontal scroll

### 2. Small Touch Targets
- **Location**: Tab bars in visualizations, small buttons
- **Issue**: Tabs are too small for comfortable touch (< 48x48dp)
- **Impact**: Difficult to navigate between visualization tabs
- **Suggested Fix**: Increase tab height and padding

### 3. Step EMI Selector Layout
- **Location**: Calculator screen - Step EMI section
- **Issue**: Percentage chips wrap awkwardly on small screens
- **Impact**: UI looks broken when all options don't fit
- **Suggested Fix**: Horizontal scroll or dropdown for percentages

## 🟡 Major Issues (Affecting User Experience)

### 4. Text Truncation in Cards
- **Location**: Strategy cards, History cards
- **Issue**: Long text gets cut off with "..."
- **Impact**: Users can't read full information
- **Suggested Fix**: Expandable cards or "Read more" option

### 5. Modal Bottom Sheets Height
- **Location**: Strategy details, Filter sheets
- **Issue**: Some bottom sheets cover entire screen on small devices
- **Impact**: Users lose context of where they are
- **Suggested Fix**: Max height constraint with internal scroll

### 6. Scenario Comparison Cards
- **Location**: Scenario comparison screen
- **Issue**: Cards too wide for comfortable viewing on mobile
- **Impact**: Requires horizontal scrolling
- **Suggested Fix**: Stacked layout for mobile vs grid for tablet

### 7. Input Field Formatting
- **Location**: Loan amount input
- **Issue**: Indian formatting makes input confusing
- **Impact**: Users unsure if entering lakhs or actual amount
- **Suggested Fix**: Clear helper text and live formatting preview

## 🟢 Minor Issues (Polish & Refinement)

### 8. Empty State Illustrations
- **Location**: History, Strategies when empty
- **Issue**: No visual feedback when lists are empty
- **Impact**: App feels incomplete
- **Suggested Fix**: Add empty state illustrations

### 9. Loading States
- **Location**: Calculations, Chart rendering
- **Issue**: No skeleton loaders, just spinner
- **Impact**: Jarring transitions
- **Suggested Fix**: Implement skeleton screens

### 10. Navigation Feedback
- **Location**: Bottom navigation
- **Issue**: No haptic feedback on tab selection
- **Impact**: Less engaging interaction
- **Suggested Fix**: Add subtle haptic feedback

### 11. Color Contrast
- **Location**: Light theme text on colored backgrounds
- **Issue**: Some text hard to read on colored chips
- **Impact**: Accessibility concern
- **Suggested Fix**: Ensure WCAG AA compliance

### 12. Animation Performance
- **Location**: Tab transitions, Chart animations
- **Issue**: Slight jank on older devices
- **Impact**: App feels less premium
- **Suggested Fix**: Optimize animations or reduce complexity

## 📱 Responsive Design Issues

### 13. Fixed Heights
- **Location**: Chart containers, Lists
- **Issue**: Fixed heights cause content cutoff
- **Impact**: Content not visible on small screens
- **Suggested Fix**: Use flexible containers

### 14. Font Scaling
- **Location**: Throughout app
- **Issue**: Text doesn't respect system font size settings
- **Impact**: Accessibility issue for vision-impaired users
- **Suggested Fix**: Support dynamic text sizing

### 15. Landscape Orientation
- **Location**: All screens
- **Issue**: Layout breaks in landscape mode
- **Impact**: Unusable in landscape
- **Suggested Fix**: Responsive layout for landscape

## 🎨 Visual Polish

### 16. Inconsistent Spacing
- **Location**: Various screens
- **Issue**: Padding/margins inconsistent
- **Impact**: App looks unpolished
- **Suggested Fix**: Design system with consistent spacing

### 17. Icon Sizes
- **Location**: Cards, buttons
- **Issue**: Icon sizes vary across components
- **Impact**: Visual inconsistency
- **Suggested Fix**: Standardize icon sizes

### 18. Shadow Elevation
- **Location**: Cards
- **Issue**: Shadows too heavy on some cards
- **Impact**: Dated appearance
- **Suggested Fix**: Subtle Material 3 elevations

## 📊 Chart-Specific Issues

### 19. Pie Chart Labels
- **Location**: Overview tab pie chart
- **Issue**: Labels overlap on small values
- **Impact**: Unreadable data
- **Suggested Fix**: External labels or tooltips only

### 20. Bar Chart Spacing
- **Location**: Yearly breakdown
- **Issue**: Bars too close together
- **Impact**: Hard to distinguish years
- **Suggested Fix**: Increase spacing or reduce bar width

## 🔧 Functional UI Issues

### 21. Keyboard Handling
- **Location**: Input fields
- **Issue**: Keyboard covers input fields
- **Impact**: Can't see what typing
- **Suggested Fix**: Scroll to input when focused

### 22. Error Messages
- **Location**: Validation errors
- **Issue**: Error messages disappear too quickly
- **Impact**: Users miss important feedback
- **Suggested Fix**: Persistent error states

### 23. Success Feedback
- **Location**: After calculations
- **Issue**: No clear success indication
- **Impact**: Unclear if calculation completed
- **Suggested Fix**: Success animation or toast

## 📱 Platform-Specific

### 24. iOS Safe Areas
- **Location**: Top and bottom bars
- **Issue**: Content goes under notch/home indicator
- **Impact**: Content obscured
- **Suggested Fix**: Proper safe area handling

### 25. Android Back Button
- **Location**: Modal sheets, Navigation
- **Issue**: Inconsistent back button behavior
- **Impact**: Confusing navigation
- **Suggested Fix**: Predictable back navigation

## Priority Matrix

### Must Fix (Before Launch)
- Issues #1, #2, #3, #6, #7, #14, #15, #21

### Should Fix (Beta Testing)
- Issues #4, #5, #11, #13, #19, #22, #24, #25

### Nice to Have (Post-Launch)
- Issues #8, #9, #10, #12, #16, #17, #18, #20, #23

## Next Steps
1. Use UI/UX agent to provide design solutions
2. Implement fixes in priority order
3. Re-test on multiple devices
4. Conduct user testing for validation