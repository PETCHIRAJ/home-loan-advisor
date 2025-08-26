# Chart Specifications - Home Loan Advisor

## Design Brief
This specification provides detailed visual and interaction guidelines for implementing charts in the Home Loan Advisor app using fl_chart library. The design emphasizes clarity, accessibility, and meaningful financial data visualization that helps users understand their loan breakdown and progress over time.

## Chart Library Configuration

### Flutter Implementation
**Primary Library**: `fl_chart: ^0.68.0`
**Fallback**: Custom painting with Flutter Canvas if needed
**Performance**: Optimized for 60fps animations on mid-range devices

### Design System Integration
```dart
class ChartTheme {
  // Chart Colors
  static const Color principalColor = Color(0xFF388E3C);      // Success Green
  static const Color interestColor = Color(0xFFD32F2F);       // Error Red  
  static const Color timelineColor = Color(0xFF1565C0);       // Primary Blue
  static const Color gridColor = Color(0xFFE0E0E0);           // Divider Gray
  static const Color textColor = Color(0xFF757575);           // Secondary Text
  
  // Chart Dimensions
  static const double chartHeight = 300.0;
  static const double legendHeight = 60.0;
  static const double padding = 16.0;
  static const double borderRadius = 12.0;
}
```

## Chart Types & Specifications

### 1. Pie Chart - Principal vs Interest Breakdown

#### Visual Design
- **Container**: 280x280px with 12px border radius
- **Background**: White surface with subtle shadow
- **Animation**: 1.2s ease-out entrance animation
- **Interaction**: Touch to highlight segments

#### Color Scheme
```dart
PieChartData(
  sectionsSpace: 2,
  centerSpaceRadius: 40,
  sections: [
    PieChartSectionData(
      color: ChartTheme.principalColor,    // Green for Principal
      value: principalPercentage,
      title: '${principalPercentage.toInt()}%',
      radius: 60,
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: ChartTheme.interestColor,     // Red for Interest
      value: interestPercentage,
      title: '${interestPercentage.toInt()}%',
      radius: 60,
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ],
)
```

#### Interactive States
- **Default**: Both segments visible with 2px spacing
- **Hover/Touch**: Selected segment expands by 10px radius
- **Legend Integration**: Touch legend item highlights corresponding segment
- **Accessibility**: Screen reader announces percentages and values

#### Animation Specifications
```dart
AnimationController(
  duration: Duration(milliseconds: 1200),
  vsync: this,
)

// Entry Animation
Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutCubic,
  ),
)
```

### 2. Timeline Chart - Loan Balance Over Time

#### Visual Design
- **Container**: 350x250px with 12px border radius
- **Type**: Line chart with area fill
- **X-Axis**: Years (0 to loan tenure)
- **Y-Axis**: Remaining balance in lakhs
- **Grid**: Subtle horizontal and vertical lines

#### Chart Configuration
```dart
LineChartData(
  backgroundColor: Colors.transparent,
  gridData: FlGridData(
    show: true,
    drawVerticalLine: true,
    horizontalInterval: maxBalance / 4,
    verticalInterval: tenure / 4,
    getDrawingHorizontalLine: (value) => FlLine(
      color: ChartTheme.gridColor,
      strokeWidth: 1,
    ),
    getDrawingVerticalLine: (value) => FlLine(
      color: ChartTheme.gridColor,
      strokeWidth: 1,
    ),
  ),
  borderData: FlBorderData(show: false),
  lineBarsData: [
    LineChartBarData(
      spots: timelineData,
      isCurved: true,
      curveSmoothness: 0.35,
      color: ChartTheme.timelineColor,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) =>
          FlDotCirclePainter(
            radius: 4,
            color: ChartTheme.timelineColor,
            strokeColor: Colors.white,
            strokeWidth: 2,
          ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: ChartTheme.timelineColor.withOpacity(0.1),
      ),
    ),
  ],
)
```

#### Axis Formatting
```dart
// X-Axis (Years)
bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: tenure / 4,
    getTitlesWidget: (value, meta) => Text(
      '${value.toInt()}y',
      style: TextStyle(
        color: ChartTheme.textColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),

// Y-Axis (Balance in Lakhs)
leftTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 40,
    interval: maxBalance / 4,
    getTitlesWidget: (value, meta) => Text(
      '₹${(value / 100000).toInt()}L',
      style: TextStyle(
        color: ChartTheme.textColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),
```

### 3. Chart Toggle Controls

#### Toggle Button Design
```dart
Container(
  height: 40,
  decoration: BoxDecoration(
    color: Color(0xFFF5F5F5),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: () => showChart('pie'),
          child: Container(
            decoration: BoxDecoration(
              color: chartType == 'pie' ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              boxShadow: chartType == 'pie' ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ] : null,
            ),
            child: Center(
              child: Text(
                'Pie Chart',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: chartType == 'pie' 
                    ? ChartTheme.textColor 
                    : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTap: () => showChart('timeline'),
          child: Container(
            decoration: BoxDecoration(
              color: chartType == 'timeline' ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              boxShadow: chartType == 'timeline' ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ] : null,
            ),
            child: Center(
              child: Text(
                'Timeline',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: chartType == 'timeline' 
                    ? ChartTheme.textColor 
                    : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
)
```

### 4. Chart Legend

