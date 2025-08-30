const { chromium } = require('playwright');
const fs = require('fs').promises;
const path = require('path');

const APP_URL = 'http://localhost:8888';

const viewports = {
  mobile: { width: 375, height: 667, name: 'iPhone SE' },
  tablet: { width: 768, height: 1024, name: 'iPad' },
  desktop: { width: 1920, height: 1080, name: 'Desktop' }
};

class SimpleUIInspector {
  constructor() {
    this.issues = [];
    this.screenshotsDir = path.join(__dirname, 'ui-inspection-screenshots');
  }

  async init() {
    try {
      await fs.mkdir(this.screenshotsDir, { recursive: true });
    } catch (error) {
      console.log('Screenshots directory setup:', error.message);
    }

    this.browser = await chromium.launch({
      headless: false,
      slowMo: 50
    });
  }

  async inspectApp() {
    console.log('🔍 Starting UI Inspection...\n');

    for (const [viewportName, viewport] of Object.entries(viewports)) {
      console.log(`📱 Inspecting ${viewport.name} (${viewport.width}x${viewport.height})`);
      
      const context = await this.browser.newContext({
        viewport: { width: viewport.width, height: viewport.height }
      });

      const page = await context.newPage();
      
      try {
        // Navigate and wait for Flutter to load
        await page.goto(APP_URL, { waitUntil: 'networkidle' });
        await page.waitForTimeout(5000); // Give Flutter time to fully render
        
        // Take initial screenshot
        await this.takeScreenshot(page, viewportName, 'initial-load');
        
        // Inspect DOM structure
        await this.inspectDOMStructure(page, viewportName);
        
        // Check basic responsive issues
        await this.checkBasicResponsiveIssues(page, viewportName);
        
        // Check for Flutter-specific issues
        await this.checkFlutterWebIssues(page, viewportName);
        
        // Test scrolling
        await this.testScrolling(page, viewportName);
        
        // Try to interact with forms if they exist
        await this.testFormInteraction(page, viewportName);
        
      } catch (error) {
        console.error(`Error inspecting ${viewportName}:`, error);
        this.logIssue('Navigation Error', error.message, viewportName);
      }

      await context.close();
      console.log(`✅ Completed ${viewport.name} inspection\n`);
    }
  }

  async takeScreenshot(page, viewport, scenario) {
    const screenshotPath = path.join(
      this.screenshotsDir,
      `${viewport}_${scenario}.png`
    );
    await page.screenshot({ 
      path: screenshotPath, 
      fullPage: true,
      animations: 'disabled'
    });
    console.log(`  📸 Screenshot: ${scenario}`);
  }

  async inspectDOMStructure(page, viewport) {
    console.log('  🔍 Analyzing DOM structure...');
    
    const structure = await page.evaluate(() => {
      // Look for Flutter web elements
      const flutterApp = document.querySelector('flutter-view, flt-semantics-host, #root');
      const forms = document.querySelectorAll('form, [role="form"]');
      const buttons = document.querySelectorAll('button, [role="button"]');
      const inputs = document.querySelectorAll('input, textarea, [contenteditable]');
      const navigation = document.querySelectorAll('nav, [role="navigation"]');
      
      return {
        hasFlutterApp: !!flutterApp,
        flutterAppType: flutterApp?.tagName || 'none',
        formsCount: forms.length,
        buttonsCount: buttons.length,
        inputsCount: inputs.length,
        navigationCount: navigation.length,
        bodyScrollWidth: document.body.scrollWidth,
        windowInnerWidth: window.innerWidth,
        hasHorizontalScroll: document.body.scrollWidth > window.innerWidth
      };
    });

    console.log(`    Flutter App: ${structure.hasFlutterApp ? 'Found (' + structure.flutterAppType + ')' : 'Not Found'}`);
    console.log(`    Forms: ${structure.formsCount}, Buttons: ${structure.buttonsCount}, Inputs: ${structure.inputsCount}`);
    console.log(`    Navigation: ${structure.navigationCount}`);
    console.log(`    Scroll: ${structure.bodyScrollWidth}px content in ${structure.windowInnerWidth}px viewport`);
    
    if (structure.hasHorizontalScroll) {
      this.logIssue('Horizontal Scroll', `Content width ${structure.bodyScrollWidth}px exceeds viewport ${structure.windowInnerWidth}px`, viewport);
    }
  }

