const { chromium } = require('playwright');
const fs = require('fs').promises;
const path = require('path');

// Viewport configurations
const viewports = {
  mobile: { width: 375, height: 667, name: 'iPhone SE' },
  tablet: { width: 768, height: 1024, name: 'iPad' },
  desktop: { width: 1920, height: 1080, name: 'Desktop' }
};

// App URL
const APP_URL = 'http://localhost:8888';

// Test scenarios
const testScenarios = [
  {
    name: 'Calculator Screen - Initial Load',
    actions: [],
    description: 'Test initial calculator screen layout'
  },
  {
    name: 'Calculator Screen - Filled Form',
    actions: [
      { type: 'fill', selector: 'input[type="text"]', value: '5000000', index: 0 }, // Loan amount
      { type: 'fill', selector: 'input[type="text"]', value: '8.5', index: 1 }, // Interest rate
      { type: 'fill', selector: 'input[type="text"]', value: '20', index: 2 }, // Loan tenure
    ],
    description: 'Test calculator with filled inputs'
  },
  {
    name: 'EMI Results - All Tabs',
    actions: [
      { type: 'fill', selector: 'input[type="text"]', value: '5000000', index: 0 },
      { type: 'fill', selector: 'input[type="text"]', value: '8.5', index: 1 },
      { type: 'fill', selector: 'input[type="text"]', value: '20', index: 2 },
      { type: 'click', selector: 'button[type="submit"]' },
      { type: 'wait', duration: 2000 }
    ],
    description: 'Test EMI results with all visualization tabs'
  },
  {
    name: 'Strategies Screen',
    actions: [
      { type: 'click', selector: '[href*="strategies"]' }
    ],
    description: 'Test strategies list screen'
  },
  {
    name: 'Prepayment Calculator',
    actions: [
      { type: 'click', selector: '[href*="prepayment"]' }
    ],
    description: 'Test prepayment calculator'
  },
  {
    name: 'History Screen',
    actions: [
      { type: 'click', selector: '[href*="history"]' }
    ],
    description: 'Test calculation history screen'
  }
];

class UITestRunner {
  constructor() {
    this.browser = null;
    this.issues = [];
    this.screenshotsDir = path.join(__dirname, 'ui-test-screenshots');
  }

  async init() {
    // Create screenshots directory
    try {
      await fs.mkdir(this.screenshotsDir, { recursive: true });
    } catch (error) {
      console.log('Screenshots directory already exists or error:', error.message);
    }

    // Launch browser
    this.browser = await chromium.launch({
      headless: false, // Set to true for CI
      slowMo: 100 // Slow down for better visibility
    });
  }

  async runTests() {
    console.log('🚀 Starting comprehensive UI testing...\n');

    for (const [viewportName, viewport] of Object.entries(viewports)) {
      console.log(`📱 Testing ${viewport.name} (${viewport.width}x${viewport.height})`);
      
      const context = await this.browser.newContext({
        viewport: { width: viewport.width, height: viewport.height },
        deviceScaleFactor: 1
      });

      const page = await context.newPage();
      
      // Add error listeners
      page.on('pageerror', (error) => {
        this.logIssue('JavaScript Error', error.message, viewportName, 'Console');
      });

      page.on('console', (msg) => {
        if (msg.type() === 'error') {
          this.logIssue('Console Error', msg.text(), viewportName, 'Console');
        }
      });

      try {
        // Navigate to app
        await page.goto(APP_URL, { waitUntil: 'networkidle' });
        await page.waitForTimeout(2000); // Wait for Flutter to load

        // Test each scenario
        for (const scenario of testScenarios) {
          console.log(`  📋 Testing: ${scenario.name}`);
          
          try {
            // Reset to home page for each scenario
            await page.goto(APP_URL, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1000);

            // Execute scenario actions
            await this.executeActions(page, scenario.actions);
            
            // Wait for any animations/loading
            await page.waitForTimeout(1500);

            // Take screenshot
            const screenshotPath = path.join(
              this.screenshotsDir,
              `${viewportName}_${scenario.name.replace(/[^a-zA-Z0-9]/g, '_')}.png`
            );
            await page.screenshot({ 
              path: screenshotPath, 
              fullPage: true,
              animations: 'disabled'
            });

            // Analyze UI issues
            await this.analyzeUIIssues(page, viewportName, scenario.name);

          } catch (error) {
            this.logIssue('Test Execution Error', error.message, viewportName, scenario.name);
          }
        }

        // Test scroll behavior
        await this.testScrollBehavior(page, viewportName);

        // Test responsive elements
        await this.testResponsiveElements(page, viewportName);

      } catch (error) {
        console.error(`Error testing ${viewportName}:`, error);
        this.logIssue('Navigation Error', error.message, viewportName, 'Initial Load');
      }

      await context.close();
      console.log(`✅ Completed ${viewport.name} testing\n`);
    }
  }

