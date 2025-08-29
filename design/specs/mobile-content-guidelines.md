# Mobile Content Formatting Guidelines

> Comprehensive guidelines for structuring home loan strategy content for optimal mobile consumption

**Purpose**: Ensure all strategy content is optimized for mobile reading, comprehension, and action-taking
**Target Audience**: UX writers, content designers, and developers implementing strategy presentations
**Last Updated**: 2025-08-29
**Version**: 1.0

## Core Mobile Content Principles

### 1. Cognitive Load Management
- **Single Focus Per Screen**: Each screen addresses one primary task or decision
- **7±2 Rule**: Limit choices and information chunks to 5-9 items maximum
- **Progressive Disclosure**: Layer information from essential to detailed
- **Visual Breathing Room**: Adequate white space prevents overwhelming users

### 2. Thumb-Friendly Design
- **Interaction Zones**: Primary actions within 44px minimum touch targets
- **Single-Handed Usage**: Critical actions accessible with thumb reach
- **Scroll Ergonomics**: Comfortable vertical scrolling with clear section breaks
- **Gesture Support**: Swipe for comparisons, tap for expansion

### 3. Scanning Optimization
- **Front-Loaded Information**: Most important content in first 3 lines
- **Keyword Emphasis**: Bold key terms, amounts, and action items
- **Visual Hierarchy**: Clear heading structure and content grouping
- **Quick Decision Support**: Key facts accessible within 3 seconds

## Content Chunk Guidelines

### Hero Information (Above Fold)
**Character Limit**: 120 characters including spaces
**Word Count**: 15-20 words maximum
**Purpose**: Immediate impact recognition and value proposition

```
Format:
[Strategy Name]
Save $[Amount] over loan life
[Key Benefit in 4-6 words]
```

**Example**:
```
Extra Repayments
Save $18,400 over loan life
Cut 4.2 years off your loan
```

### Summary Bullets (Level 2)
**Bullet Count**: 3-4 maximum
**Characters per Bullet**: 40-60 characters
**Structure**: Action + Outcome format

```
Format:
• [Action Verb] [What] → [Benefit]
• [Time/Effort] → [Result]
• [Risk Level] → [Confidence]
```

**Example**:
```
• Add $200/month → Save $18,400 interest
• Start immediately → No paperwork required
• Zero risk → Guaranteed results
```

### Comparison Tables (Level 3)
**Columns**: Maximum 3 for mobile screens
**Rows**: Maximum 5 for single screen view
**Cell Content**: 1-3 words or simple numbers

```
Format:
|  Metric    | Current | With Strategy |
| Savings    |   $0    |   $18,400    |
| Loan Term  | 25 yrs  |   20.8 yrs   |
| Risk       |   -     |     None     |
```

### Implementation Steps (Level 3)
**Step Count**: 3-5 steps maximum
**Characters per Step**: 80-120 characters including action and explanation
**Time Estimates**: Always include for effort assessment

```
Format:
1. [Action Verb] [What] ([Time])
   [One-line explanation of why/how]

2. [Action Verb] [What] ([Time])
   [One-line explanation of why/how]
```

**Example**:
```
1. Contact your lender (5 mins)
   Set up automatic increased payment

2. Update budget tracking (15 mins)
   Ensure you can afford extra $200

3. Monitor first payment (next month)
   Verify extra amount goes to principal
```

### Risk and Consideration Blocks (Level 4)
**Format**: Pros/Cons or Benefits/Warnings structure
**Item Count**: 3-4 items maximum per category
**Character Limit**: 50-70 characters per item

```
Format:
✅ Benefits:
• [Benefit 1 in 6-8 words]
• [Benefit 2 in 6-8 words]
• [Benefit 3 in 6-8 words]

⚠️ Watch out for:
• [Warning 1 in 6-8 words]
• [Warning 2 in 6-8 words]
```

## Visual Content Structure

### Number Presentation
**Hero Numbers**: 
- Font size: 2.5x base text
- Color: Primary brand color
- Format: $XX,XXX (no cents for large amounts)
- Context: Always include timeframe or comparison

**Supporting Numbers**:
- Font size: 1.2x base text
- Format: Consistent decimal places (e.g., 4.2 years, not 4.23)
- Visual grouping: Related numbers in same visual container

### Before/After Comparisons
**Layout**: Side-by-side cards or table format
**Highlighting**: Color coding for improvements (green) and current state (neutral)
**Labels**: "Current" vs "With [Strategy Name]"
**Emphasis**: Bold the changed/improved values

