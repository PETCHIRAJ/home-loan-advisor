const { chromium } = require('playwright');
const fs = require('fs').promises;
const path = require('path');

const APP_URL = 'http://localhost:8888';

async function performManualInspection() {
  console.log('🔍 Starting detailed manual inspection...\n');

  const browser = await chromium.launch({
    headless: false, // Keep browser open for manual inspection
    slowMo: 1000
  });

  const context = await browser.newContext({
    viewport: { width: 375, height: 667 } // Start with mobile
  });

  const page = await context.newPage();

  // Enable console logging
  page.on('console', (msg) => {
    console.log(`🖥️  Console ${msg.type()}: ${msg.text()}`);
  });

  page.on('pageerror', (error) => {
    console.log(`❌ Page Error: ${error.message}`);
  });

  try {
    console.log('📱 Navigating to Flutter app...');
    await page.goto(APP_URL, { waitUntil: 'networkidle' });
    
    // Wait for Flutter to fully load
    console.log('⏳ Waiting for Flutter to load...');
    await page.waitForTimeout(10000);

    // Check current DOM state
    console.log('🔍 Analyzing current DOM state...');
    const domAnalysis = await page.evaluate(() => {
      const body = document.body;
      const flutterView = document.querySelector('flutter-view');
      const canvases = document.querySelectorAll('canvas');
      const semanticsHost = document.querySelector('flt-semantics-host');
      
      // Get all text content
      const allText = body.innerText || body.textContent || '';
      
      // Find all interactive elements
      const buttons = document.querySelectorAll('button, [role="button"], [onclick]');
      const inputs = document.querySelectorAll('input, textarea, [contenteditable]');
      const links = document.querySelectorAll('a[href]');
      
      // Check for Flutter-specific elements
      const flutterElements = document.querySelectorAll('[data-semantics-role], [aria-label*="flutter"]');
      
      return {
        hasFlutterView: !!flutterView,
        canvasCount: canvases.length,
        hasSemanticsHost: !!semanticsHost,
        bodyTextLength: allText.length,
        bodyTextPreview: allText.substring(0, 200),
        buttonCount: buttons.length,
        inputCount: inputs.length,
        linkCount: links.length,
        flutterElementCount: flutterElements.length,
        bodyHTML: body.innerHTML.substring(0, 500) + '...',
        windowSize: {
          width: window.innerWidth,
          height: window.innerHeight
        }
      };
    });

    console.log('📊 DOM Analysis Results:');
    console.log(`  Flutter View: ${domAnalysis.hasFlutterView ? '✅ Found' : '❌ Not found'}`);
    console.log(`  Canvas elements: ${domAnalysis.canvasCount}`);
    console.log(`  Semantics host: ${domAnalysis.hasSemanticsHost ? '✅ Found' : '❌ Not found'}`);
    console.log(`  Interactive elements: ${domAnalysis.buttonCount} buttons, ${domAnalysis.inputCount} inputs, ${domAnalysis.linkCount} links`);
    console.log(`  Flutter elements: ${domAnalysis.flutterElementCount}`);
    console.log(`  Body text length: ${domAnalysis.bodyTextLength} characters`);
    console.log(`  Text preview: "${domAnalysis.bodyTextPreview}"`);
    console.log(`  Window size: ${domAnalysis.windowSize.width}x${domAnalysis.windowSize.height}`);

    // Take a detailed screenshot
    const screenshotDir = path.join(__dirname, 'detailed-inspection');
    await fs.mkdir(screenshotDir, { recursive: true });
    
    await page.screenshot({
      path: path.join(screenshotDir, 'mobile-detailed.png'),
      fullPage: true
    });

    // Try to interact with any found elements
    console.log('\n🎯 Attempting to interact with elements...');
    
    // Look for clickable elements with more specific selectors
    const clickableElements = await page.evaluate(() => {
      const elements = [];
      const selectors = [
        'button',
        '[role="button"]',
        'a[href]',
        '[onclick]',
        '.button',
        '.btn',
        '[data-testid*="button"]',
        'flutter-semantics-object',
        '[flt-semantics-role]'
      ];
      
      selectors.forEach(selector => {
        const found = document.querySelectorAll(selector);
        found.forEach((el, index) => {
          const rect = el.getBoundingClientRect();
          if (rect.width > 0 && rect.height > 0) {
            elements.push({
              selector: selector,
              index: index,
              text: el.textContent?.trim() || el.getAttribute('aria-label') || 'No text',
              position: { x: rect.x, y: rect.y, width: rect.width, height: rect.height },
              tagName: el.tagName,
              className: el.className
            });
          }
        });
      });
      
      return elements;
    });

    if (clickableElements.length > 0) {
      console.log(`  Found ${clickableElements.length} clickable elements:`);
      clickableElements.forEach((el, index) => {
        console.log(`    ${index + 1}. ${el.tagName} (${el.selector}): "${el.text}" at ${Math.round(el.position.x)},${Math.round(el.position.y)} (${Math.round(el.position.width)}x${Math.round(el.position.height)})`);
      });
      
      // Try clicking the first few elements
      for (let i = 0; i < Math.min(3, clickableElements.length); i++) {
        try {
          const element = clickableElements[i];
          console.log(`  🖱️  Attempting to click element ${i + 1}: ${element.text}`);
          
          await page.click(`${element.selector}:nth-of-type(${element.index + 1})`, { timeout: 3000 });
          await page.waitForTimeout(2000);
          
          // Take screenshot after click
          await page.screenshot({
            path: path.join(screenshotDir, `after-click-${i + 1}.png`),
            fullPage: true
          });
          
          console.log(`    ✅ Click successful`);
          
        } catch (error) {
          console.log(`    ❌ Click failed: ${error.message.split('.')[0]}`);
        }
      }
    } else {
      console.log('  ⚠️  No clickable elements found');
    }

    // Test different viewport sizes
    console.log('\n📐 Testing responsive behavior...');
    
    const viewports = [
      { name: 'Large Mobile', width: 414, height: 896 },
      { name: 'Tablet Portrait', width: 768, height: 1024 },
      { name: 'Tablet Landscape', width: 1024, height: 768 },
      { name: 'Desktop', width: 1920, height: 1080 }
    ];

    for (const viewport of viewports) {
      console.log(`  📱 Testing ${viewport.name} (${viewport.width}x${viewport.height})`);
      
      await page.setViewportSize({ width: viewport.width, height: viewport.height });
      await page.waitForTimeout(2000);
      
      const responsiveAnalysis = await page.evaluate(() => {
        const body = document.body;
        return {
          scrollWidth: body.scrollWidth,
          scrollHeight: body.scrollHeight,
          clientWidth: body.clientWidth,
          clientHeight: body.clientHeight,
          windowWidth: window.innerWidth,
          windowHeight: window.innerHeight,
          hasHorizontalScroll: body.scrollWidth > window.innerWidth,
          hasVerticalScroll: body.scrollHeight > window.innerHeight
        };
      });
      
      console.log(`    Content: ${responsiveAnalysis.scrollWidth}x${responsiveAnalysis.scrollHeight}, Viewport: ${responsiveAnalysis.windowWidth}x${responsiveAnalysis.windowHeight}`);
      
      if (responsiveAnalysis.hasHorizontalScroll) {
        console.log(`    ⚠️  Horizontal scroll detected`);
      }
      
      await page.screenshot({
        path: path.join(screenshotDir, `${viewport.name.toLowerCase().replace(' ', '-')}.png`),
        fullPage: true
      });
    }

    console.log('\n✅ Manual inspection completed!');
    console.log(`📸 Detailed screenshots saved to: ${screenshotDir}`);
    
    // Keep browser open for manual inspection
    console.log('\n🔍 Browser will remain open for manual inspection...');
    console.log('🛑 Close the browser when done, or press Ctrl+C to exit');
    
    // Wait indefinitely (until user closes browser or Ctrl+C)
    await page.waitForTimeout(300000); // 5 minutes max

  } catch (error) {
    console.error('❌ Inspection failed:', error);
  } finally {
    await browser.close();
  }
}

// Run the manual inspection
performManualInspection().catch(console.error);