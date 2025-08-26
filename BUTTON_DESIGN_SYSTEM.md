# Button Design System
## Home Loan Advisor App

A comprehensive button system following Material Design 3 guidelines to ensure consistency across the application.

## Design Principles

- **Hierarchy**: Clear visual distinction between button importance levels
- **Accessibility**: Minimum 44px touch target for mobile interactions
- **Consistency**: Standardized padding, sizing, and typography
- **Context**: Appropriate button types for different use cases

## Button Hierarchy & Types

### 1. Primary CTA Buttons
**Usage**: Main actions that drive user engagement (e.g., "Explore Strategies", "Calculate Savings", "Get Started")

```css
.btn-primary {
  /* Sizing */
  min-height: 48px;
  padding: var(--space-md) var(--space-xl); /* 16px 32px */
  
  /* Typography */
  font-size: var(--font-size-body); /* 16px */
  font-weight: 600;
  line-height: 1.2;
  
  /* Visual */
  border-radius: 8px;
  border: none;
  background: linear-gradient(135deg, #1976D2 0%, #1565C0 100%);
  color: #FFFFFF;
  
  /* Interaction */
  cursor: pointer;
  transition: all 0.2s ease;
  
  /* States */
  &:hover {
    background: linear-gradient(135deg, #1565C0 0%, #0D47A1 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(25, 118, 210, 0.3);
  }
  
  &:active {
    transform: translateY(0);
    box-shadow: 0 2px 8px rgba(25, 118, 210, 0.2);
  }
  
  &:disabled {
    background: #E0E0E0;
    color: #9E9E9E;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
  }
}

/* Large variant for hero sections */
.btn-primary-large {
  min-height: 56px;
  padding: var(--space-lg) var(--space-xl); /* 24px 32px */
  font-size: 18px;
}
```

### 2. Secondary Buttons
**Usage**: Supporting actions, alternative options (e.g., "Learn More", "Compare Options", "View Details")

```css
.btn-secondary {
  /* Sizing */
  min-height: 44px;
  padding: var(--space-sm) var(--space-lg); /* 8px 24px */
  
  /* Typography */
  font-size: var(--font-size-body); /* 16px */
  font-weight: 500;
  line-height: 1.2;
  
  /* Visual */
  border-radius: 8px;
  border: 2px solid #1976D2;
  background: transparent;
  color: #1976D2;
  
  /* Interaction */
  cursor: pointer;
  transition: all 0.2s ease;
  
  /* States */
  &:hover {
    background: rgba(25, 118, 210, 0.08);
    border-color: #1565C0;
    color: #1565C0;
  }
  
  &:active {
    background: rgba(25, 118, 210, 0.12);
  }
  
  &:disabled {
    border-color: #E0E0E0;
    color: #9E9E9E;
    cursor: not-allowed;
  }
}

/* Small variant for cards */
.btn-secondary-small {
  min-height: 36px;
  padding: var(--space-xs) var(--space-md); /* 4px 16px */
  font-size: var(--font-size-label); /* 14px */
}
```

### 3. Text Buttons
**Usage**: Low emphasis actions (e.g., "Dismiss", "Skip", "Cancel", "Learn More")

```css
.btn-text {
  /* Sizing */
  min-height: 40px;
  padding: var(--space-sm) var(--space-md); /* 8px 16px */
  
  /* Typography */
  font-size: var(--font-size-body); /* 16px */
  font-weight: 500;
  line-height: 1.2;
  
  /* Visual */
  border-radius: 4px;
  border: none;
  background: transparent;
  color: #1976D2;
  
  /* Interaction */
  cursor: pointer;
  transition: all 0.2s ease;
  
  /* States */
  &:hover {
    background: rgba(25, 118, 210, 0.08);
  }
  
  &:active {
    background: rgba(25, 118, 210, 0.12);
  }
  
  &:disabled {
    color: #9E9E9E;
    cursor: not-allowed;
  }
}

/* Small variant for inline actions */
.btn-text-small {
  min-height: 32px;
  padding: var(--space-xs) var(--space-sm); /* 4px 8px */
  font-size: var(--font-size-label); /* 14px */
}

/* Caption variant for subtle actions */
.btn-text-caption {
  min-height: 28px;
  padding: var(--space-xs); /* 4px */
  font-size: var(--font-size-caption); /* 12px */
  font-weight: 400;
}
```

### 4. Icon Buttons
**Usage**: Single action buttons with icons (e.g., settings gear, back arrow, close button)

```css
.btn-icon {
  /* Sizing */
  width: 44px;
  height: 44px;
  min-height: 44px;
  padding: 0;
  
  /* Visual */
  border-radius: 50%;
  border: none;
  background: transparent;
  color: #424242;
  
  /* Layout */
  display: flex;
  align-items: center;
  justify-content: center;
  
  /* Interaction */
  cursor: pointer;
  transition: all 0.2s ease;
  
  /* Icon sizing */
  & svg,
  & i {
    width: 20px;
    height: 20px;
    font-size: 20px;
  }
  
  /* States */
  &:hover {
    background: rgba(66, 66, 66, 0.08);
    color: #212121;
  }
  
  &:active {
    background: rgba(66, 66, 66, 0.12);
  }
  
  &:disabled {
    color: #9E9E9E;
    cursor: not-allowed;
  }
}

/* Small variant for compact layouts */
.btn-icon-small {
  width: 36px;
  height: 36px;
  min-height: 36px;
  
  & svg,
  & i {
    width: 18px;
    height: 18px;
    font-size: 18px;
  }
}

/* Large variant for prominent actions */
.btn-icon-large {
  width: 56px;
  height: 56px;
  min-height: 56px;
  
  & svg,
  & i {
    width: 24px;
    height: 24px;
    font-size: 24px;
  }
}
```

