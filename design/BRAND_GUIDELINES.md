# Home Loan Advisor - Brand Guidelines

## Brand Identity Overview

**Brand Mission**: Empower Indian home loan borrowers to save money through intelligent, privacy-first financial guidance.

**Brand Promise**: "Your trusted advisor for smarter home loan decisions"

**Brand Values**:
- **Trust**: Banking-level credibility and reliability
- **Savings**: Clear financial benefits for users
- **Simplicity**: Accessible to all skill levels
- **Privacy**: User data protection and transparency

## Logo Usage Guidelines

### Primary Logo: House + Rupee Symbol

#### Logo Specifications
- **Concept**: Modern house silhouette with integrated Indian Rupee symbol
- **Symbolism**: Home ownership + Indian financial context = Localized expertise
- **Style**: Clean, geometric, professional
- **Scalability**: Optimized for 16px to 1024px applications

#### Color Versions

**Full Color (Primary)**
- Use on light backgrounds (white to light gray)
- Minimum contrast ratio: 4.5:1
- Preferred version for marketing materials

**Monochrome (Single Color)**  
- Use when color reproduction is limited
- Available in: Primary Blue (#1565C0), Black (#1A1A1A), White (#FFFFFF)
- Maintain visual weight and contrast

**Reversed (Light on Dark)**
- Use on dark backgrounds
- White or light teal versions available
- Ensure sufficient contrast for accessibility

#### Minimum Size Requirements
```
Application Sizes:
- App Icon: 48x48px minimum
- Notification: 24x24px minimum  
- Favicon: 16x16px minimum
- Print: 0.5 inch minimum
- Digital: 32px minimum height
```

#### Clear Space (Exclusion Zone)
- **Minimum Clear Space**: X-height equal to the height of the rupee symbol
- **All Directions**: Top, bottom, left, right must maintain clear space
- **No Elements**: Text, graphics, or other logos within clear space
- **Background Colors**: Use brand-approved backgrounds only

### Logo Don'ts

❌ **Never Do**:
- Stretch or distort the logo proportions
- Change or modify the color relationships
- Add drop shadows, gradients, or effects
- Place on busy backgrounds without sufficient contrast
- Use pixelated or low-resolution versions
- Rotate the logo from its intended orientation
- Separate the house and rupee symbol elements
- Use non-brand fonts for accompanying text

✅ **Always Do**:
- Use provided logo files
- Maintain proper clear space
- Ensure sufficient contrast
- Scale proportionally
- Use on approved background colors
- Test readability at intended size

## Color Palette

### Primary Colors

**Trust Blue (#1565C0)**
- **Hex**: #1565C0
- **RGB**: 21, 101, 192  
- **CMYK**: 89, 47, 0, 25
- **Usage**: Primary buttons, headers, main logo elements
- **Psychology**: Banking trust, reliability, professionalism

**Growth Teal (#00796B)**
- **Hex**: #00796B
- **RGB**: 0, 121, 107
- **CMYK**: 100, 0, 12, 53
- **Usage**: Success indicators, savings highlights, secondary actions
- **Psychology**: Financial growth, prosperity, stability

### Accent Colors

**Gold Accent (#FFD700)**
- **Hex**: #FFD700
- **RGB**: 255, 215, 0
- **CMYK**: 0, 16, 100, 0
- **Usage**: Premium features, cultural elements, special highlights
- **Cultural**: Significance in Tamil Nadu and Indian traditions

**Success Green (#388E3C)**
- **Hex**: #388E3C
- **RGB**: 56, 142, 60
- **CMYK**: 61, 0, 58, 44
- **Usage**: Confirmations, achievements, positive outcomes

**Warning Orange (#FF8F00)**
- **Hex**: #FF8F00
- **RGB**: 255, 143, 0
- **CMYK**: 0, 44, 100, 0
- **Usage**: Alerts, urgency, important notifications

### Neutral Palette

**Text Primary (#1A1A1A)**
- **Usage**: Headlines, primary text content
- **Contrast**: WCAG AAA compliant on light backgrounds

**Text Secondary (#666666)**
- **Usage**: Subheadings, secondary information
- **Contrast**: WCAG AA compliant on white backgrounds

**Background Primary (#FAFAFA)**
- **Usage**: Main background, card surfaces
- **Clean**: Minimal, unobtrusive base

## Typography System

### Primary Typeface: System Fonts
**Rationale**: Performance optimization and platform consistency

```css
font-family: 
  system-ui, 
  -apple-system, 
  'Segoe UI', 
  'Roboto', 
  'Helvetica Neue', 
  sans-serif;
```

### Type Scale (Modular Scale: 1.25)
```css
/* Mobile-First Typography */
--text-xs: 0.75rem;    /* 12px - Labels, captions */
--text-sm: 0.875rem;   /* 14px - Secondary text */
--text-base: 1rem;     /* 16px - Body text */
--text-lg: 1.25rem;    /* 20px - Emphasis, buttons */
--text-xl: 1.563rem;   /* 25px - H4 */
--text-2xl: 1.953rem;  /* 31px - H3 */
--text-3xl: 2.441rem;  /* 39px - H2 */
--text-4xl: 3.052rem;  /* 49px - H1, hero */
```

### Font Weights
- **Regular (400)**: Body text, general content
- **Medium (500)**: Subheadings, emphasis
- **Semibold (600)**: Section headers, navigation
- **Bold (700)**: Headlines, primary CTAs

### Number Display (Financial Data)
```css
/* Monospace for financial figures */
.financial-number {
  font-family: 'SF Mono', 'Monaco', 'Menlo', monospace;
  font-weight: 600;
  letter-spacing: 0.025em;
}
```

## Visual Style Guidelines

### Design Principles

**1. Clarity Over Complexity**
- Simple, understandable interfaces
- Clear visual hierarchy
- Minimal cognitive load
- Progressive disclosure of information

**2. Trust Through Design**
- Professional appearance
- Consistent interactions
- Reliable functionality
- Banking-level visual standards

**3. Cultural Sensitivity**
- Subtle Indian cultural elements
- Avoid stereotypical representations
- Modern, contemporary aesthetic
- Universal accessibility

**4. Mobile-First Approach**
- Touch-friendly interface elements
- Readable at small screen sizes
- Fast loading times
- Optimized for smartphone usage

### Layout Principles

**Grid System**: 8-point baseline grid
```css
/* Spacing System */
--space-1: 0.25rem;   /* 4px */
--space-2: 0.5rem;    /* 8px */
--space-4: 1rem;      /* 16px */
--space-6: 1.5rem;    /* 24px */
--space-8: 2rem;      /* 32px */
```

**Container Widths**:
- Mobile: 100% width with 16px padding
- Tablet: 768px max-width
- Desktop: 1200px max-width (if applicable)

**Visual Hierarchy**:
- Use size, color, and spacing to create hierarchy
- Most important elements get primary colors
- Secondary elements use neutral colors
- Clear reading patterns (F-pattern, Z-pattern)

## Application Guidelines

### App Icon Usage

**Android Adaptive Icons**
- **Foreground**: Logo elements with safe area consideration
- **Background**: Brand color or subtle pattern
- **Maskable**: Design works with any mask shape

**iOS App Icons**  
- **Rounded Corners**: System-applied, design for square
- **No Transparency**: Solid backgrounds required
- **High Resolution**: 1024x1024px master file

### Marketing Materials

**Social Media Profiles**
- **Profile Image**: Simplified logo mark
- **Cover/Banner**: Brand message integration
- **Post Templates**: Consistent visual style

**Print Materials**
- **Business Cards**: Horizontal logo preferred
- **Letterhead**: Top-left placement standard
- **Brochures**: Logo as quality indicator

### Digital Applications

**Website/Web App**
- **Header Logo**: Horizontal version preferred
- **Favicon**: Simplified icon version
- **Loading States**: Animated logo considerations

**Email Signatures**
- **Size**: Maximum 150px width
- **Format**: PNG with transparent background
- **Linking**: Logo as clickable element

## Brand Voice & Tone

### Brand Personality
- **Expert**: Knowledgeable about home loans
- **Approachable**: Not intimidating like banks
- **Trustworthy**: Reliable financial guidance
- **Empowering**: Helps users make better decisions

### Voice Characteristics
- **Clear**: Simple, jargon-free explanations
- **Confident**: Assured recommendations
- **Supportive**: Understanding user challenges
- **Professional**: Credible financial expertise

### Tone Variations

**Educational Content**
- Informative but accessible
- Use examples and analogies
- Step-by-step explanations
- Encouraging language

**App Interface**
- Concise and action-oriented
- Positive reinforcement
- Clear instructions
- Helpful error messages

**Marketing Messages**
- Benefit-focused language
- Social proof integration
- Urgency when appropriate
- Trust-building statements

## Technical Specifications

### File Formats

**Vector Graphics (Preferred)**
- **SVG**: Web applications, scalable graphics
- **AI/EPS**: Print applications, professional use

**Raster Graphics**
- **PNG**: Transparency required, icons
- **JPG**: Photography, no transparency needed
- **WebP**: Modern web applications (with fallbacks)

### File Naming Convention
```
Format: brand-element-variation-size.extension

Examples:
logo-primary-full-color-512.png
logo-monochrome-reversed-256.svg
icon-app-simplified-48.png
```

### Quality Standards
- **Resolution**: 300 DPI for print, 72 DPI for digital
- **Color Profile**: sRGB for digital, CMYK for print
- **File Size**: Optimized for web performance
- **Compression**: Lossless for logos, optimized for photos

## Accessibility Requirements

### WCAG 2.1 Compliance

**Color Contrast**
- **Normal Text**: 4.5:1 minimum ratio
- **Large Text**: 3:1 minimum ratio
- **UI Components**: 3:1 minimum ratio

**Alternative Text**
- Descriptive alt text for logo images
- Brand name inclusion in alt descriptions
- Context-appropriate descriptions

**Scalability**
- Logo readable at 200% zoom
- Text maintains clarity when enlarged
- Touch targets minimum 44px (iOS) / 48dp (Android)

### Inclusive Design
- **Color Independence**: Never use color alone for meaning
- **High Contrast Mode**: Test logo visibility
- **Screen Readers**: Proper semantic markup
- **Motor Accessibility**: Adequate touch target sizes

## Brand Implementation Checklist

### Before Launch
- [ ] Logo files created in all required formats
- [ ] Color palette documented with exact values
- [ ] Typography system defined and tested
- [ ] App icons generated for all required sizes
- [ ] Marketing materials align with brand guidelines
- [ ] Accessibility standards met
- [ ] Brand guidelines shared with team

### Ongoing Maintenance
- [ ] Regular brand compliance audits
- [ ] Update guidelines as brand evolves
- [ ] Train new team members on brand usage
- [ ] Monitor brand consistency across touchpoints
- [ ] Collect user feedback on brand perception
- [ ] Update assets when platforms change requirements

---

*These brand guidelines ensure consistent, professional, and accessible brand representation across all touchpoints while building trust with Indian home loan borrowers.*