  async executeActions(page, actions) {
    for (const action of actions) {
      try {
        switch (action.type) {
          case 'fill':
            if (action.index !== undefined) {
              const elements = await page.$$(action.selector);
              if (elements[action.index]) {
                await elements[action.index].fill(action.value);
              }
            } else {
              await page.fill(action.selector, action.value);
            }
            break;
          case 'click':
            await page.click(action.selector);
            break;
          case 'wait':
            await page.waitForTimeout(action.duration);
            break;
        }
        await page.waitForTimeout(300); // Small delay between actions
      } catch (error) {
        console.log(`    ⚠️  Action failed: ${action.type} - ${error.message}`);
      }
    }
  }

  async analyzeUIIssues(page, viewport, scenario) {
    try {
      // Check for overlapping elements
      await this.checkOverlappingElements(page, viewport, scenario);
      
      // Check for text truncation
      await this.checkTextTruncation(page, viewport, scenario);
      
      // Check button sizes for touch targets
      await this.checkTouchTargets(page, viewport, scenario);
      
      // Check scroll issues
      await this.checkScrollIssues(page, viewport, scenario);
      
      // Check modal/dialog sizing
      await this.checkModalSizing(page, viewport, scenario);

    } catch (error) {
      this.logIssue('Analysis Error', error.message, viewport, scenario);
    }
  }

  async checkOverlappingElements(page, viewport, scenario) {
    const overlaps = await page.evaluate(() => {
      const elements = Array.from(document.querySelectorAll('*'));
      const overlapping = [];
      
      for (let i = 0; i < elements.length; i++) {
        const rect1 = elements[i].getBoundingClientRect();
        if (rect1.width === 0 || rect1.height === 0) continue;
        
        for (let j = i + 1; j < elements.length; j++) {
          const rect2 = elements[j].getBoundingClientRect();
          if (rect2.width === 0 || rect2.height === 0) continue;
          
          // Check if elements overlap
          if (rect1.left < rect2.right && rect2.left < rect1.right &&
              rect1.top < rect2.bottom && rect2.top < rect1.bottom) {
            
            // Check if one is a child of the other (not a real overlap)
            if (!elements[i].contains(elements[j]) && !elements[j].contains(elements[i])) {
              overlapping.push({
                element1: elements[i].tagName + (elements[i].className ? '.' + elements[i].className.split(' ')[0] : ''),
                element2: elements[j].tagName + (elements[j].className ? '.' + elements[j].className.split(' ')[0] : ''),
                rect1: { left: rect1.left, top: rect1.top, width: rect1.width, height: rect1.height },
                rect2: { left: rect2.left, top: rect2.top, width: rect2.width, height: rect2.height }
              });
            }
          }
        }
      }
      
      return overlapping;
    });

    overlaps.forEach(overlap => {
      this.logIssue(
        'Overlapping Elements',
        `${overlap.element1} overlaps with ${overlap.element2}`,
        viewport,
        scenario
      );
    });
  }

  async checkTextTruncation(page, viewport, scenario) {
    const truncations = await page.evaluate(() => {
      const elements = Array.from(document.querySelectorAll('*'));
      const truncated = [];
      
      elements.forEach(el => {
        if (el.scrollWidth > el.clientWidth || el.scrollHeight > el.clientHeight) {
          const style = window.getComputedStyle(el);
          if (style.overflow === 'hidden' || style.textOverflow === 'ellipsis') {
            truncated.push({
              element: el.tagName + (el.className ? '.' + el.className.split(' ')[0] : ''),
              text: el.textContent?.substring(0, 50) + '...',
              scrollWidth: el.scrollWidth,
              clientWidth: el.clientWidth
            });
          }
        }
      });
      
      return truncated;
    });

    truncations.forEach(item => {
      this.logIssue(
        'Text Truncation',
        `${item.element}: "${item.text}" (content: ${item.scrollWidth}px, container: ${item.clientWidth}px)`,
        viewport,
        scenario
      );
    });
  }