#### Legend Component
```dart
class ChartLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LegendItem(
            color: ChartTheme.principalColor,
            label: 'Principal',
            value: '₹${formatCurrency(principalAmount)}',
          ),
          SizedBox(width: 32),
          LegendItem(
            color: ChartTheme.interestColor,
            label: 'Interest',
            value: '₹${formatCurrency(interestAmount)}',
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

## Data Calculation & Updates

### EMI Calculation Integration
```dart
class LoanCalculations {
  static double calculateEMI(double principal, double rate, int tenure) {
    double monthlyRate = rate / (12 * 100);
    int totalMonths = tenure * 12;
    
    if (monthlyRate == 0) {
      return principal / totalMonths;
    }
    
    double emi = principal * 
        (monthlyRate * pow(1 + monthlyRate, totalMonths)) /
        (pow(1 + monthlyRate, totalMonths) - 1);
    
    return emi;
  }
  
  static List<FlSpot> generateTimelineData(double principal, double rate, int tenure) {
    List<FlSpot> spots = [];
    double remainingBalance = principal;
    double emi = calculateEMI(principal, rate, tenure);
    
    spots.add(FlSpot(0, principal));
    
    for (int year = 1; year <= tenure; year++) {
      for (int month = 1; month <= 12; month++) {
        double interestPayment = remainingBalance * (rate / 100) / 12;
        double principalPayment = emi - interestPayment;
        remainingBalance -= principalPayment;
        
        if (remainingBalance <= 0) {
          remainingBalance = 0;
          spots.add(FlSpot(year.toDouble(), 0));
          return spots;
        }
      }
      spots.add(FlSpot(year.toDouble(), remainingBalance));
    }
    
    return spots;
  }
}
```

### Chart Update Logic
```dart
void updateCharts() {
  setState(() {
    // Calculate new pie chart data
    double totalAmount = emi * tenure * 12;
    double totalInterest = totalAmount - principal;
    principalPercentage = (principal / totalAmount) * 100;
    interestPercentage = (totalInterest / totalAmount) * 100;
    
    // Generate new timeline data
    timelineSpots = LoanCalculations.generateTimelineData(
      principal, 
      interestRate, 
      tenure
    );
  });
  
  // Animate chart updates
  chartController.reset();
  chartController.forward();
}
```

## Responsive Design

### Breakpoint Adjustments
```dart
class ResponsiveChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartSize = screenWidth < 375 
        ? Size(250, 250)    // Small screens
        : Size(280, 280);   // Standard screens
    
    return Container(
      width: chartSize.width,
      height: chartSize.height,
      child: buildChart(),
    );
  }
}
```

### Text Scaling
- **Small screens**: Reduce font sizes by 10%
- **Large text settings**: Respect user accessibility preferences
- **Minimum touch targets**: 44x44pt for interactive elements

## Accessibility Features

### Screen Reader Support
```dart
Semantics(
  label: 'Pie chart showing loan breakdown',
  value: 'Principal ${principalPercentage.toInt()} percent, Interest ${interestPercentage.toInt()} percent',
  child: PieChart(chartData),
)
```

### High Contrast Mode
```dart
// Adjust colors for high contrast accessibility
Color getAccessibleColor(Color baseColor) {
  final brightness = MediaQuery.of(context).platformBrightness;
  final highContrast = MediaQuery.of(context).highContrast;
  
  if (highContrast) {
    return brightness == Brightness.dark 
        ? Colors.white 
        : Colors.black;
  }
  
  return baseColor;
}
```

### Reduced Motion Support
```dart
// Respect user's motion preferences
Duration getAnimationDuration() {
  final reduceMotion = MediaQuery.of(context).disableAnimations;
  return reduceMotion 
      ? Duration(milliseconds: 1)      // Minimal animation
      : Duration(milliseconds: 1200);  // Full animation
}
```

## Performance Optimizations

### Chart Caching
```dart
class ChartDataCache {
  static Map<String, ChartData> _cache = {};
  
  static ChartData getOrCalculate(String key, Function calculator) {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    
    final data = calculator();
    _cache[key] = data;
    return data;
  }
  
  static void clearCache() {
    _cache.clear();
  }
}
```

### Lazy Loading
- Charts render only when visible
- Data calculations performed in background isolates for large datasets
- Progressive rendering for timeline chart with many data points

## Error Handling

### Data Validation
```dart
ChartData validateAndBuildChart(double principal, double rate, int tenure) {
  // Validate inputs
  if (principal <= 0 || rate <= 0 || tenure <= 0) {
    return ChartData.error('Invalid loan parameters');
  }
  
  try {
    return ChartData.success(
      principal: principal,
      rate: rate,
      tenure: tenure,
    );
  } catch (e) {
    return ChartData.error('Failed to calculate chart data');
  }
}
```

### Fallback UI
```dart
Widget buildChartOrFallback() {
  return FutureBuilder<ChartData>(
    future: calculateChartData(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Container(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('Unable to display chart'),
                TextButton(
                  onPressed: () => recalculate(),
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }
      
      if (!snapshot.hasData) {
        return Container(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      return buildChart(snapshot.data!);
    },
  );
}
```

This comprehensive chart specification provides all necessary details for implementing visually appealing, accessible, and performant charts in the Home Loan Advisor app using fl_chart library.