  async checkBasicResponsiveIssues(page, viewport) {
    console.log('  📐 Checking responsive issues...');
    
    const issues = await page.evaluate(() => {
      const problems = [];
      
      // Check for fixed widths that might cause issues
      const elements = Array.from(document.querySelectorAll('*'));
      const viewportWidth = window.innerWidth;
      
      elements.forEach(el => {
        const rect = el.getBoundingClientRect();
        const style = window.getComputedStyle(el);
        
        // Check for elements extending beyond viewport
        if (rect.right > viewportWidth && rect.width > 50) {
          problems.push({
            type: 'Element Overflow',
            element: `${el.tagName}${el.className ? '.' + el.className.split(' ')[0] : ''}`,
            right: Math.round(rect.right),
            viewportWidth: viewportWidth,
            width: Math.round(rect.width)
          });
        }
        
        // Check for very small text
        const fontSize = parseFloat(style.fontSize);
        if (fontSize < 12 && rect.width > 0) {
          problems.push({
            type: 'Small Text',
            element: `${el.tagName}${el.className ? '.' + el.className.split(' ')[0] : ''}`,
            fontSize: fontSize,
            content: el.textContent?.substring(0, 30) || 'No text'
          });
        }
        
        // Check for tiny buttons on mobile
        if (viewportWidth <= 375 && 
            (el.tagName === 'BUTTON' || el.getAttribute('role') === 'button') && 
            (rect.width < 44 || rect.height < 44) && 
            rect.width > 0) {
          problems.push({
            type: 'Small Touch Target',
            element: `${el.tagName}${el.className ? '.' + el.className.split(' ')[0] : ''}`,
            size: `${Math.round(rect.width)}x${Math.round(rect.height)}px`,
            content: el.textContent?.substring(0, 20) || el.getAttribute('aria-label') || 'No text'
          });
        }
      });
      
      return problems;
    });

    issues.forEach(issue => {
      let description = '';
      switch (issue.type) {
        case 'Element Overflow':
          description = `${issue.element} extends to ${issue.right}px (viewport: ${issue.viewportWidth}px, element width: ${issue.width}px)`;
          break;
        case 'Small Text':
          description = `${issue.element} has ${issue.fontSize}px font size: "${issue.content}"`;
          break;
        case 'Small Touch Target':
          description = `${issue.element} is ${issue.size}: "${issue.content}"`;
          break;
      }
      this.logIssue(issue.type, description, viewport);
    });

    if (issues.length === 0) {
      console.log('    ✅ No obvious responsive issues found');
    } else {
      console.log(`    ⚠️  Found ${issues.length} responsive issues`);
    }
  }

  async checkFlutterWebIssues(page, viewport) {
    console.log('  🐦 Checking Flutter web specific issues...');
    
    const flutterIssues = await page.evaluate(() => {
      const issues = [];
      
      // Check for Flutter canvaskit vs HTML renderer issues
      const canvasElements = document.querySelectorAll('canvas');
      const flutterHost = document.querySelector('flutter-view, flt-semantics-host');
      
      if (canvasElements.length > 0) {
        issues.push({
          type: 'Canvas Rendering',
          count: canvasElements.length,
          description: 'Using CanvasKit renderer (good for performance, may have accessibility issues)'
        });
        
        // Check if canvas is properly sized
        canvasElements.forEach((canvas, index) => {
          const rect = canvas.getBoundingClientRect();
          if (rect.width !== window.innerWidth || rect.height < 300) {
            issues.push({
              type: 'Canvas Sizing',
              description: `Canvas ${index + 1} size: ${Math.round(rect.width)}x${Math.round(rect.height)}px (viewport: ${window.innerWidth}x${window.innerHeight}px)`
            });
          }
        });
      }
      
      // Check for Flutter semantic issues
      const semanticsHost = document.querySelector('flt-semantics-host');
      if (semanticsHost) {
        const semanticElements = semanticsHost.querySelectorAll('[role], [aria-label]');
        issues.push({
          type: 'Accessibility',
          description: `Found ${semanticElements.length} semantic elements (good for accessibility)`
        });
      }
      
      // Check loading indicators
      const loadingIndicators = document.querySelectorAll('.loading, [data-testid*="loading"], .spinner');
      if (loadingIndicators.length > 0) {
        issues.push({
          type: 'Loading State',
          description: `${loadingIndicators.length} loading indicators still visible (may indicate loading issues)`
        });
      }
      
      return issues;
    });

    flutterIssues.forEach(issue => {
      this.logIssue(issue.type, issue.description, viewport);
    });

    if (flutterIssues.length === 0) {
      console.log('    ✅ No Flutter-specific issues found');
    }
  }

