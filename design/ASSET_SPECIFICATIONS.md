# Home Loan Advisor - Asset Specifications

## Asset Creation Requirements

### File Organization Structure
```
assets/
├── logos/
│   ├── primary/
│   │   ├── logo-primary.svg
│   │   ├── logo-primary-512.png
│   │   ├── logo-primary-256.png
│   │   └── logo-primary-horizontal.svg
│   ├── concepts/
│   │   ├── concept-1-house-calculator/
│   │   ├── concept-2-house-rupee/
│   │   └── concept-3-shield-home/
│   └── variations/
│       ├── logo-monochrome.svg
│       ├── logo-reversed.svg
│       └── logo-simplified.svg
├── icons/
│   ├── app-icon-512.png
│   ├── android-sizes/
│   │   ├── mipmap-mdpi/ (48x48)
│   │   ├── mipmap-hdpi/ (72x72)
│   │   ├── mipmap-xhdpi/ (96x96)
│   │   ├── mipmap-xxhdpi/ (144x144)
│   │   └── mipmap-xxxhdpi/ (192x192)
│   └── notification-icons/
│       ├── ic_notification_24.png
│       ├── ic_notification_36.png
│       └── ic_notification_48.png
├── playstore/
│   ├── feature-graphic-1024x500.png
│   ├── app-icon-512.png
│   ├── screenshots/
│   │   ├── phone-1080x1920/ 
│   │   └── tablet-1200x1920/
│   └── promotional/
│       ├── banner-1024x500.png
│       └── social-media-1200x1200.png
└── brand-guidelines/
    ├── color-palette.png
    ├── typography-samples.png
    └── usage-examples.png
```

## Android App Icon Specifications

### Primary App Icon Requirements
```
Dimensions & Formats:
- 512x512px (Play Store, high-res)
- 192x192px (xxxhdpi) - 4x
- 144x144px (xxhdpi) - 3x  
- 96x96px (xhdpi) - 2x
- 72x72px (hdpi) - 1.5x
- 48x48px (mdpi) - 1x (baseline)

File Format: PNG-24 with transparency
Color Profile: sRGB
Compression: Optimized PNG (reduce file size)
```

### Icon Design Guidelines
```css
/* Icon Safe Area */
.app-icon {
  /* Total canvas: 512x512px */
  padding: 64px; /* 12.5% margin on all sides */
  /* Live area: 384x384px */
  
  /* Visual weight distribution */
  primary-element: 60%; /* Main house/symbol */
  secondary-element: 25%; /* Accent elements */
  whitespace: 15%; /* Breathing room */
}
```

### Adaptive Icon Support (Android 8.0+)
```
Foreground Layer: 432x432px (centered in 512x512)
Background Layer: 512x512px (solid color or simple pattern)
Safe Zone: 264x264px (circular crop area)
```

## Play Store Marketing Assets

### Feature Graphic (1024x500px)
**Purpose**: Banner image at top of Play Store listing  
**Content Strategy**:
- App mockup showing key features
- Value proposition headline
- Visual hierarchy: logo → app preview → benefits
- Call-to-action integration

**Design Elements**:
```
Layout Structure:
┌────────────────────────────────────┐
│ [Logo]  "Save Money on Home Loans" │ ← Header (100px height)
│                                    │
│ [Phone Mockup]  • Smart Calculator │ ← Content (300px height)  
│ showing app     • Privacy First    │
│ interface       • Indian Loans     │
│                                    │
│ "Download Free" [Play Store Badge] │ ← CTA (100px height)
└────────────────────────────────────┘
```

**Technical Requirements**:
- Format: PNG or JPG
- Color Profile: sRGB
- File Size: < 1MB
- Text readable at thumbnail size
- High contrast for mobile viewing

### App Screenshots (1080x1920px)
**Required Screenshots**: Minimum 2, maximum 8  
**Recommended Set**:
1. **Dashboard Overview** - Main screen showing loan status
2. **Calculator Interface** - EMI calculation in action  
3. **Savings Analysis** - Money-saving strategies display
4. **Progress Tracking** - Loan reduction visualization
5. **Privacy Features** - Data security highlights

