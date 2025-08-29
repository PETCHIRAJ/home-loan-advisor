import 'dart:math' as math;
import '../core/utils/loan_calculations.dart';

/// Comprehensive content repository for the 7 core Indian home loan strategies
///
/// This repository contains detailed calculations, explanations, scenarios, and
/// implementation guides for each strategy, designed specifically for Indian
/// home loan borrowers.
class IndianStrategiesContent {
  IndianStrategiesContent._();

  /// Standard loan for calculations: ₹50L @ 8.5% for 20 years
  static const _baseLoanAmount = 5000000.0; // ₹50L
  static const _baseInterestRate = 8.5; // 8.5%
  static const _baseTenureYears = 20; // 20 years

  /// Calculate base EMI for reference
  static double get _baseEMI => LoanCalculations.calculateEMI(
        loanAmount: _baseLoanAmount,
        annualInterestRate: _baseInterestRate,
        tenureYears: _baseTenureYears,
      );

  /// 1. EXTRA EMI YEARLY (13th EMI) STRATEGY
  ///
  /// Pay one additional EMI per year to save lakhs in interest
  static Map<String, dynamic> get extraEMIStrategy => {
        'id': 'extra_emi_yearly',
        'title': 'Extra EMI Yearly (13th EMI)',
        'heroSavings': _calculateExtraEMIHeroSavings(),
        'shortDescription':
            'Pay 13 EMIs instead of 12 every year to save ₹${_formatLakhs(_calculateExtraEMIHeroSavings()['interestSaved']!)} and finish ${_calculateExtraEMIHeroSavings()['timeSavedYears']!.toStringAsFixed(1)} years early',

        'detailedExplanation': '''
The Extra EMI strategy is one of the most powerful yet simple ways to save on your home loan. By paying just one additional EMI per year (making it 13 EMIs instead of 12), you can save massive amounts in interest.

**How it Works:**
- Your regular EMI: ₹${_formatINR(_baseEMI)}
- Annual bonus or savings: Pay one extra EMI of ₹${_formatINR(_baseEMI)}
- This extra amount goes directly to principal reduction
- Compound effect saves years of interest payments

**Why it's So Effective:**
- Every rupee paid towards principal saves future interest
- Early in the loan, even small principal payments have massive impact
- The 13th EMI technique is psychologically easier than increasing monthly EMI
- Uses annual bonuses effectively instead of lifestyle inflation
    ''',

        'impactAnalysis': _getExtraEMIImpactAnalysis(),

        'eligibilityWhenWorks': [
          'You receive annual bonus or increment',
          'Have stable income with ability to save for extra EMI',
          'Loan is in first 10 years (maximum impact)',
          'No immediate liquidity needs for the extra EMI amount',
          'Bank allows prepayment without penalties',
        ],

        'whenItWontWork': [
          'Tight monthly cash flow with no savings capacity',
          'Bank charges high prepayment penalties (>2%)',
          'Already in last 5 years of loan tenure',
          'Better investment opportunities with higher returns',
          'Emergency fund is not adequate (maintain 6-12 months expenses)',
        ],

        'implementationGuide': [
          '**Step 1: Plan Early (January)**\n- Calculate one EMI amount: ₹${_formatINR(_baseEMI)}\n- Set up automatic transfer of ₹${_formatINR(_baseEMI / 12)} monthly to savings',
          '**Step 2: Save Throughout Year**\n- Create separate savings account for "13th EMI Fund"\n- Use automatic transfers to build the amount\n- Consider using annual bonus if available in December',
          '**Step 3: Execute in December**\n- Inform bank about principal prepayment (not advance EMI)\n- Make payment online or visit branch\n- Specify "principal reduction" clearly in payment details',
          '**Step 4: Verify Impact**\n- Get updated loan statement within 30 days\n- Verify principal balance has reduced by full extra EMI amount\n- Note the reduced tenure or EMI (as per your choice)',
          '**Step 5: Repeat Annually**\n- Make this a yearly habit\n- Increase extra EMI amount with salary increments\n- Track cumulative savings every year',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            'Most banks allow 1 free prepayment per year',
            'Check if charges apply after free limit',
            'Government banks typically have lower charges',
            'Private banks may have different terms',
          ],
          'documentation': [
            'Keep prepayment receipts for tax purposes',
            'Get updated amortization schedule',
            'Verify principal application within 30 days',
            'Request revised loan statement',
          ],
          'bankSpecificTips': [
            '**SBI**: Free partial prepayment once per year',
            '**HDFC**: No charges for floating rate loans',
            '**ICICI**: Online prepayment often cheaper than branch',
            '**Axis**: Check for quarterly charge-free windows',
          ],
        },

        'taxImplications': [
          'Extra principal payment qualifies for 80C deduction (up to ₹1.5L limit)',
          'Reduced interest means less 24(b) tax benefit',
          'Net tax impact usually still favorable',
          'Keep all payment receipts for ITR filing',
          'Coordinate with other 80C investments for optimal planning',
        ],

