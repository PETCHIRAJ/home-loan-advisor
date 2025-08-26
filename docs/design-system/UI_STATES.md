# UI States Specification - Home Loan Advisor

## Design Brief
This specification defines all missing UI states and micro-interactions to ensure comprehensive user experience coverage. The design emphasizes clear feedback, graceful error handling, and delightful micro-interactions that guide users through their loan management journey while maintaining accessibility and performance standards.

## Loading States

### 1. Calculator Loading State
**Trigger**: EMI calculation, chart generation, schedule computation

#### Visual Design
```dart
class CalculatorLoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Calculating your EMI...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```

#### Custom Loading Indicator
```dart
class CustomLoadingIndicator extends StatefulWidget {
  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 3,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            ),
            // Inner rupee symbol
            Icon(
              Icons.currency_rupee_rounded,
              size: 16,
              color: AppColors.primaryBlue,
            ),
          ],
        );
      },
    );
  }
}
```

#### Skeleton Loading for Charts
```dart
class ChartSkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 300,
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            // Chart area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Legend skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 60, height: 12, color: Colors.white),
                SizedBox(width: 32),
                Container(width: 60, height: 12, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. App Launch Loading
**Duration**: 2-3 seconds maximum
**Animation**: Logo reveal with progress indication

```dart
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    
    _startAnimations();
  }
  
  void _startAnimations() async {
    await _logoController.forward();
    await _progressController.forward();
    
    // Navigate to main app
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainApp()),
    );
  }
}
```

## Empty States

### 1. No Calculation History
**Context**: When user hasn't performed any calculations yet

```dart
class NoHistoryEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.calculate_rounded,
              size: 64,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 24),
          
          // Heading
          Text(
            'No calculations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          
          // Description
          Text(
            'Start by entering your loan details to see EMI calculations and savings strategies',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          
          // Call to action
          ElevatedButton(
            onPressed: () => navigateToCalculator(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Calculate EMI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 2. No Loan Data
**Context**: Fresh app install, no loan parameters set

```dart
class NoLoanDataState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Icon with background
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.2),
                  AppColors.growthTeal.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.home_rounded,
              size: 48,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 20),
          
          Text(
            'Ready to start your loan journey?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          
          Text(
            'Enter your loan amount, interest rate, and tenure to see how much you can save',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```

### 3. No Strategies Available
**Context**: When filtering results in no matching strategies

```dart
class NoStrategiesState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearFilter;
  
  const NoStrategiesState({
    required this.searchQuery,
    required this.onClearFilter,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          
          Text(
            'No strategies found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          
          Text(
            'No strategies match "${searchQuery}". Try adjusting your search or browse all strategies.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          
          TextButton(
            onPressed: onClearFilter,
            child: Text('Clear Filter'),
          ),
        ],
      ),
    );
  }
}
```

## Error States

### 1. Calculation Error
**Trigger**: Invalid inputs, mathematical errors, edge cases

```dart
class CalculationErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  
  const CalculationErrorState({
    required this.errorMessage,
    required this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon with animation
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 40,
                    color: AppColors.errorRed,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          
          Text(
            'Calculation Error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 2. Input Validation Errors

#### Inline Field Errors
```dart
class ValidatedTextField extends StatefulWidget {
  final String label;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final String? suffixText;
  
  @override
  _ValidatedTextFieldState createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  String? errorMessage;
  bool isValid = true;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_shakeController);
  }

  void _validateInput(String value) {
    setState(() {
      errorMessage = widget.validator?.call(value);
      isValid = errorMessage == null;
      
      if (!isValid) {
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value * 10 * (1 - _shakeAnimation.value), 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.controller,
                onChanged: _validateInput,
                decoration: InputDecoration(
                  labelText: widget.label,
                  suffixText: widget.suffixText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isValid ? AppColors.divider : AppColors.errorRed,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isValid ? AppColors.primaryBlue : AppColors.errorRed,
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: AppColors.errorRed,
                      ),
                      SizedBox(width: 4),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.errorRed,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
```

### 3. Network/Offline State
```dart
class OfflineNotificationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.warningOrange.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 16,
            color: AppColors.warningOrange,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'You\'re offline. All features still work!',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.warningOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColors.successGreen,
          ),
        ],
      ),
    );
  }
}
```

## Success & Confirmation States

### 1. Calculation Success Animation
```dart
class CalculationSuccessAnimation extends StatefulWidget {
  final VoidCallback onComplete;
  
  @override
  _CalculationSuccessAnimationState createState() => _CalculationSuccessAnimationState();
}

class _CalculationSuccessAnimationState extends State<CalculationSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _controller.forward().then((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        widget.onComplete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.successGreen.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: CheckmarkPainter(_checkAnimation.value),
                size: Size(100, 100),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double progress;
  
  CheckmarkPainter(this.progress);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    
    // Checkmark path
    path.moveTo(center.dx - 12, center.dy);
    path.lineTo(center.dx - 4, center.dy + 8);
    path.lineTo(center.dx + 12, center.dy - 8);
    
    // Draw animated checkmark
    final pathMetrics = path.computeMetrics().first;
    final extractedPath = pathMetrics.extractPath(0, pathMetrics.length * progress);
    
    canvas.drawPath(extractedPath, paint);
  }
  
  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

### 2. Save/Export Success Toast
```dart
class SuccessToast extends StatefulWidget {
  final String message;
  final Duration duration;
  
  const SuccessToast({
    required this.message,
    this.duration = const Duration(seconds: 3),
  });
  
  @override
  _SuccessToastState createState() => _SuccessToastState();
}

class _SuccessToastState extends State<SuccessToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    
    _controller.forward();
    
    // Auto dismiss
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

## Micro-Interactions & Transitions

### 1. Button Press Feedback
```dart
class ResponsiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  
  @override
  _ResponsiveButtonState createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
```

### 2. Page Transition Animation
```dart
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset beginOffset;
  
  SlidePageRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 300),
  );
}