  async checkTouchTargets(page, viewport, scenario) {
    if (viewport === 'mobile') {
      const smallTargets = await page.evaluate(() => {
        const minSize = 44; // Minimum touch target size (44px)
        const buttons = Array.from(document.querySelectorAll('button, [role="button"], a, input[type="checkbox"], input[type="radio"]'));
        const small = [];
        
        buttons.forEach(btn => {
          const rect = btn.getBoundingClientRect();
          if ((rect.width < minSize || rect.height < minSize) && rect.width > 0 && rect.height > 0) {
            small.push({
              element: btn.tagName + (btn.className ? '.' + btn.className.split(' ')[0] : ''),
              size: { width: rect.width, height: rect.height },
              text: btn.textContent?.substring(0, 30) || btn.getAttribute('aria-label') || 'No text'
            });
          }
        });
        
        return small;
      });

      smallTargets.forEach(target => {
        this.logIssue(
          'Small Touch Target',
          `${target.element}: ${target.size.width}x${target.size.height}px - "${target.text}"`,
          viewport,
          scenario
        );
      });
    }
  }

  async checkScrollIssues(page, viewport, scenario) {
    const scrollIssues = await page.evaluate(() => {
      const issues = [];
      
      // Check for horizontal scroll on body
      if (document.body.scrollWidth > window.innerWidth) {
        issues.push({
          type: 'Horizontal Scroll',
          element: 'body',
          contentWidth: document.body.scrollWidth,
          viewportWidth: window.innerWidth
        });
      }
      
      // Check for elements causing horizontal overflow
      const elements = Array.from(document.querySelectorAll('*'));
      elements.forEach(el => {
        const rect = el.getBoundingClientRect();
        if (rect.right > window.innerWidth && rect.width > 50) {
          issues.push({
            type: 'Element Overflow',
            element: el.tagName + (el.className ? '.' + el.className.split(' ')[0] : ''),
            right: rect.right,
            viewportWidth: window.innerWidth
          });
        }
      });
      
      return issues;
    });

    scrollIssues.forEach(issue => {
      this.logIssue(
        issue.type,
        issue.type === 'Horizontal Scroll' 
          ? `Body width ${issue.contentWidth}px exceeds viewport ${issue.viewportWidth}px`
          : `${issue.element} extends to ${issue.right}px (viewport: ${issue.viewportWidth}px)`,
        viewport,
        scenario
      );
    });
  }

  async checkModalSizing(page, viewport, scenario) {
    const modals = await page.evaluate(() => {
      const modalSelectors = [
        '[role="dialog"]',
        '.modal',
        '.dialog',
        '[data-testid*="modal"]',
        '[data-testid*="dialog"]'
      ];
      
      const issues = [];
      modalSelectors.forEach(selector => {
        const elements = document.querySelectorAll(selector);
        elements.forEach(modal => {
          const rect = modal.getBoundingClientRect();
          const style = window.getComputedStyle(modal);
          
          if (rect.width > window.innerWidth || rect.height > window.innerHeight) {
            issues.push({
              selector: selector,
              size: { width: rect.width, height: rect.height },
              viewport: { width: window.innerWidth, height: window.innerHeight }
            });
          }
        });
      });
      
      return issues;
    });

    modals.forEach(modal => {
      this.logIssue(
        'Modal Sizing Issue',
        `Modal ${modal.selector}: ${modal.size.width}x${modal.size.height}px exceeds viewport ${modal.viewport.width}x${modal.viewport.height}px`,
        viewport,
        scenario
      );
    });
  }

  async testScrollBehavior(page, viewport) {
    console.log(`  🔄 Testing scroll behavior on ${viewport}`);
    
    try {
      // Test vertical scroll
      await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
      await page.waitForTimeout(500);
      
      const scrollPosition = await page.evaluate(() => window.pageYOffset);
      if (scrollPosition === 0) {
        this.logIssue('Scroll Issue', 'Cannot scroll vertically', viewport, 'Scroll Test');
      }
      
      // Reset scroll
      await page.evaluate(() => window.scrollTo(0, 0));
      
    } catch (error) {
      this.logIssue('Scroll Test Error', error.message, viewport, 'Scroll Test');
    }
  }