        'scenarios': _getExtraEMIScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            '5% Annual Step-up: Increase both regular EMI and extra EMI by 5% yearly',
            'Round-up EMI: Round up monthly EMI AND pay 13th EMI',
            'Festival Prepayment: Use festival bonuses for mid-year prepayments',
          ],
          'avoidCombiningWith': [
            'Balance Transfer (do one at a time)',
            'PF Withdrawal (may create liquidity issues)',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Low Risk**: Uses surplus income, doesn\'t affect monthly budget',
            'Liquidity impact: Reduces cash available for emergencies',
            'Opportunity cost: Money could be invested elsewhere',
          ],
          'implementationChallenges': [
            'Requires discipline to save throughout year',
            'Temptation to use bonus money for other purposes',
            'Bank may not apply payment correctly without proper instruction',
          ],
          'marketTimingRisks': [
            'Interest rates may fall (making prepayment less attractive)',
            'Inflation may reduce real value of saved amount',
            'Property appreciation might outpace loan savings',
          ],
        },

        'prioritizationScore': 95, // Very high priority
        'difficultyLevel': 2, // Medium difficulty
        'timeToImplement': '1 month setup + annual execution',
      };

  /// 2. 5% ANNUAL STEP-UP STRATEGY
  ///
  /// Increase EMI by 5% every year to dramatically reduce loan burden
  static Map<String, dynamic> get stepUpStrategy => {
        'id': 'annual_step_up',
        'title': '5% Annual Step-Up Strategy',
        'heroSavings': _calculateStepUpHeroSavings(),
        'shortDescription':
            'Increase EMI by 5% annually to save ₹${_formatLakhs(_calculateStepUpHeroSavings()['interestSaved']!)} and finish ${_calculateStepUpHeroSavings()['timeSavedYears']!.toStringAsFixed(1)} years early',

        'detailedExplanation': '''
The 5% Annual Step-Up strategy leverages your growing income to systematically reduce your loan burden. By increasing your EMI by just 5% each year, you can achieve massive savings.

**How it Works:**
- Year 1 EMI: ₹${_formatINR(_baseEMI)}
- Year 2 EMI: ₹${_formatINR(_baseEMI * 1.05)} (+5%)
- Year 3 EMI: ₹${_formatINR(_baseEMI * 1.1025)} (+5%)
- And so on...

**Why 5% is the Magic Number:**
- Average salary increment in India: 8-12% annually
- 5% EMI increase leaves room for lifestyle improvement
- Inflation adjustment keeps real burden manageable
- Compound effect on principal reduction is massive

**Psychology Behind Success:**
- Gradual increase is easier to absorb than lump sum
- Aligns with natural income growth expectations
- Creates automatic savings discipline
- Reduces loan burden faster than inflation increases it
    ''',

        'impactAnalysis': _getStepUpImpactAnalysis(),

        'eligibilityWhenWorks': [
          'Regular annual increments (8% or higher)',
          'Stable career growth trajectory',
          'Current EMI is less than 30% of income',
          'No major lifestyle changes expected (marriage, kids, etc.)',
          'Loan tenure is more than 10 years remaining',
        ],

        'whenItWontWork': [
          'Inconsistent income or job insecurity',
          'EMI already exceeds 40% of monthly income',
          'Major expenses coming up (children\'s education, marriage)',
          'Better guaranteed investment returns available (>9%)',
          'Planning career break or business venture',
        ],

        'implementationGuide': [
          '**Step 1: Income Analysis (Month 1)**\n- Review last 3 years salary increments\n- Calculate average annual growth rate\n- Ensure current EMI is <30% of monthly income\n- Project next year\'s expected income',
          '**Step 2: Set Up Automatic Increases**\n- Most banks don\'t offer auto step-up\n- Set calendar reminders for annual EMI increase\n- Plan increase timing with appraisal/increment cycle',
          '**Step 3: Year 1 Implementation**\n- Calculate 5% increase: New EMI = ₹${_formatINR(_baseEMI * 1.05)}\n- Submit EMI increase request to bank\n- Update NACH/auto-debit mandate\n- Ensure adequate bank balance',
          '**Step 4: Monitor and Adjust**\n- Track EMI-to-income ratio annually\n- Adjust percentage if income growth varies\n- Skip a year if income stagnates or decreases',
          '**Step 5: Accelerate When Possible**\n- Increase by 8-10% in high increment years\n- Reduce to 3% in low growth years\n- Make it flexible based on financial situation',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            'Most banks don\'t charge for EMI increase requests',
            'NACH mandate changes may have small processing fee',
            'Online requests often processed free of cost',
            'Branch visits may involve documentation charges',
          ],
          'documentation': [
            'Submit revised EMI request in writing',
            'Update auto-debit mandate annually',
            'Get updated loan schedule after each increase',
            'Maintain records for tax purposes',
          ],
          'bankSpecificTips': [
            '**HDFC**: Offers online EMI increase facility',
            '**SBI**: May require branch visit for first increase',
            '**ICICI**: Mobile banking allows EMI modifications',
            '**Axis**: Customer care can process increases over phone',
          ],
        },

        'taxImplications': [
          'Higher EMI means more principal payment (80C benefits)',
          'Reduced interest component (less 24b benefits)',
          'Net tax impact is usually neutral to positive',
          'Keep EMI payment receipts for tax filing',
          'Plan timing with other 80C investments',
        ],

        'scenarios': _getStepUpScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            'Extra EMI Strategy: Step up both regular and 13th EMI',
            'Round-up EMI: Step up the rounded amount',
            'Tax Benefit Optimization: Time increases for maximum 80C benefit',
          ],
          'avoidCombiningWith': [
            'Balance Transfer during step-up years (timing conflicts)',
            'Major prepayments (double impact on cash flow)',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Medium Risk**: Requires sustained income growth',
            'Cash flow pressure if income doesn\'t grow as expected',
            'May impact ability to handle financial emergencies',
          ],
          'implementationChallenges': [
            'Requires annual discipline and tracking',
            'Bank processes may be slow for EMI increases',
            'Temptation to skip increases in difficult years',
          ],
          'marketTimingRisks': [
            'Economic downturns may affect salary growth',
            'Interest rate increases may compound EMI burden',
            'Inflation may outpace salary increments',
          ],
        },

        'prioritizationScore': 90, // High priority
        'difficultyLevel': 3, // Medium-high difficulty
        'timeToImplement': '2 weeks setup + annual reviews',
      };

  /// 3. ROUND-UP EMI STRATEGY
  ///
  /// Round your EMI to the nearest higher thousand for effortless savings
  static Map<String, dynamic> get roundUpStrategy => {
        'id': 'round_up_emi',
        'title': 'Round-Up EMI Strategy',
        'heroSavings': _calculateRoundUpHeroSavings(),
        'shortDescription':
            'Round EMI from ₹${_formatINR(_baseEMI)} to ₹${_formatINR(_getRoundedEMI())} to save ₹${_formatLakhs(_calculateRoundUpHeroSavings()['interestSaved']!)} with minimal effort',

        'detailedExplanation': '''
The Round-Up EMI strategy is the easiest way to start saving on your home loan. Simply round your EMI to the nearest thousand and let the small extra amount compound into massive savings.

**How it Works:**
- Your current EMI: ₹${_formatINR(_baseEMI)}
- Rounded up EMI: ₹${_formatINR(_getRoundedEMI())}
- Extra amount per month: ₹${_formatINR(_getRoundedEMI() - _baseEMI)}
- This extra amount goes directly towards principal

**Why Round Numbers Work:**
- Psychologically easier to manage round amounts
- Simpler for budgeting and tracking
- Bank account balances look cleaner
- Creates unconscious savings habit
- No lifestyle impact due to small amounts

**The Compound Magic:**
- Small monthly extra becomes big annual impact
- Earlier principal payments save exponentially more interest
- Creates positive financial momentum
- Gateway habit for bigger loan optimization strategies
    ''',

        'impactAnalysis': _getRoundUpImpactAnalysis(),

        'eligibilityWhenWorks': [
          'Any EMI amount that\'s not already rounded',
          'Stable monthly income to handle small increase',
          'EMI is less than 40% of monthly income',
          'Want to start loan optimization with minimal effort',
          'Bank allows EMI increase without hassles',
        ],

        'whenItWontWork': [
          'EMI is already rounded to nearest thousand',
          'Very tight monthly budget with no wiggle room',
          'Planning major expenses or financial changes',
          'EMI increase may trigger affordability concerns',
          'Better to focus on larger prepayment strategies',
        ],

        'implementationGuide': [
          '**Step 1: Calculate Round-Up Amount**\n- Current EMI: ₹${_formatINR(_baseEMI)}\n- Next thousand: ₹${_formatINR(_getRoundedEMI())}\n- Extra per month: ₹${_formatINR(_getRoundedEMI() - _baseEMI)}\n- Ensure this fits comfortably in budget',
          '**Step 2: Contact Your Bank**\n- Call customer service or visit branch\n- Request EMI increase from current to rounded amount\n- Specify increase should go towards principal reduction\n- Get confirmation in writing',
          '**Step 3: Update Payment Method**\n- Modify NACH/auto-debit mandate\n- Ensure bank account has adequate balance\n- Set up surplus buffer for first few months\n- Update any standing instructions',
          '**Step 4: Monitor Implementation**\n- Check first rounded EMI deduction\n- Verify extra amount is applied to principal\n- Get updated amortization schedule\n- Note the reduced tenure or interest',
          '**Step 5: Optimize Further (Optional)**\n- After 6 months, consider bigger round-up\n- Combine with other strategies for more impact\n- Use as foundation for annual increment allocations',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            'Usually no charges for EMI increase requests',
            'NACH mandate modification may cost ₹50-200',
            'Some banks process first increase free',
            'Check bank policy before implementing',
          ],
          'documentation': [
            'Written request for EMI modification',
            'Updated NACH form with new EMI amount',
            'Specify "principal reduction" purpose clearly',
            'Get updated loan schedule after implementation',
          ],
          'bankSpecificTips': [
            '**SBI**: Can be done online via internet banking',
            '**HDFC**: Call customer care for instant processing',
            '**ICICI**: Use mobile app for EMI modifications',
            '**Kotak**: Branch visit recommended for clarity',
          ],
        },

        'taxImplications': [
          'Extra principal payment counts towards 80C limit',
          'Minimal impact on overall tax planning',
          'Keep enhanced EMI receipts for tax filing',
          'Coordinate with other 80C investments if near ₹1.5L limit',
        ],

        'scenarios': _getRoundUpScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            'All other strategies - perfect foundation',
            '5% Step-up: Round up the stepped-up amount each year',
            'Extra EMI: Round-up monthly + 13th EMI annually',
            'Festival Prepayments: Use round-up as baseline, add more during festivals',
          ],
          'avoidCombiningWith': [
            'None - this strategy complements everything',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Very Low Risk**: Minimal impact on monthly budget',
            'Negligible liquidity impact',
            'Easy to reverse if needed',
          ],
          'implementationChallenges': [
            'Bank may not apply extra amount to principal correctly',
            'Need to verify implementation carefully',
            'Very small impact may not feel motivating initially',
          ],
          'marketTimingRisks': [
            'Almost no market timing risk',
            'Works well in all interest rate environments',
            'Inflation actually helps make the amount feel smaller over time',
          ],
        },

        'prioritizationScore': 85, // High priority due to ease
        'difficultyLevel': 1, // Very easy
        'timeToImplement': '1 week',
      };

  /// 4. FESTIVAL/BONUS PREPAYMENT STRATEGY
  ///
  /// Use festival bonuses and Diwali money for strategic prepayments
  static Map<String, dynamic> get festivalPrepaymentStrategy => {
        'id': 'festival_prepayment',
        'title': 'Festival/Bonus Prepayment Strategy',
        'heroSavings': _calculateFestivalPrepaymentHeroSavings(),
        'shortDescription':
            'Use festival bonuses and Diwali money for prepayments to save ₹${_formatLakhs(_calculateFestivalPrepaymentHeroSavings()['interestSaved']!)} over loan tenure',

        'detailedExplanation': '''
The Festival/Bonus Prepayment strategy leverages Indian festivals and bonus culture to systematically reduce your home loan. Instead of lifestyle spending, redirect festival bonuses towards wealth building.

**Indian Festival Opportunities:**
- **Diwali Bonus**: 1-2 months salary (₹50,000 - ₹2,00,000)
- **Performance Bonuses**: Quarterly/annual bonuses
- **Festival Allowances**: Company-specific festival bonuses
- **Gift Money**: Cash gifts received during festivals
- **Increment Arrears**: Backdated salary increases

**How it Works:**
- Identify all annual bonus/festival money sources
- Set aside 50-70% for loan prepayment
- Use remaining for celebration and family needs
- Time prepayments for maximum tax benefits
- Create annual rhythm of debt reduction

**Cultural Integration:**
- Aligns with Indian joint family gift-giving culture
- Uses "extra" money instead of impacting monthly budget
- Creates positive association between festivals and wealth building
- Involves family in financial goal achievement
- Builds discipline without sacrifice
    ''',

        'impactAnalysis': _getFestivalPrepaymentImpactAnalysis(),

        'eligibilityWhenWorks': [
          'Receive regular festival bonuses or annual bonuses',
          'Family gives/receives cash gifts during festivals',
          'Performance-based additional income',
          'Want to use "windfall" money productively',
          'Bank allows multiple prepayments per year',
        ],

        'whenItWontWork': [
          'No bonus culture in your employment',
          'Festival expenses are very high, no surplus',
          'Bank charges high penalties for multiple prepayments',
          'Already using bonuses for other important goals',
          'Family obligations prevent redirecting festival money',
        ],

        'implementationGuide': [
          '**Step 1: Map Your Bonus Calendar**\n- List all annual bonuses and their typical amounts\n- Diwali bonus: ₹______\n- Performance bonus: ₹______\n- Festival gifts: ₹______\n- Other windfalls: ₹______\n- Total annual potential: ₹______',
          '**Step 2: Set Prepayment Allocation Rules**\n- Decide what percentage goes to prepayment (50-70%)\n- Example: From ₹1L Diwali bonus, ₹70K to loan, ₹30K for celebration\n- Get family buy-in for this allocation\n- Create separate "Festival Prepayment" savings account',
          '**Step 3: Optimize Timing**\n- **March prepayments**: Best for tax benefits\n- **December prepayments**: After bonus receipt\n- **Quarterly timing**: Spread impact across year\n- Coordinate with bank\'s charge-free windows',
          '**Step 4: Execute Systematically**\n- As soon as bonus is credited, transfer prepayment amount\n- Make prepayment within 30 days of receipt\n- Inform bank it\'s principal reduction, not advance EMI\n- Get receipt and updated loan schedule',
          '**Step 5: Track and Celebrate**\n- Maintain log of all festival prepayments\n- Calculate cumulative interest saved\n- Share progress with family during next festival\n- Use success to motivate larger prepayments',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            'Most banks allow 1-2 free prepayments per year',
            'Plan multiple bonuses around free prepayment windows',
            'Combine smaller bonuses to minimize charges',
            'Some banks waive charges during Diwali season',
          ],
          'documentation': [
            'Keep all prepayment receipts for tax filing',
            'Maintain festival prepayment register',
            'Get updated amortization schedule after each payment',
            'Take screenshot of loan balance reduction',
          ],
          'bankSpecificTips': [
            '**SBI**: Often waives charges during October-December',
            '**HDFC**: No charges for amounts >₹50,000',
            '**ICICI**: Free online prepayments on festival days',
            '**Axis**: Special Diwali campaigns with waived charges',
          ],
        },

        'taxImplications': [
          'Festival prepayments qualify for 80C deduction',
          'Time large prepayments before March 31 for tax benefits',
          'Reduced interest means less 24b benefit in subsequent years',
          'Keep all festival prepayment receipts organized',
          'Can help reach ₹1.5L 80C limit with other investments',
        ],

        'scenarios': _getFestivalPrepaymentScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            'Extra EMI Strategy: 13th EMI + festival prepayments = double impact',
            'Round-up EMI: Use festivals for larger additional prepayments',
            'Tax Benefit Optimization: Time festival prepayments for maximum 80C benefit',
          ],
          'avoidCombiningWith': [
            'Balance Transfer timing (may conflict with bonus cycles)',
            'Major investment plans using same bonus money',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Low-Medium Risk**: Uses surplus money, doesn\'t affect regular budget',
            'Festival expense management needed to create surplus',
            'Family expectations may conflict with prepayment goals',
          ],
          'implementationChallenges': [
            'Requires discipline to not use bonus for lifestyle spending',
            'Family coordination needed for gift money allocation',
            'Irregular bonus amounts make planning challenging',
          ],
          'marketTimingRisks': [
            'Economic downturns may affect bonus amounts',
            'Company performance may impact annual bonuses',
            'Festival expense inflation may reduce surplus available',
          ],
        },

        'prioritizationScore': 80, // Good priority for bonus receivers
        'difficultyLevel': 2, // Medium difficulty due to family coordination
        'timeToImplement':
            '1 month planning + execution during festival season',
      };

  /// 5. BALANCE TRANSFER STRATEGY
  ///
  /// Switch to a lower interest rate bank for massive savings
  static Map<String, dynamic> get balanceTransferStrategy => {
        'id': 'balance_transfer',
        'title': 'Balance Transfer Strategy',
        'heroSavings': _calculateBalanceTransferHeroSavings(),
        'shortDescription':
            'Transfer loan to lower rate bank and save ₹${_formatLakhs(_calculateBalanceTransferHeroSavings()['interestSaved']!)} over remaining tenure',

        'detailedExplanation': '''
Balance Transfer is the strategy of moving your existing home loan to another bank offering lower interest rates. Even a 0.5% reduction can save lakhs over the loan tenure.

**How Balance Transfer Works:**
- Current loan: ₹${_formatINR(_baseLoanAmount)} @ ${_baseInterestRate}% = ₹${_formatINR(_baseEMI)} EMI
- New bank offer: Same amount @ 8.0% = ₹${_formatINR(LoanCalculations.calculateEMI(loanAmount: _baseLoanAmount, annualInterestRate: 8.0, tenureYears: _baseTenureYears))} EMI
- Monthly savings: ₹${_formatINR(_baseEMI - LoanCalculations.calculateEMI(loanAmount: _baseLoanAmount, annualInterestRate: 8.0, tenureYears: _baseTenureYears))}
- Total tenure savings: ₹${_formatLakhs(_calculateBalanceTransferHeroSavings()['interestSaved']!)}

**Why Banks Offer Better Rates:**
- Competition for good customers
- Your improved credit profile since original loan
- Market interest rates may have fallen
- New bank wants to acquire proven borrowers
- Existing bank may counter with better terms

**Best Timing for Balance Transfer:**
- After 2-3 years of consistent payments
- When market rates have fallen significantly
- Credit score has improved substantially
- Major financial metrics have strengthened
- No immediate plans for other major loans
    ''',

        'impactAnalysis': _getBalanceTransferImpactAnalysis(),

        'eligibilityWhenWorks': [
          'Credit score improved significantly (>750)',
          'Consistent loan repayment history (no delays)',
          'Income has increased since original loan',
          'Market rates are 0.5%+ lower than current rate',
          'Remaining loan amount >₹25 lakhs (worthwhile transfer costs)',
        ],

        'whenItWontWork': [
          'Less than 2 years since loan origination',
          'Poor payment history or credit issues',
          'Remaining loan amount too small (<₹15 lakhs)',
          'Current rate is already market competitive',
          'Recent job change or income instability',
        ],

        'implementationGuide': [
          '**Step 1: Market Research (Month 1)**\n- Research current market rates from top 10 banks\n- Compare: SBI, HDFC, ICICI, Axis, Kotak, BoB, PNB, etc.\n- Note: Rates, processing fees, legal charges, prepayment terms\n- Create comparison spreadsheet',
          '**Step 2: Document Preparation**\n- Latest salary slips (3 months)\n- Bank statements (6 months)\n- IT returns (2 years)\n- Current loan statement with outstanding balance\n- Property documents and insurance papers\n- Credit report from CIBIL/Experian',
          '**Step 3: Application Process (Month 2)**\n- Apply to 3-4 banks simultaneously\n- Negotiate rates based on your improved profile\n- Compare total cost including processing fees\n- Get written approval with locked-in rates',
          '**Step 4: Cost-Benefit Analysis**\n- Calculate net savings after all transfer costs\n- Factor in: Processing fee, legal charges, valuation costs\n- Ensure break-even within 12-18 months\n- Consider rate reset terms for floating loans',
          '**Step 5: Execute Transfer (Month 3)**\n- Choose best offer with highest net savings\n- Complete legal formalities and documentation\n- Ensure smooth handover between banks\n- Verify new loan terms match approved offer\n- Get updated insurance nominations and paperwork',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            '**Processing Fee**: 0.5-1% of loan amount (₹25K-50K for ₹50L)',
            '**Legal & Valuation**: ₹5K-15K',
            '**Prepayment Charges**: Check current bank terms (0-3%)',
            '**Documentation**: ₹2K-5K',
            '**Total Transfer Cost**: ₹30K-70K typically',
          ],
          'documentation': [
            'Property title clearance (crucial)',
            'Insurance transfer and nomination updates',
            'All statutory clearances from current bank',
            'New bank legal and technical approval',
            'Updated property valuation',
          ],
          'bankSpecificTips': [
            '**SBI**: Best rates for salaried government employees',
            '**HDFC**: Good processing speed and service',
            '**ICICI**: Competitive for high-value loans',
            '**Kotak**: Often offers aggressive rates for acquisition',
            '**Axis**: Good for professionals and business owners',
          ],
        },

        'taxImplications': [
          'No impact on 80C/24b benefits (continue as before)',
          'Processing fees can be claimed as deduction in some cases',
          'Prepayment charges to current bank may reduce taxable income',
          'Time the transfer to optimize tax year benefits',
        ],

        'scenarios': _getBalanceTransferScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            'Post-Transfer Optimization: Implement other strategies with new lower EMI',
            'Round-up Strategy: Round up the new lower EMI',
            'Step-up Strategy: Increase the transferred loan EMI annually',
          ],
          'avoidCombiningWith': [
            'Major prepayments during transfer process',
            'Other loan applications during balance transfer',
            'Job changes during transfer process',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Medium Risk**: Involves legal processes and costs',
            'Upfront transfer costs need to be recovered',
            'New bank terms may have different prepayment rules',
            'Interest rate reset clauses in floating loans',
          ],
          'implementationChallenges': [
            'Complex paperwork and legal processes',
            'Coordination between two banks required',
            '3-4 month timeline with multiple touchpoints',
            'Property valuation and legal clearances needed',
          ],
          'marketTimingRisks': [
            'Interest rates may rise after transfer',
            'Current bank may counter-offer better terms',
            'New regulations may affect transfer process',
            'Economic conditions may affect approval',
          ],
        },

        'prioritizationScore':
            75, // Medium-high priority if rate difference is significant
        'difficultyLevel': 4, // High difficulty due to complexity
        'timeToImplement': '3-4 months',
      };

  /// 6. PF WITHDRAWAL PREPAYMENT STRATEGY
  ///
  /// Use PF withdrawal for home loan prepayment strategically
  static Map<String, dynamic> get pfWithdrawalStrategy => {
        'id': 'pf_withdrawal_prepayment',
        'title': 'PF Withdrawal Prepayment Strategy',
        'heroSavings': _calculatePFWithdrawalHeroSavings(),
        'shortDescription':
            'Use PF withdrawal of ₹${_formatLakhs(500000)} for prepayment to save ₹${_formatLakhs(_calculatePFWithdrawalHeroSavings()['interestSaved']!)} in total interest',

        'detailedExplanation': '''
The PF Withdrawal Prepayment strategy involves using your Provident Fund corpus strategically for home loan prepayment. This can be highly effective but requires careful analysis of opportunity costs.

**PF Withdrawal Rules for Home Loan:**
- Can withdraw PF for home purchase/construction after 5 years of service
- Partial withdrawal allowed for loan repayment
- Up to 36 months of salary or PF balance (whichever is lower)
- No tax on withdrawal if used for home loan within specified time
- Must submit loan documents and bank statements

**When PF Prepayment Makes Sense:**
- Current loan rate > PF earning rate (8.5% vs 8.1% typically)
- You have other retirement savings (NPS, PPF, mutual funds)
- Loan is in first 10 years (maximum impact period)
- No immediate liquidity needs for the withdrawn amount
- Tax-free withdrawal benefit available

**Analysis Framework:**
- Compare loan interest rate vs PF return rate
- Factor in tax implications of withdrawal
- Consider impact on retirement corpus
- Evaluate alternative investment opportunities
- Assess liquidity needs over next 5 years
    ''',

        'impactAnalysis': _getPFWithdrawalImpactAnalysis(),

        'eligibilityWhenWorks': [
          'PF service period >5 years (for withdrawal eligibility)',
          'Loan interest rate > PF earning rate',
          'Substantial PF corpus available (>₹5 lakhs)',
          'Other retirement savings are adequate',
          'No immediate need for emergency liquidity',
        ],

        'whenItWontWork': [
          'PF is your only retirement savings',
          'PF earning rate > loan interest rate',
          'Service period <5 years',
          'Planning job change (may affect PF continuity)',
          'Need liquidity for children\'s education or other goals',
        ],

        'implementationGuide': [
          '**Step 1: Eligibility Check**\n- Verify 5+ years of PF contributions\n- Check current PF balance on EPFO portal\n- Confirm withdrawal rules with HR department\n- Calculate maximum withdrawal allowed\n- Review loan prepayment terms with bank',
          '**Step 2: Financial Analysis**\n- Current PF balance: ₹______\n- Loan outstanding: ₹______\n- PF return rate: ____%\n- Loan interest rate: ____%\n- Net benefit calculation: ₹______',
          '**Step 3: Documentation Process**\n- Submit PF withdrawal application (Form 19/10C)\n- Provide loan account details and statements\n- Submit property documents as required\n- Get bank letter confirming prepayment purpose\n- Ensure all PAN and Aadhaar details are linked',
          '**Step 4: Execute Withdrawal & Prepayment**\n- PF amount typically credited within 30 days\n- Transfer amount immediately to loan account\n- Inform bank about principal reduction purpose\n- Get updated amortization schedule\n- Maintain records for tax compliance',
          '**Step 5: Retirement Planning Adjustment**\n- Reassess retirement corpus adequacy\n- Increase other savings to compensate\n- Consider additional NPS/PPF contributions\n- Review and adjust financial goals',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            'Usually no charges for PF-based prepayments',
            'Some banks offer special PF prepayment schemes',
            'May qualify for charge-free prepayment window',
            'Ensure no penalty on the loan prepayment amount',
          ],
          'documentation': [
            'PF withdrawal approval and credit proof',
            'Letter from bank confirming prepayment',
            'Updated loan schedule post-prepayment',
            'Tax exemption certificates if applicable',
          ],
          'bankSpecificTips': [
            '**SBI**: Has specific PF prepayment procedures',
            '**Government Banks**: Often have better PF integration',
            '**Private Banks**: May require additional documentation',
            '**PSU Banks**: Familiar with PF withdrawal processes',
          ],
        },

        'taxImplications': [
          'PF withdrawal for home loan is tax-exempt',
          'Must use amount within specified timeframe',
          'Prepayment qualifies for 80C benefits',
          'Reduced future interest means less 24b benefits',
          'Maintain all withdrawal and prepayment receipts',
        ],

        'scenarios': _getPFWithdrawalScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            'One-time strategy - use with other ongoing strategies',
            'Round-up EMI: After PF prepayment, implement ongoing optimizations',
            'Step-up Strategy: Use reduced EMI base for annual increases',
          ],
          'avoidCombiningWith': [
            'Other major withdrawals from retirement accounts',
            'Job changes during PF withdrawal process',
            'Major investment decisions using other PF amounts',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Medium-High Risk**: Depletes retirement corpus',
            'Opportunity cost of PF\'s long-term compounding',
            'Loss of PF\'s tax-exempt accumulation benefit',
            'Impact on retirement planning and goals',
          ],
          'implementationChallenges': [
            'EPFO processing can be slow (30-60 days)',
            'Complex documentation requirements',
            'Coordination between PF office, bank, and employer',
            'Tax compliance and exemption claiming',
          ],
          'marketTimingRisks': [
            'PF rates may increase after withdrawal',
            'Loan rates may decrease (reducing benefit)',
            'Inflation impact on retirement corpus',
            'Regulatory changes affecting PF withdrawals',
          ],
        },

        'prioritizationScore': 70, // Medium priority due to opportunity cost
        'difficultyLevel':
            3, // Medium-high difficulty due to process complexity
        'timeToImplement': '2-3 months (including PF processing time)',
      };

  /// 7. TAX BENEFIT OPTIMIZATION STRATEGY
  ///
  /// Maximize Section 80C and 24(b) benefits for optimal loan management
  static Map<String, dynamic> get taxOptimizationStrategy => {
        'id': 'tax_benefit_optimization',
        'title': 'Tax Benefit Optimization Strategy',
        'heroSavings': _calculateTaxOptimizationHeroSavings(),
        'shortDescription':
            'Optimize tax benefits to save ₹${_formatLakhs(_calculateTaxOptimizationHeroSavings()['annualTaxSaved']!)} annually and ₹${_formatLakhs(_calculateTaxOptimizationHeroSavings()['lifetimeTaxSaved']!)} over loan tenure',

        'detailedExplanation': '''
Tax Benefit Optimization is about maximizing your home loan's tax advantages under Section 80C (principal repayment) and 24(b) (interest payment). Proper optimization can save lakhs in taxes over the loan tenure.

**Section 80C Benefits (Principal Repayment):**
- Up to ₹1.5 lakh deduction annually
- Includes EMI principal component
- Also covers prepayments and extra EMI principal amounts
- Tax saving = Deduction × Tax Rate (30% for highest bracket)
- Maximum annual tax saving: ₹46,500 (30% of ₹1.5L)

**Section 24(b) Benefits (Interest Payment):**
- Up to ₹2 lakh deduction for interest paid
- No upper limit for business/profession income
- Self-occupied property: ₹2L limit
- Let-out property: No limit on interest deduction
- Tax saving = Deduction × Tax Rate

**Optimization Strategies:**
- Time prepayments to maximize 80C utilization
- Balance prepayments vs interest deductions
- Coordinate with spouse for dual benefits
- Plan loan structure for optimal tax efficiency
- Use prepayments strategically near year-end
    ''',

        'impactAnalysis': _getTaxOptimizationImpactAnalysis(),

        'eligibilityWhenWorks': [
          'You are in 20% or 30% tax bracket',
          'Currently not maximizing ₹1.5L Section 80C limit',
          'Annual interest payment is significant',
          'Have spouse who can also claim benefits (joint loan)',
          'Systematic approach to tax planning',
        ],

        'whenItWontWork': [
          'You are in lowest tax bracket (5% or nil tax)',
          'Already maximizing all available tax benefits',
          'Interest payments are very low (loan in final years)',
          'No systematic record-keeping capability',
          'Irregular income making tax planning difficult',
        ],

        'implementationGuide': [
          '**Step 1: Current Tax Benefit Audit**\n- Calculate current 80C utilization: ₹______\n- Calculate annual interest payment: ₹______\n- Current tax bracket: ____%\n- Annual tax saved from home loan: ₹______\n- Potential additional savings: ₹______',
          '**Step 2: Optimization Planning**\n- Gap in 80C limit: ₹1.5L - Current utilization\n- Plan prepayments to fill 80C gap\n- Time large prepayments before March 31\n- Coordinate with other 80C investments\n- Consider spouse\'s tax planning if joint loan',
          '**Step 3: Strategic Prepayment Timing**\n- **January-February**: Review year\'s 80C utilization\n- **March**: Make prepayments to maximize 80C before year-end\n- **April**: Plan next year\'s tax optimization\n- Throughout year: Track principal vs interest in EMIs',
          '**Step 4: Documentation & Record Keeping**\n- Maintain separate file for loan tax documents\n- Collect all EMI payment receipts/statements\n- Keep prepayment receipts separately\n- Get annual interest certificate from bank\n- Track month-wise principal and interest breakdown',
          '**Step 5: Annual Tax Filing Optimization**\n- Claim Section 80C for principal payments\n- Claim Section 24(b) for interest payments\n- Include prepayment amounts in 80C calculation\n- Coordinate with CA/tax advisor for optimal filing\n- Plan next year\'s strategy based on results',
        ],

        'bankConsiderations': {
          'chargesAndFees': [
            'No charges for tax-related documentation',
            'Annual interest certificates provided free',
            'Additional copies may have nominal charges',
            'Request detailed EMI breakdowns for better tracking',
          ],
          'documentation': [
            'Annual interest certificate (Form 16A format)',
            'Monthly/quarterly EMI statements',
            'Prepayment receipts with principal/interest split',
            'Loan account statement showing principal reductions',
          ],
          'bankSpecificTips': [
            '**All Banks**: Issue interest certificates by January 31',
            '**Online Banking**: Download statements for monthly tracking',
            '**Mobile Apps**: Most provide EMI breakdowns',
            '**Branch Services**: Can provide detailed amortization schedules',
          ],
        },

        'taxImplications': [
          '**Section 80C**: Principal payment deduction up to ₹1.5L',
          '**Section 24(b)**: Interest deduction up to ₹2L (self-occupied)',
          '**Joint Loan**: Both applicants can claim proportionate benefits',
          '**Prepayments**: Qualify for 80C in the year of payment',
          '**Record Keeping**: Essential for claiming maximum benefits',
        ],

        'scenarios': _getTaxOptimizationScenarios(),

        'combinationStrategy': {
          'worksWellWith': [
            'All other strategies - enhances tax efficiency of each',
            'Extra EMI Strategy: Time 13th EMI for tax optimization',
            'Festival Prepayments: Use for strategic 80C maximization',
            'Step-up Strategy: Increased EMI means more principal and 80C benefits',
          ],
          'avoidCombiningWith': [
            'None - tax optimization enhances all strategies',
          ],
        },

        'riskAssessment': {
          'financialRisks': [
            '**Very Low Risk**: Only optimization, no financial commitments',
            'Requires systematic tracking and documentation',
            'Tax law changes may affect benefits',
          ],
          'implementationChallenges': [
            'Requires detailed record-keeping discipline',
            'Need to coordinate with other 80C investments',
            'Tax planning requires annual review and adjustment',
            'Spouse coordination needed for joint loans',
          ],
          'marketTimingRisks': [
            'Tax law changes may reduce benefits',
            'Tax slab changes may affect optimization value',
            'Interest rate changes affect tax benefit calculations',
          ],
        },

        'prioritizationScore': 95, // Very high priority - no downside
        'difficultyLevel': 2, // Medium difficulty due to record-keeping needs
        'timeToImplement': '1 month setup + ongoing annual optimization',
      };

  /// Helper Methods for Calculations

  /// Calculate Extra EMI hero savings
  static Map<String, double> _calculateExtraEMIHeroSavings() {
    final extraPrincipal =
        _baseEMI; // One EMI amount as extra principal annually
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: _baseLoanAmount,
      annualInterestRate: _baseInterestRate,
      tenureYears: _baseTenureYears,
      extraPrincipal: extraPrincipal,
    );
    return {
      'interestSaved': result['interestSaved'] as double,
      'timeSavedYears': result['timeSaved'] as double,
      'extraAnnualPayment': extraPrincipal,
    };
  }

  /// Calculate Step-up hero savings (5% annual increase)
  static Map<String, double> _calculateStepUpHeroSavings() {
    // Simplified calculation for step-up strategy
    // This is approximate - actual calculation would require year-by-year analysis
    double totalExtraPayment = 0;
    double totalInterestSaved = 0;
    double currentEMI = _baseEMI;

    for (int year = 1; year <= 10; year++) {
      // Calculate for first 10 years
      currentEMI *= 1.05; // 5% increase
      double extraPayment = (currentEMI - _baseEMI) * 12;
      totalExtraPayment += extraPayment;

      // Approximate interest saved (simplified calculation)
      double interestSavedThisYear =
          extraPayment * (_baseInterestRate / 100) * (20 - year);
      totalInterestSaved += interestSavedThisYear;
    }

    return {
      'interestSaved':
          totalInterestSaved * 1.2, // Adjust for compounding effect
      'timeSavedYears': 4.5, // Approximate time saved
      'totalExtraPayments': totalExtraPayment,
    };
  }

  /// Calculate Round-up hero savings
  static Map<String, double> _calculateRoundUpHeroSavings() {
    final roundedEMI = _getRoundedEMI();
    final extraMonthly = roundedEMI - _baseEMI;
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: _baseLoanAmount,
      annualInterestRate: _baseInterestRate,
      tenureYears: _baseTenureYears,
      extraPrincipal: extraMonthly,
    );
    return {
      'interestSaved': result['interestSaved'] as double,
      'timeSavedYears': result['timeSaved'] as double,
      'extraMonthlyPayment': extraMonthly,
    };
  }

  /// Calculate Festival prepayment savings
  static Map<String, double> _calculateFestivalPrepaymentHeroSavings() {
    final annualBonusAmount = 100000.0; // ₹1L annual festival/bonus money
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: _baseLoanAmount,
      annualInterestRate: _baseInterestRate,
      tenureYears: _baseTenureYears,
      extraPrincipal: annualBonusAmount / 12, // Spread over monthly equivalent
    );
    return {
      'interestSaved': result['interestSaved'] as double,
      'timeSavedYears': result['timeSaved'] as double,
      'annualBonusAmount': annualBonusAmount,
    };
  }

  /// Calculate Balance Transfer savings
  static Map<String, double> _calculateBalanceTransferHeroSavings() {
    const newRate = 8.0; // Assuming 0.5% reduction
    final currentEMI = _baseEMI;
    final newEMI = LoanCalculations.calculateEMI(
      loanAmount: _baseLoanAmount,
      annualInterestRate: newRate,
      tenureYears: _baseTenureYears,
    );

    final monthlyDifference = currentEMI - newEMI;
    final totalSavings = monthlyDifference * _baseTenureYears * 12;
    const transferCosts = 50000.0; // Approximate transfer costs

    return {
      'interestSaved': totalSavings - transferCosts,
      'monthlySaving': monthlyDifference,
      'newEMI': newEMI,
      'transferCosts': transferCosts,
    };
  }

  /// Calculate PF Withdrawal prepayment savings
  static Map<String, double> _calculatePFWithdrawalHeroSavings() {
    const pfAmount = 500000.0; // ₹5L PF withdrawal
    final result = LoanCalculations.calculateExtraPaymentSavings(
      loanAmount: _baseLoanAmount,
      annualInterestRate: _baseInterestRate,
      tenureYears: _baseTenureYears,
      extraPrincipal:
          pfAmount / 12, // Spread over monthly equivalent for calculation
    );
    return {
      'interestSaved': result['interestSaved'] as double,
      'timeSavedYears': result['timeSaved'] as double,
      'pfWithdrawalAmount': pfAmount,
    };
  }

  /// Calculate Tax Optimization savings
  static Map<String, double> _calculateTaxOptimizationHeroSavings() {
    final annualInterest = _baseEMI * 12 * 0.78; // Approximate interest portion
    final annualPrincipal =
        _baseEMI * 12 * 0.22; // Approximate principal portion
    const taxRate = 0.30; // 30% tax bracket

    final interestTaxSaved =
        math.min(annualInterest, 200000) * taxRate; // 24(b) benefit
    final principalTaxSaved =
        math.min(annualPrincipal, 150000) * taxRate; // 80C benefit

    return {
      'annualTaxSaved': interestTaxSaved + principalTaxSaved,
      'lifetimeTaxSaved': (interestTaxSaved + principalTaxSaved) *
          15, // Approximate over 15 years
      'interestBenefit': interestTaxSaved,
      'principalBenefit': principalTaxSaved,
    };
  }

  /// Get rounded EMI amount
  static double _getRoundedEMI() {
    return ((_baseEMI / 1000).ceil() * 1000).toDouble();
  }

  /// Format amount in lakhs for display
  static String _formatLakhs(double amount) {
    return (amount / 100000).toStringAsFixed(1);
  }

  /// Format amount in INR with proper comma separation
  static String _formatINR(double amount) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(formatter, (Match match) => '${match[1]},');
  }

  /// Detailed impact analysis for each strategy
  static Map<String, dynamic> _getExtraEMIImpactAnalysis() {
    final heroSavings = _calculateExtraEMIHeroSavings();
    return {
      'interestSaved': heroSavings['interestSaved'],
      'timeSaved': heroSavings['timeSavedYears'],
      'extraPaymentRequired': heroSavings['extraAnnualPayment'],
      'roi': (heroSavings['interestSaved']! /
              (heroSavings['extraAnnualPayment']! * 10)) *
          100, // Approximate ROI
      'breakEvenYears': 1.2, // Approximate break-even
      'impactRating': 'Very High',
    };
  }

  static Map<String, dynamic> _getStepUpImpactAnalysis() {
    final heroSavings = _calculateStepUpHeroSavings();
    return {
      'interestSaved': heroSavings['interestSaved'],
      'timeSaved': heroSavings['timeSavedYears'],
      'totalExtraPayments': heroSavings['totalExtraPayments'],
      'averageAnnualIncrease': heroSavings['totalExtraPayments']! / 10,
      'roi':
          (heroSavings['interestSaved']! / heroSavings['totalExtraPayments']!) *
              100,
      'impactRating': 'Very High',
    };
  }

  static Map<String, dynamic> _getRoundUpImpactAnalysis() {
    final heroSavings = _calculateRoundUpHeroSavings();
    return {
      'interestSaved': heroSavings['interestSaved'],
      'timeSaved': heroSavings['timeSavedYears'],
      'monthlyExtraAmount': heroSavings['extraMonthlyPayment'],
      'annualExtraAmount': heroSavings['extraMonthlyPayment']! * 12,
      'roi': (heroSavings['interestSaved']! /
              (heroSavings['extraMonthlyPayment']! * 12 * 10)) *
          100,
      'impactRating': 'Medium',
    };
  }

  static Map<String, dynamic> _getFestivalPrepaymentImpactAnalysis() {
    final heroSavings = _calculateFestivalPrepaymentHeroSavings();
    return {
      'interestSaved': heroSavings['interestSaved'],
      'timeSaved': heroSavings['timeSavedYears'],
      'annualBonusAmount': heroSavings['annualBonusAmount'],
      'roi': (heroSavings['interestSaved']! /
              (heroSavings['annualBonusAmount']! * 10)) *
          100,
      'impactRating': 'High',
    };
  }

  static Map<String, dynamic> _getBalanceTransferImpactAnalysis() {
    final heroSavings = _calculateBalanceTransferHeroSavings();
    return {
      'interestSaved': heroSavings['interestSaved'],
      'monthlySaving': heroSavings['monthlySaving'],
      'annualSaving': heroSavings['monthlySaving']! * 12,
      'transferCosts': heroSavings['transferCosts'],
      'paybackPeriod':
          heroSavings['transferCosts']! / (heroSavings['monthlySaving']! * 12),
      'impactRating': 'High',
    };
  }

  static Map<String, dynamic> _getPFWithdrawalImpactAnalysis() {
    final heroSavings = _calculatePFWithdrawalHeroSavings();
    return {
      'interestSaved': heroSavings['interestSaved'],
      'timeSaved': heroSavings['timeSavedYears'],
      'pfAmount': heroSavings['pfWithdrawalAmount'],
      'roi':
          (heroSavings['interestSaved']! / heroSavings['pfWithdrawalAmount']!) *
              100,
      'impactRating': 'High',
    };
  }

  static Map<String, dynamic> _getTaxOptimizationImpactAnalysis() {
    final heroSavings = _calculateTaxOptimizationHeroSavings();
    return {
      'annualTaxSaved': heroSavings['annualTaxSaved'],
      'lifetimeTaxSaved': heroSavings['lifetimeTaxSaved'],
      'section80cBenefit': heroSavings['principalBenefit'],
      'section24bBenefit': heroSavings['interestBenefit'],
      'impactRating': 'Very High (No downside)',
    };
  }

  /// Scenario analysis for each strategy
  static Map<String, dynamic> _getExtraEMIScenarios() {
    return {
      'bestCase': {
        'description': 'High bonus, early loan years, no prepayment charges',
        'annualExtraEMI': _baseEMI * 2, // Double EMI as extra
        'interestSaved': 1250000, // ₹12.5L
        'timeSaved': 3.8, // years
      },
      'typical': {
        'description': 'Regular bonus, mid-loan years, minimal charges',
        'annualExtraEMI': _baseEMI,
        'interestSaved': _calculateExtraEMIHeroSavings()['interestSaved'],
        'timeSaved': _calculateExtraEMIHeroSavings()['timeSavedYears'],
      },
      'minimal': {
        'description': 'Small bonus, later loan years, with charges',
        'annualExtraEMI': _baseEMI * 0.5,
        'interestSaved': 250000, // ₹2.5L
        'timeSaved': 1.2, // years
      },
    };
  }

  static Map<String, dynamic> _getStepUpScenarios() {
    return {
      'bestCase': {
        'description': 'Consistent 10% salary growth, aggressive step-up',
        'annualIncrease': '8-10%',
        'interestSaved': 1800000, // ₹18L
        'timeSaved': 5.5, // years
      },
      'typical': {
        'description': 'Regular 8% salary growth, 5% EMI increase',
        'annualIncrease': '5%',
        'interestSaved': _calculateStepUpHeroSavings()['interestSaved'],
        'timeSaved': _calculateStepUpHeroSavings()['timeSavedYears'],
      },
      'minimal': {
        'description': 'Slow growth, conservative 3% increase',
        'annualIncrease': '3%',
        'interestSaved': 650000, // ₹6.5L
        'timeSaved': 2.8, // years
      },
    };
  }

  static Map<String, dynamic> _getRoundUpScenarios() {
    return {
      'bestCase': {
        'description': 'Large rounding opportunity, early loan years',
        'monthlyExtra': 2000, // ₹2K extra per month
        'interestSaved': 450000, // ₹4.5L
        'timeSaved': 2.1, // years
      },
      'typical': {
        'description': 'Standard rounding, typical loan stage',
        'monthlyExtra': _getRoundedEMI() - _baseEMI,
        'interestSaved': _calculateRoundUpHeroSavings()['interestSaved'],
        'timeSaved': _calculateRoundUpHeroSavings()['timeSavedYears'],
      },
      'minimal': {
        'description': 'Small rounding amount, later loan years',
        'monthlyExtra': 500, // ₹500 extra per month
        'interestSaved': 85000, // ₹85K
        'timeSaved': 0.6, // years
      },
    };
  }

  static Map<String, dynamic> _getFestivalPrepaymentScenarios() {
    return {
      'bestCase': {
        'description': 'Multiple bonuses, high festival gifts, early loan',
        'annualAmount': 200000, // ₹2L per year
        'interestSaved': 1400000, // ₹14L
        'timeSaved': 4.2, // years
      },
      'typical': {
        'description': 'Standard Diwali bonus, some gifts',
        'annualAmount': 100000, // ₹1L per year
        'interestSaved':
            _calculateFestivalPrepaymentHeroSavings()['interestSaved'],
        'timeSaved':
            _calculateFestivalPrepaymentHeroSavings()['timeSavedYears'],
      },
      'minimal': {
        'description': 'Small bonus, limited festival money',
        'annualAmount': 50000, // ₹50K per year
        'interestSaved': 350000, // ₹3.5L
        'timeSaved': 1.8, // years
      },
    };
  }

  static Map<String, dynamic> _getBalanceTransferScenarios() {
    return {
      'bestCase': {
        'description': '1% rate reduction, low transfer costs',
        'rateReduction': 1.0, // 1% reduction
        'transferCosts': 30000,
        'interestSaved': 1200000, // ₹12L
        'monthlySaving': 4200,
      },
      'typical': {
        'description': '0.5% rate reduction, standard costs',
        'rateReduction': 0.5, // 0.5% reduction
        'transferCosts': 50000,
        'interestSaved':
            _calculateBalanceTransferHeroSavings()['interestSaved'],
        'monthlySaving':
            _calculateBalanceTransferHeroSavings()['monthlySaving'],
      },
      'minimal': {
        'description': '0.25% rate reduction, high costs',
        'rateReduction': 0.25, // 0.25% reduction
        'transferCosts': 75000,
        'interestSaved': 180000, // ₹1.8L
        'monthlySaving': 1100,
      },
    };
  }

  static Map<String, dynamic> _getPFWithdrawalScenarios() {
    return {
      'bestCase': {
        'description': 'Large PF corpus, early loan years',
        'withdrawalAmount': 1000000, // ₹10L
        'interestSaved': 1800000, // ₹18L
        'timeSaved': 5.2, // years
      },
      'typical': {
        'description': 'Moderate PF amount, mid-loan stage',
        'withdrawalAmount': 500000, // ₹5L
        'interestSaved': _calculatePFWithdrawalHeroSavings()['interestSaved'],
        'timeSaved': _calculatePFWithdrawalHeroSavings()['timeSavedYears'],
      },
      'minimal': {
        'description': 'Small PF withdrawal, later loan years',
        'withdrawalAmount': 200000, // ₹2L
        'interestSaved': 280000, // ₹2.8L
        'timeSaved': 1.4, // years
      },
    };
  }

  static Map<String, dynamic> _getTaxOptimizationScenarios() {
    return {
      'bestCase': {
        'description': '30% tax bracket, maximizing all benefits',
        'taxBracket': '30%',
        'annualSaving': 75000, // ₹75K per year
        'lifetimeSaving': 1125000, // ₹11.25L over 15 years
      },
      'typical': {
        'description': '20% tax bracket, standard optimization',
        'taxBracket': '20%',
        'annualSaving':
            _calculateTaxOptimizationHeroSavings()['annualTaxSaved'],
        'lifetimeSaving':
            _calculateTaxOptimizationHeroSavings()['lifetimeTaxSaved'],
      },
      'minimal': {
        'description': '10% tax bracket, limited benefits',
        'taxBracket': '10%',
        'annualSaving': 25000, // ₹25K per year
        'lifetimeSaving': 375000, // ₹3.75L over 15 years
      },
    };
  }
}