// Usage
Navigator.push(
  context,
  SlidePageRoute(page: StrategyDetailPage()),
);
```

### 3. Tab Switch Animation
```dart
class AnimatedTabContent extends StatefulWidget {
  final Widget child;
  final int tabIndex;
  final int currentTabIndex;
  
  @override
  _AnimatedTabContentState createState() => _AnimatedTabContentState();
}

class _AnimatedTabContentState extends State<AnimatedTabContent>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    if (widget.tabIndex == widget.currentTabIndex) {
      _controller.forward();
    }
  }
  
  @override
  void didUpdateWidget(AnimatedTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTabIndex == widget.tabIndex) {
      _controller.forward();
    } else {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}
```

### 4. Value Counter Animation
```dart
class AnimatedCounter extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle style;
  final Duration duration;
  
  const AnimatedCounter({
    required this.value,
    this.prefix = '',
    this.suffix = '',
    required this.style,
    this.duration = const Duration(milliseconds: 1000),
  });
  
  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }
  
  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value.toStringAsFixed(0)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
```

## Progress Indicators

### 1. Loan Progress Ring
```dart
class LoanProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final Color progressColor;
  final Color backgroundColor;
  
  @override
  _LoanProgressRingState createState() => _LoanProgressRingState();
}

class _LoanProgressRingState extends State<LoanProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progress)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: ProgressRingPainter(
            progress: _progressAnimation.value,
            progressColor: widget.progressColor,
            backgroundColor: widget.backgroundColor,
          ),
        );
      },
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  
  ProgressRingPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    
    // Background ring
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress ring
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

### 2. Step Progress Indicator
```dart
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;
  
  const StepProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index % 2 == 0) {
              // Step circle
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              final isCurrent = stepIndex == currentStep;
              
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.successGreen 
                         : isCurrent ? AppColors.primaryBlue 
                         : AppColors.divider,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: isCompleted 
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          color: isCurrent ? Colors.white : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              );
            } else {
              // Connection line
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              
              return Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted ? AppColors.successGreen : AppColors.divider,
                ),
              );
            }
          }),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stepLabels.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;
            
            return Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isCompleted || isCurrent 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
```

This comprehensive UI states specification covers all critical user interface scenarios, ensuring the Home Loan Advisor app provides clear feedback, graceful error handling, and delightful interactions throughout the user journey.