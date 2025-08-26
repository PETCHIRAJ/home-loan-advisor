# UX Design Standards - Always Follow This Process

## MANDATORY WORKFLOW FOR ALL PROJECTS

### Phase 1: Text Wireframes (ALWAYS FIRST)
Location: `design/wireframes/`

**Requirements:**
- Create ASCII text layouts showing structure ONLY
- Focus on information hierarchy and component placement
- List all features and content areas
- Define navigation flows between screens
- Get user approval before proceeding to Phase 2
- NEVER create HTML/CSS/Flutter code in this phase

**Deliverables:**
- `README.md` - Project overview and navigation
- `[screen-name].md` - ASCII wireframe per screen
- `user-flows.md` - Navigation and interaction flows

**ASCII Format Example:**
```
┌─────────────────────────────────────┐
│ Header / App Title              [≡] │
├─────────────────────────────────────┤
│                                     │
│   MAIN FEATURE AREA                 │
│   • Primary action                  │
│   • Secondary info                  │
│                                     │
├─────────────────────────────────────┤
│ Actions        │ Secondary Content  │
│ • Button 1     │ • Metric 1         │
│ • Button 2     │ • Metric 2         │
└─────────────────────────────────────┘
[Bottom Navigation Tabs]
```

### Phase 2: HTML Mockups (AFTER WIREFRAME APPROVAL)
Location: `design/mockups/`

**Requirements:**
- Create self-contained HTML files (no external dependencies)
- Apply complete visual design system
- Include interactive hover/active states
- Ensure mobile responsiveness
- One HTML file per screen for easy review
- NEVER create Flutter/Dart code

**Deliverables:**
- `index.html` - Navigation hub to all screens
- `[screen-name].html` - Interactive visual mockup per screen

### Phase 3: Design System (WITH MOCKUPS)
Location: `design/assets/`

**Requirements:**
- Extract reusable CSS components
- Document color psychology and usage
- Define typography scales and spacing
- Create component library documentation

**Deliverables:**
- `design-system.css` - Complete visual system
- `colors.css` - Color palette with usage notes
- `typography.css` - Font scales and hierarchy

### Phase 4: Documentation (FINAL)
Location: `design/specs/`

**Requirements:**
- Document all design decisions and rationale
- Create component usage guidelines
- Include accessibility considerations
- Provide implementation notes for developers

**Deliverables:**
- `design-spec.md` - Complete design specification
- `components.md` - Component library documentation
- `guidelines.md` - Usage and implementation guides

## FOLDER STRUCTURE STANDARD

```
project-root/
├── design/                    # ALL design assets here
│   ├── wireframes/           # Phase 1: Text layouts
│   │   ├── README.md
│   │   ├── dashboard.md
│   │   └── user-flows.md
│   │
│   ├── mockups/              # Phase 2: HTML previews
│   │   ├── index.html
│   │   └── [screen].html
│   │
│   ├── assets/               # Phase 3: Design system
│   │   ├── design-system.css
│   │   ├── colors.css
│   │   └── typography.css
│   │
│   └── specs/                # Phase 4: Documentation
│       ├── design-spec.md
│       ├── components.md
│       └── guidelines.md
│
├── lib/                      # Flutter implementation (separate)
└── README.md                 # Project documentation
```

## RULES TO NEVER BREAK

1. **ALWAYS start with text wireframes** - Never jump to visual design
2. **NEVER create Flutter/Dart code** - That's flutter-developer's job
3. **NEVER put design files in lib/ folder** - Keep separate from implementation
4. **ALWAYS use single design/ folder** - Don't crowd project root
5. **ALWAYS get approval after Phase 1** - Before investing in visuals
6. **ALWAYS create self-contained HTML** - No external dependencies
7. **ALWAYS document design decisions** - Include rationale and psychology

## DELIVERABLE CHECKLIST

Before completing any design task, ensure ALL items exist:

**Phase 1 (Required for approval):**
□ design/wireframes/README.md
□ design/wireframes/[screen].md (one per screen)
□ design/wireframes/user-flows.md

**Phase 2 (After approval):**
□ design/mockups/index.html
□ design/mockups/[screen].html (one per screen)

**Phase 3 (Design system):**
□ design/assets/design-system.css
□ design/assets/colors.css
□ design/assets/typography.css

**Phase 4 (Documentation):**
□ design/specs/design-spec.md
□ design/specs/components.md
□ design/specs/guidelines.md

## QUALITY STANDARDS

- **ASCII wireframes**: Clear hierarchy, proper spacing, all features listed
- **HTML mockups**: Self-contained, responsive, interactive states
- **Design system**: Consistent, documented, reusable
- **Documentation**: Complete rationale, implementation guidance

Follow this process for EVERY design project. No exceptions.