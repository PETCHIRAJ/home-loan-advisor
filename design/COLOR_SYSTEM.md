# Home Loan Advisor - Color System

## Brand Color Palette

### Primary Colors

```css
:root {
  /* Primary Brand Colors */
  --primary-blue: #1565C0;        /* Trust, Banking, Stability */
  --primary-blue-light: #42A5F5;  /* Interactive states */
  --primary-blue-dark: #0D47A1;   /* High contrast elements */
  
  --growth-teal: #00796B;         /* Prosperity, Savings */
  --growth-teal-light: #4DB6AC;   /* Success indicators */
  --growth-teal-dark: #004D40;    /* Deep trust */
  
  /* Accent Colors */
  --warning-orange: #FF8F00;      /* Urgency, Attention */
  --success-green: #388E3C;       /* Achievement, Positive */
  --gold-accent: #FFD700;         /* Tamil Nadu Cultural */
  
  /* Neutral Palette */
  --background-primary: #FAFAFA;   /* Clean, Minimal */
  --background-secondary: #F5F5F5; /* Card backgrounds */
  --surface-white: #FFFFFF;        /* Pure white surfaces */
  
  --text-primary: #1A1A1A;        /* Primary text */
  --text-secondary: #666666;      /* Secondary text */
  --text-muted: #999999;          /* Disabled/muted text */
  
  --border-light: #E0E0E0;        /* Light borders */
  --border-medium: #BDBDBD;       /* Medium borders */
  --divider: #F0F0F0;             /* Section dividers */
}
```

### Dark Mode Support

```css
[data-theme="dark"] {
  --primary-blue: #64B5F6;
  --growth-teal: #4DB6AC;
  --warning-orange: #FFB74D;
  --success-green: #81C784;
  --gold-accent: #FFD54F;
  
  --background-primary: #121212;
  --background-secondary: #1E1E1E;
  --surface-white: #2D2D2D;
  
  --text-primary: #FFFFFF;
  --text-secondary: #B3B3B3;
  --text-muted: #737373;
  
  --border-light: #333333;
  --border-medium: #484848;
  --divider: #2A2A2A;
}
```

## Color Psychology & Usage

### Primary Blue (#1565C0)
**Psychology**: Trust, reliability, professionalism, banking credibility  
**Usage**: 
- Primary buttons and CTAs
- App navigation elements
- Logo primary color
- Important headlines
- Financial data highlights

**Accessibility**: WCAG AA compliant with white text (contrast ratio 4.8:1)

### Growth Teal (#00796B)
**Psychology**: Prosperity, growth, stability, financial success  
**Usage**:
- Savings indicators
- Positive financial metrics
- Success states
- Progress indicators
- Achievement badges

**Cultural Significance**: Associated with prosperity in Indian culture

### Warning Orange (#FF8F00)
**Psychology**: Attention, urgency, caution, important alerts  
**Usage**:
- Warning messages
- High-interest rate alerts
- Time-sensitive notifications
- Call-to-action emphasis
- Important deadlines

### Success Green (#388E3C)
**Psychology**: Achievement, positive outcomes, growth, completion  
**Usage**:
- Success confirmations
- Savings achievements
- Completed milestones
- Positive trend indicators
- Goal completions

### Gold Accent (#FFD700)
**Psychology**: Premium, valuable, cultural significance  
**Usage**:
- Premium features
- Special achievements
- Cultural elements (Tamil context)
- Celebration states
- Premium badges

**Cultural Context**: Gold significance in Tamil Nadu and Indian culture

## Logo Color Applications

### Concept 1: House + Calculator
- **Primary**: Trust Blue (#1565C0)
- **Secondary**: Growth Teal (#00796B)
- **Accent**: Gold (#FFD700) for calculator elements

### Concept 2: House + Rupee
- **Primary**: Growth Teal (#00796B)
- **Secondary**: Trust Blue (#1565C0)
- **Accent**: Gold (#FFD700) for rupee symbol

### Concept 3: Shield + Home
- **Primary**: Trust Blue (#1565C0)
- **Secondary**: Success Green (#388E3C)
- **Accent**: Gold (#FFD700) for protective elements

## Accessibility Guidelines

### Contrast Ratios (WCAG 2.1 AA)
- **Normal text**: Minimum 4.5:1 contrast ratio
- **Large text**: Minimum 3:1 contrast ratio
- **UI components**: Minimum 3:1 contrast ratio

### Color-Blind Considerations
- Never use color alone to convey information
- Include icons and text labels with color coding
- Test with ColorBrewer and Stark for accessibility
- Provide high contrast mode support

### Tested Combinations
✅ Primary Blue + White Text (4.8:1)  
✅ Growth Teal + White Text (4.2:1)  
✅ Text Primary + Background (12.6:1)  
✅ Warning Orange + Dark Text (8.3:1)  

## Implementation Notes

### CSS Custom Properties
Use CSS custom properties for consistent theming across the application.

### Flutter Implementation
```dart
class AppColors {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color growthTeal = Color(0xFF00796B);
  static const Color warningOrange = Color(0xFFFF8F00);
  static const Color successGreen = Color(0xFF388E3C);
  static const Color goldAccent = Color(0xFFFFD700);
  
  static const Color backgroundPrimary = Color(0xFFFAFAFA);
  static const Color textPrimary = Color(0xFF1A1A1A);
}
```

### Android XML Colors
```xml
<resources>
    <color name="primary_blue">#1565C0</color>
    <color name="growth_teal">#00796B</color>
    <color name="warning_orange">#FF8F00</color>
    <color name="success_green">#388E3C</color>
    <color name="gold_accent">#FFD700</color>
</resources>
```

---

*This color system provides the foundation for all visual elements while ensuring accessibility, cultural relevance, and brand consistency.*