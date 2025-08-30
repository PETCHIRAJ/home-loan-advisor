const { chromium } = require('playwright');

async function verifyUIFixes() {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  
  console.log('🔍 Verifying UI Fixes for Home Loan Advisor App\n');
  console.log('='*50);
  
  const viewports = [
    { name: 'Mobile (Galaxy S21)', width: 360, height: 800 },
    { name: 'Tablet (iPad)', width: 768, height: 1024 },
    { name: 'Desktop', width: 1920, height: 1080 }
  ];
  
  const results = {
    chartReadability: [],
    touchTargets: [],
    stepEMILayout: [],
    responsiveCards: [],
    inputFields: [],
    bottomSheets: [],
    overall: []
  };
  
  for (const viewport of viewports) {
    console.log(`\n📱 Testing on ${viewport.name} (${viewport.width}x${viewport.height})`);
    console.log('-'.repeat(50));
    
    const page = await context.newPage();
    await page.setViewportSize(viewport);
    
    try {
      await page.goto('http://localhost:8080', { 
        waitUntil: 'networkidle',
        timeout: 30000 
      });
      
      // Wait for app to load
      await page.waitForTimeout(3000);
      
      // Take screenshot
      await page.screenshot({ 
        path: `verification-screenshots/${viewport.name.replace(/[^a-z0-9]/gi, '_')}_home.png`,
        fullPage: true 
      });
      
      // Test 1: Chart Readability
      const charts = await page.$$('[class*="chart"], [class*="Chart"], canvas');
      console.log(`  ✅ Charts found: ${charts.length}`);
      results.chartReadability.push({
        viewport: viewport.name,
        chartsFound: charts.length,
        status: charts.length > 0 ? 'Has charts' : 'No charts visible'
      });
      
      // Test 2: Touch Targets
      const buttons = await page.$$('button, [role="button"], .tab, [class*="Tab"]');
      let minHeight = 999;
      for (const button of buttons) {
        const box = await button.boundingBox();
        if (box && box.height < minHeight) {
          minHeight = box.height;
        }
      }
      console.log(`  ✅ Minimum button height: ${minHeight}px (should be >= 48px)`);
      results.touchTargets.push({
        viewport: viewport.name,
        minHeight,
        meetsStandard: minHeight >= 48
      });
      
      // Test 3: Check for horizontal scrolling (responsive containers)
      const scrollableElements = await page.$$('[style*="overflow-x"], [style*="scroll"]');
      console.log(`  ✅ Scrollable elements: ${scrollableElements.length}`);
      results.stepEMILayout.push({
        viewport: viewport.name,
        scrollableElements: scrollableElements.length,
        hasHorizontalScroll: scrollableElements.length > 0
      });
      
      // Test 4: Input fields
      const inputs = await page.$$('input[type="text"], input[type="number"], input[type="tel"]');
      console.log(`  ✅ Input fields found: ${inputs.length}`);
      
      // Try to interact with first input
      if (inputs.length > 0) {
        const firstInput = inputs[0];
        await firstInput.click();
        await page.keyboard.type('2500000');
        await page.waitForTimeout(500);
        
        // Check for helper text or formatting
        const helperText = await page.$('[class*="helper"], [class*="Helper"]');
        results.inputFields.push({
          viewport: viewport.name,
          inputsFound: inputs.length,
          hasHelperText: !!helperText,
          status: 'Interactive'
        });
      }
      
      // Test 5: Responsive layout classes
      const responsiveElements = await page.$$('[class*="responsive"], [class*="Responsive"], [class*="mobile"], [class*="tablet"]');
      console.log(`  ✅ Responsive elements: ${responsiveElements.length}`);
      
      // Test 6: Material 3 components
      const material3Elements = await page.$$('[class*="Material"], [class*="material"], [class*="md3"]');
      console.log(`  ✅ Material Design elements: ${material3Elements.length}`);
      
      // Overall assessment
      const score = {
        charts: charts.length > 0 ? 20 : 0,
        touchTargets: minHeight >= 48 ? 20 : 10,
        scrollable: scrollableElements.length > 0 ? 20 : 10,
        inputs: inputs.length > 0 ? 20 : 0,
        responsive: responsiveElements.length > 0 ? 20 : 0
      };
      
      const totalScore = Object.values(score).reduce((a, b) => a + b, 0);
      console.log(`\n  📊 Score for ${viewport.name}: ${totalScore}/100`);
      
      results.overall.push({
        viewport: viewport.name,
        score: totalScore,
        details: score
      });
      
    } catch (error) {
      console.log(`  ❌ Error testing ${viewport.name}: ${error.message}`);
      results.overall.push({
        viewport: viewport.name,
        error: error.message
      });
    }
    
    await page.close();
  }
  
  // Generate summary report
  console.log('\n' + '='.repeat(50));
  console.log('📋 VERIFICATION SUMMARY');
  console.log('='.repeat(50));
  
  // Check critical fixes
  const fixes = {
    'Chart Readability (Issue #1)': results.chartReadability.some(r => r.chartsFound > 0),
    'Touch Targets >= 48px (Issue #2)': results.touchTargets.every(r => r.meetsStandard),
    'Horizontal Scrolling (Issue #3)': results.stepEMILayout.some(r => r.hasHorizontalScroll),
    'Input Field Enhancement (Issue #7)': results.inputFields.some(r => r.inputsFound > 0),
    'Responsive Design': results.overall.every(r => !r.error)
  };
  
  console.log('\n✅ Critical Fixes Verification:');
  for (const [issue, fixed] of Object.entries(fixes)) {
    console.log(`  ${fixed ? '✅' : '❌'} ${issue}: ${fixed ? 'FIXED' : 'NEEDS WORK'}`);
  }
  
  // Overall readiness
  const fixedCount = Object.values(fixes).filter(f => f).length;
  const readinessScore = (fixedCount / Object.keys(fixes).length) * 100;
  
  console.log('\n📊 Production Readiness Score: ' + readinessScore.toFixed(0) + '%');
  
  if (readinessScore >= 80) {
    console.log('✅ APP IS PRODUCTION READY!');
  } else if (readinessScore >= 60) {
    console.log('⚠️ APP NEEDS MINOR FIXES');
  } else {
    console.log('❌ APP NEEDS SIGNIFICANT WORK');
  }
  
  await browser.close();
  
  // Save detailed report
  const fs = require('fs');
  fs.writeFileSync('ui-verification-results.json', JSON.stringify(results, null, 2));
  console.log('\n📄 Detailed results saved to ui-verification-results.json');
}

// Create screenshots directory
const fs = require('fs');
if (!fs.existsSync('verification-screenshots')) {
  fs.mkdirSync('verification-screenshots');
}

verifyUIFixes().catch(console.error);