### 5. Bottom Navigation Buttons
**Usage**: Navigation tabs in bottom navigation bar

```css
.btn-nav {
  /* Sizing */
  min-height: 56px;
  padding: var(--space-xs) var(--space-sm); /* 4px 8px */
  flex: 1;
  
  /* Typography */
  font-size: var(--font-size-caption); /* 12px */
  font-weight: 500;
  line-height: 1.2;
  
  /* Visual */
  border: none;
  background: transparent;
  color: #757575;
  
  /* Layout */
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--space-xs); /* 4px */
  
  /* Interaction */
  cursor: pointer;
  transition: all 0.2s ease;
  
  /* Icon styling */
  & svg,
  & i {
    width: 20px;
    height: 20px;
    font-size: 20px;
    margin-bottom: 2px;
  }
  
  /* States */
  &:hover {
    background: rgba(117, 117, 117, 0.08);
    color: #424242;
  }
  
  &.active {
    color: #1976D2;
    
    & svg,
    & i {
      color: #1976D2;
    }
  }
}
```

## Special Button Variants

### Floating Action Button (FAB)
```css
.btn-fab {
  width: 56px;
  height: 56px;
  min-height: 56px;
  border-radius: 50%;
  border: none;
  background: #1976D2;
  color: #FFFFFF;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  
  display: flex;
  align-items: center;
  justify-content: center;
  
  cursor: pointer;
  transition: all 0.2s ease;
  
  & svg,
  & i {
    width: 24px;
    height: 24px;
    font-size: 24px;
  }
  
  &:hover {
    background: #1565C0;
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
  }
  
  &:active {
    transform: translateY(0);
  }
}
```

### Chip Buttons
```css
.btn-chip {
  min-height: 32px;
  padding: var(--space-xs) var(--space-md); /* 4px 16px */
  
  font-size: var(--font-size-label); /* 14px */
  font-weight: 500;
  
  border-radius: 16px;
  border: 1px solid #E0E0E0;
  background: #FAFAFA;
  color: #424242;
  
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:hover {
    background: #F5F5F5;
    border-color: #BDBDBD;
  }
  
  &.selected {
    background: #E3F2FD;
    border-color: #1976D2;
    color: #1976D2;
  }
}
```

## Usage Guidelines

### Button Hierarchy Rules

1. **One Primary Button Per Screen**: Use only one primary button per view to avoid decision paralysis
2. **Maximum 3 Button Types**: Don't mix more than 3 different button types in one interface section
3. **Consistent Placement**: Primary buttons should be right-aligned, secondary buttons left-aligned

### When to Use Each Type

| Button Type | Use Cases | Examples |
|-------------|-----------|----------|
| Primary | Main conversion actions, form submissions | "Get Pre-approved", "Calculate Savings" |
| Secondary | Alternative actions, navigation | "Compare Rates", "View Details" |
| Text | Cancel actions, dismissals, low priority | "Skip", "Cancel", "Learn More" |
| Icon | Single actions, navigation controls | Settings, Back, Close, Menu |
| Bottom Nav | App-level navigation | Home, Calculator, Profile, Settings |

### Accessibility Requirements

```css
/* Ensure all buttons meet accessibility standards */
.btn-base {
  /* Minimum touch target */
  min-height: 44px;
  min-width: 44px;
  
  /* Focus indicators */
  &:focus-visible {
    outline: 2px solid #1976D2;
    outline-offset: 2px;
  }
  
  /* High contrast mode support */
  @media (prefers-contrast: high) {
    border-width: 2px;
  }
  
  /* Reduced motion support */
  @media (prefers-reduced-motion: reduce) {
    transition: none;
    transform: none;
  }
}
```

## Implementation Examples

### React Component Example
```jsx
// Primary button with loading state
<button 
  className="btn-primary"
  disabled={isLoading}
  onClick={handleSubmit}
>
  {isLoading ? 'Calculating...' : 'Explore Strategies'}
</button>

// Secondary button with icon
<button className="btn-secondary">
  <Icon name="info" />
  Learn More
</button>

// Icon button with accessibility
<button 
  className="btn-icon"
  aria-label="Open settings"
  onClick={openSettings}
>
  <Icon name="settings" />
</button>
```

### CSS Implementation Priority
1. Apply base button reset styles
2. Add specific button type classes
3. Include accessibility features
4. Add interaction states
5. Implement responsive adjustments

## Testing & Quality Assurance

### Visual Testing Checklist
- [ ] All buttons meet minimum 44px touch target
- [ ] Focus indicators are visible and consistent
- [ ] Hover states provide clear feedback
- [ ] Disabled states are visually distinct
- [ ] Color contrast meets WCAG AA standards (4.5:1)

### Interaction Testing
- [ ] Buttons respond to keyboard navigation
- [ ] Screen readers announce button purpose clearly
- [ ] Touch interactions work on mobile devices
- [ ] Loading states prevent duplicate submissions

## Maintenance Notes

- Review button usage quarterly for consistency
- Update color values when brand colors change
- Test new button variants with accessibility tools
- Document any custom button implementations
- Keep design tokens synchronized across platforms