**Screenshot Enhancement**:
- Add subtle drop shadows to phone frames
- Include descriptive captions
- Highlight key features with callout bubbles
- Maintain consistent visual style

## Logo Technical Specifications

### SVG Logo Requirements
```svg
<!-- Optimized SVG structure -->
<svg viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <!-- Use minimal path complexity for performance -->
  <!-- Include proper color definitions -->
  <!-- Optimize for small file size (<50KB) -->
</svg>
```

### PNG Logo Specifications
```
High Resolution: 512x512px, 1024x1024px
Medium Resolution: 256x256px, 128x128px  
Small Resolution: 64x64px, 32x32px
Micro Resolution: 24x24px, 16x16px

Color Depth: 32-bit PNG (RGBA)
Compression: PNG-8 for simple graphics
Transparency: Full alpha channel support
```

### Logo Variations Required

#### 1. Primary Full-Color Logo
- **Usage**: Main applications, marketing materials
- **Colors**: Full brand palette
- **Details**: All design elements included

#### 2. Monochrome Logo  
- **Usage**: Single-color applications, embossing
- **Colors**: Single color + transparency
- **Contrast**: Works on light and dark backgrounds

#### 3. Reversed Logo
- **Usage**: Dark backgrounds, hero sections
- **Colors**: White/light version
- **Visibility**: High contrast on dark surfaces

#### 4. Simplified Logo
- **Usage**: Small applications, favicons
- **Details**: Reduced complexity for clarity
- **Recognition**: Maintains brand identity at small sizes

#### 5. Horizontal Logo
- **Usage**: Headers, letterheads, wide formats
- **Layout**: Logo + text side-by-side
- **Proportions**: Optimized for horizontal spaces

## Notification Icons

### Android Notification Icon Requirements
```
Sizes Required:
- 24x24dp (mdpi) = 24x24px
- 36x36dp (hdpi) = 36x36px  
- 48x48dp (xhdpi) = 48x48px
- 72x72dp (xxhdpi) = 72x72px
- 96x96dp (xxxhdpi) = 96x96px

Design Rules:
- Pure white (#FFFFFF) icon on transparent background
- No gray or color - system applies its own coloring
- Simple shape, no fine details
- High contrast, bold design
```

### Status Bar Icon Design
```
Visual Guidelines:
- Use house silhouette only
- Remove internal details
- Thick stroke weight (minimum 8px at 48x48)
- Rounded corners for modern feel
- Test visibility on colored notification backgrounds
```

## File Naming Convention

### Consistent Naming Pattern
```
Format: {component}-{variant}-{size}.{ext}

Examples:
logo-primary-512.png
logo-monochrome-256.png
icon-app-192.png
feature-graphic-1024x500.png
screenshot-dashboard-1080x1920.png
notification-icon-48.png
```

### Version Control
```
Include version numbers for major updates:
logo-primary-v2-512.png
icon-app-v1.1-192.png

Maintain previous versions:
archive/
├── v1/
└── v2/
```

## Quality Assurance Checklist

### Technical Quality
- [ ] All sizes generated and tested
- [ ] File sizes optimized for mobile
- [ ] Color profiles consistent (sRGB)
- [ ] Transparency working correctly
- [ ] SVG files optimized and minified

### Visual Quality  
- [ ] Sharp edges at all sizes
- [ ] Colors match brand specifications
- [ ] Readable at smallest required size
- [ ] Consistent visual weight across sizes
- [ ] High contrast on various backgrounds

### Platform Testing
- [ ] App icon appears correctly in Android
- [ ] Play Store assets display properly
- [ ] Notification icons visible in status bar
- [ ] Screenshots showcase key features
- [ ] Marketing graphics load quickly

### Accessibility Testing
- [ ] Sufficient contrast ratios maintained
- [ ] Icon recognizable without color
- [ ] Text legible for vision impaired
- [ ] Alternative text provided for images

---

*These specifications ensure consistent, high-quality visual assets across all platforms and applications while maintaining brand integrity and technical performance.*