  async testScrolling(page, viewport) {
    console.log('  🔄 Testing scrolling behavior...');
    
    try {
      // Test vertical scroll
      const initialY = await page.evaluate(() => window.pageYOffset);
      
      await page.evaluate(() => {
        window.scrollTo(0, Math.max(document.body.scrollHeight / 2, 500));
      });
      await page.waitForTimeout(500);
      
      const middleY = await page.evaluate(() => window.pageYOffset);
      
      await page.evaluate(() => {
        window.scrollTo(0, document.body.scrollHeight);
      });
      await page.waitForTimeout(500);
      
      const endY = await page.evaluate(() => window.pageYOffset);
      
      // Reset scroll
      await page.evaluate(() => window.scrollTo(0, 0));
      await page.waitForTimeout(300);
      
      if (middleY <= initialY && endY <= initialY) {
        this.logIssue('Scroll Issue', 'Page does not scroll vertically', viewport);
      } else {
        console.log(`    ✅ Vertical scroll working (0 → ${middleY} → ${endY}px)`);
      }
      
      // Take screenshot at different scroll positions
      if (middleY > initialY) {
        await page.evaluate(() => window.scrollTo(0, Math.max(document.body.scrollHeight / 2, 500)));
        await this.takeScreenshot(page, viewport, 'mid-scroll');
        
        await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
        await this.takeScreenshot(page, viewport, 'bottom-scroll');
        
        await page.evaluate(() => window.scrollTo(0, 0));
      }
      
    } catch (error) {
      this.logIssue('Scroll Test Error', error.message, viewport);
    }
  }

  async testFormInteraction(page, viewport) {
    console.log('  📝 Testing form interactions...');
    
    try {
      // Look for input fields and try to interact with them
      const formElements = await page.evaluate(() => {
        const inputs = Array.from(document.querySelectorAll('input, textarea, [contenteditable="true"]'));
        const buttons = Array.from(document.querySelectorAll('button, [role="button"]'));
        
        return {
          inputs: inputs.map((input, index) => ({
            index,
            type: input.type || input.tagName.toLowerCase(),
            placeholder: input.placeholder || '',
            value: input.value || '',
            visible: input.offsetWidth > 0 && input.offsetHeight > 0
          })),
          buttons: buttons.map((button, index) => ({
            index,
            text: button.textContent?.trim() || button.getAttribute('aria-label') || 'No text',
            visible: button.offsetWidth > 0 && button.offsetHeight > 0
          }))
        };
      });

      console.log(`    Found ${formElements.inputs.length} inputs, ${formElements.buttons.length} buttons`);
      
      // Try to interact with first few visible inputs
      const visibleInputs = formElements.inputs.filter(input => input.visible).slice(0, 3);
      
      for (const input of visibleInputs) {
        try {
          const selector = `input:nth-of-type(${input.index + 1})`;
          await page.focus(selector, { timeout: 2000 });
          await page.type(selector, '123', { timeout: 2000 });
          await page.waitForTimeout(300);
          console.log(`    ✅ Successfully interacted with input ${input.index + 1} (${input.type})`);
        } catch (error) {
          console.log(`    ⚠️  Could not interact with input ${input.index + 1}: ${error.message.split('.')[0]}`);
        }
      }
      
      // Take screenshot after form interaction
      if (visibleInputs.length > 0) {
        await this.takeScreenshot(page, viewport, 'form-filled');
      }

    } catch (error) {
      this.logIssue('Form Test Error', error.message, viewport);
    }
  }

  logIssue(category, description, viewport) {
    this.issues.push({
      category,
      description,
      viewport,
      timestamp: new Date().toISOString()
    });
    console.log(`    ⚠️  ${category}: ${description}`);
  }