  async testResponsiveElements(page, viewport) {
    console.log(`  📐 Testing responsive elements on ${viewport}`);
    
    try {
      // Check if navigation adapts to viewport
      const navInfo = await page.evaluate(() => {
        const nav = document.querySelector('nav, [role="navigation"], .navigation, .navbar');
        if (!nav) return null;
        
        const style = window.getComputedStyle(nav);
        const rect = nav.getBoundingClientRect();
        
        return {
          display: style.display,
          flexDirection: style.flexDirection,
          width: rect.width,
          height: rect.height,
          position: style.position
        };
      });

      if (navInfo && viewport === 'mobile' && navInfo.flexDirection !== 'column') {
        this.logIssue(
          'Responsive Design',
          'Navigation may not be optimized for mobile (flex-direction is not column)',
          viewport,
          'Navigation Test'
        );
      }

    } catch (error) {
      this.logIssue('Responsive Test Error', error.message, viewport, 'Responsive Test');
    }
  }

  logIssue(category, description, viewport, scenario) {
    this.issues.push({
      category,
      description,
      viewport,
      scenario,
      timestamp: new Date().toISOString()
    });
  }

  async generateReport() {
    console.log('\n📊 Generating UI Issues Report...\n');

    // Group issues by category
    const groupedIssues = this.issues.reduce((acc, issue) => {
      if (!acc[issue.category]) {
        acc[issue.category] = [];
      }
      acc[issue.category].push(issue);
      return acc;
    }, {});

    // Generate report
    let report = '# Flutter Home Loan Advisor - UI Test Report\n\n';
    report += `**Generated:** ${new Date().toISOString()}\n`;
    report += `**Total Issues Found:** ${this.issues.length}\n\n`;

    // Summary by viewport
    const viewportSummary = this.issues.reduce((acc, issue) => {
      acc[issue.viewport] = (acc[issue.viewport] || 0) + 1;
      return acc;
    }, {});

    report += '## Issues by Viewport\n\n';
    Object.entries(viewportSummary).forEach(([viewport, count]) => {
      report += `- **${viewport}**: ${count} issues\n`;
    });
    report += '\n';

    // Issues by category
    report += '## Issues by Category\n\n';
    Object.entries(groupedIssues).forEach(([category, issues]) => {
      report += `### ${category} (${issues.length} issues)\n\n`;
      
      issues.forEach((issue, index) => {
        report += `**${index + 1}. ${issue.viewport} - ${issue.scenario}**\n`;
        report += `${issue.description}\n\n`;
      });
    });

    // Screenshots reference
    report += '## Screenshots\n\n';
    report += 'Screenshots for each viewport and scenario have been saved to:\n';
    report += `\`${this.screenshotsDir}\`\n\n`;

    // Write report to file
    const reportPath = path.join(__dirname, 'ui-test-report.md');
    await fs.writeFile(reportPath, report);
    
    console.log(`📝 Report saved to: ${reportPath}`);
    console.log(`📸 Screenshots saved to: ${this.screenshotsDir}`);
    
    // Print summary to console
    console.log('\n🎯 SUMMARY');
    console.log('==========');
    console.log(`Total Issues: ${this.issues.length}`);
    Object.entries(viewportSummary).forEach(([viewport, count]) => {
      console.log(`${viewport}: ${count} issues`);
    });
    console.log('\nTop Issue Categories:');
    Object.entries(groupedIssues)
      .sort(([,a], [,b]) => b.length - a.length)
      .slice(0, 5)
      .forEach(([category, issues]) => {
        console.log(`- ${category}: ${issues.length}`);
      });
    
    return reportPath;
  }

  async cleanup() {
    if (this.browser) {
      await this.browser.close();
    }
  }
}

// Main execution
async function main() {
  const tester = new UITestRunner();
  
  try {
    await tester.init();
    await tester.runTests();
    await tester.generateReport();
  } catch (error) {
    console.error('Test execution failed:', error);
  } finally {
    await tester.cleanup();
  }
}

// Check if script is run directly
if (require.main === module) {
  main().catch(console.error);
}

module.exports = { UITestRunner, main };