```
Visual Structure:
┌─── BEFORE ───┐  ┌─── AFTER ────┐
│ Payment: $X  │  │ Payment: $Y  │
│ Term: X yrs  │  │ Term: Y yrs  │
│ Interest: $X │  │ Interest: $Y │
└──────────────┘  └──────────────┘
```

### Progress Indicators
**Savings Progress**: Horizontal bar showing progress toward goal
**Implementation Progress**: Step-by-step checklist format
**Time-based**: Timeline view for multi-step strategies
**Risk Level**: Color-coded indicators (green/yellow/red)

## Content Hierarchy by Information Level

### Level 1: Attention & Interest (3-5 seconds)
- Strategy name with icon
- Hero savings number
- One-line benefit statement
- Difficulty/risk indicators

### Level 2: Consideration (15-30 seconds)
- Key action required
- Summary benefits (3-4 bullets)
- Time to implement
- Risk assessment

### Level 3: Evaluation (1-3 minutes)
- Detailed calculations
- Step-by-step implementation
- Before/after comparisons
- Interactive elements (sliders, calculators)

### Level 4: Decision Support (3-5 minutes)
- Comprehensive pros/cons
- Suitability assessment
- Alternative options
- Professional guidance recommendations

## Combination Content Guidelines

### Multi-Strategy Presentations
**Selection Interface**: Visual cards with checkboxes
**Impact Calculation**: Clear math showing individual vs combined
**Complexity Warning**: Visual indicators for increased difficulty
**Sequencing**: Timeline showing implementation order

### Comparison Tables
**Strategy Count**: Maximum 3 strategies in mobile comparison
**Metric Selection**: 5-7 most important comparison points
**Visual Coding**: Icons and colors for quick scanning
**Decision Support**: Highlight best options for different scenarios

### Implementation Sequences
**Timeline Format**: Vertical timeline with phases
**Dependency Indicators**: Visual connections between related steps
**Flexibility Points**: Clear indicators where users can adjust
**Progress Tracking**: Checkboxes or completion indicators

## Accessibility & Inclusivity

### Language Guidelines
**Reading Level**: Grade 8-10 maximum (Flesch-Kincaid scale)
**Jargon**: Define or avoid financial terminology
**Tone**: Professional but conversational
**Cultural Sensitivity**: Avoid assumptions about financial literacy

### Visual Accessibility
**Contrast Ratios**: Minimum 4.5:1 for normal text, 3:1 for large text
**Color Independence**: Never rely solely on color to convey meaning
**Text Alternatives**: All icons and graphics have text equivalents
**Font Size**: Minimum 16px for body text, scalable design

### Interaction Accessibility
**Touch Targets**: Minimum 44px x 44px for interactive elements
**Focus Indicators**: Clear visual focus for keyboard navigation
**Screen Reader Support**: Proper heading structure and ARIA labels
**Voice Control**: Actions accessible via voice commands

## Platform-Specific Considerations

### iOS Guidelines
- Use SF Symbols for consistent iconography
- Follow Dynamic Type for text scaling
- Respect safe areas for iPhone notch/island
- Use iOS-native date/time formats

### Android Guidelines
- Material Design 3 theming system
- Adaptive layouts for different screen sizes
- Android-specific gesture patterns
- Local currency and date formats

### Cross-Platform Consistency
- Maintain same information architecture
- Consistent difficulty/risk indicators
- Universal icon meanings
- Standardized number formatting

## Testing & Validation

### Content Testing Checklist
- [ ] Can key information be understood in 5 seconds?
- [ ] Are action steps clear and specific?
- [ ] Do numbers include proper context?
- [ ] Are risks and benefits balanced?
- [ ] Is technical language explained?

### Mobile Testing Scenarios
- [ ] One-handed usage while commuting
- [ ] Outdoor reading in bright sunlight
- [ ] Distracted environment (multitasking)
- [ ] Low battery/slow connection conditions
- [ ] Various device orientations

### User Validation Methods
- **5-Second Tests**: Can users identify main benefit immediately?
- **Task Completion**: Can users find implementation steps?
- **Comprehension**: Do users understand risks and benefits?
- **Decision Confidence**: Do users feel ready to act?

## Performance Guidelines

### Content Loading
**Critical Path**: Hero information loads first
**Progressive Enhancement**: Additional details load as needed
**Image Optimization**: Compress visual content for mobile
**Caching Strategy**: Cache frequently accessed calculation results

### Interaction Responsiveness
**Touch Response**: Immediate visual feedback within 100ms
**Navigation**: Page transitions under 300ms
**Calculations**: Real-time updates for interactive elements
**Error Handling**: Clear, helpful error messages

This comprehensive guide ensures all home loan strategy content is optimized for mobile consumption while maintaining the depth and accuracy needed for financial decision-making.