  async generateSimpleReport() {
    console.log('\n📊 Generating UI Inspection Report...\n');

    // Group issues by category
    const groupedIssues = this.issues.reduce((acc, issue) => {
      if (!acc[issue.category]) {
        acc[issue.category] = [];
      }
      acc[issue.category].push(issue);
      return acc;
    }, {});

    // Generate simplified report
    let report = '# Flutter Home Loan Advisor - UI Inspection Report\n\n';
    report += `**Generated:** ${new Date().toISOString()}\n`;
    report += `**Total Issues Found:** ${this.issues.length}\n\n`;

    // Summary by viewport
    const viewportSummary = this.issues.reduce((acc, issue) => {
      acc[issue.viewport] = (acc[issue.viewport] || 0) + 1;
      return acc;
    }, {});

    report += '## Issues by Viewport\n\n';
    if (Object.keys(viewportSummary).length === 0) {
      report += 'No major issues found! 🎉\n\n';
    } else {
      Object.entries(viewportSummary).forEach(([viewport, count]) => {
        report += `- **${viewport}**: ${count} issues\n`;
      });
      report += '\n';
    }

    // Issues by category
    if (Object.keys(groupedIssues).length > 0) {
      report += '## Issues by Category\n\n';
      Object.entries(groupedIssues).forEach(([category, issues]) => {
        report += `### ${category} (${issues.length} issues)\n\n`;
        
        issues.forEach((issue, index) => {
          report += `**${index + 1}. ${issue.viewport}**\n`;
          report += `${issue.description}\n\n`;
        });
      });
    }

    // Screenshots reference
    report += '## Screenshots Captured\n\n';
    report += 'Screenshots have been captured for:\n';
    report += '- Initial load for each viewport\n';
    report += '- Mid-scroll and bottom-scroll positions (when applicable)\n';
    report += '- Form interactions (when applicable)\n\n';
    report += `All screenshots saved to: \`${this.screenshotsDir}\`\n\n`;

    // Recommendations
    report += '## Recommendations\n\n';
    if (this.issues.length === 0) {
      report += '✅ Great job! No major UI issues were found.\n\n';
      report += 'The app appears to be responsive and working well across different screen sizes.\n';
    } else {
      report += '### Priority Fixes\n\n';
      
      const highPriorityCategories = ['Element Overflow', 'Small Touch Target', 'Horizontal Scroll'];
      const highPriorityIssues = this.issues.filter(issue => 
        highPriorityCategories.includes(issue.category)
      );
      
      if (highPriorityIssues.length > 0) {
        report += 'These issues should be addressed first as they significantly impact usability:\n\n';
        highPriorityIssues.forEach((issue, index) => {
          report += `${index + 1}. **${issue.category}** (${issue.viewport}): ${issue.description}\n`;
        });
      } else {
        report += 'No critical issues found that would block user interaction.\n';
      }
    }

    // Write report to file
    const reportPath = path.join(__dirname, 'ui-inspection-report.md');
    await fs.writeFile(report, reportPath);
    
    console.log(`📝 Report saved to: ${reportPath}`);
    console.log(`📸 Screenshots saved to: ${this.screenshotsDir}`);
    
    // Print summary to console
    console.log('\n🎯 INSPECTION SUMMARY');
    console.log('====================');
    console.log(`Total Issues: ${this.issues.length}`);
    
    if (Object.keys(viewportSummary).length > 0) {
      Object.entries(viewportSummary).forEach(([viewport, count]) => {
        console.log(`${viewport}: ${count} issues`);
      });
    } else {
      console.log('No major issues found! 🎉');
    }
    
    if (Object.keys(groupedIssues).length > 0) {
      console.log('\nTop Issue Categories:');
      Object.entries(groupedIssues)
        .sort(([,a], [,b]) => b.length - a.length)
        .slice(0, 5)
        .forEach(([category, issues]) => {
          console.log(`- ${category}: ${issues.length}`);
        });
    }
    
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
  const inspector = new SimpleUIInspector();
  
  try {
    await inspector.init();
    await inspector.inspectApp();
    await inspector.generateSimpleReport();
  } catch (error) {
    console.error('Inspection failed:', error);
  } finally {
    await inspector.cleanup();
  }
}

// Check if script is run directly
if (require.main === module) {
  main().catch(console.error);
}

module.exports = { SimpleUIInspector, main };