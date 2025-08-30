import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/loan_parameters.dart';
import '../../../domain/entities/emi_result.dart';
import 'one_time_prepayment_calculator.dart';
import 'recurring_prepayment_calculator.dart';
import 'extra_emi_calculator.dart';

class PrepaymentTabs extends ConsumerWidget {
  final TabController tabController;
  final int selectedIndex;
  final LoanParameters loanParameters;
  final EMIResult emiResult;

  const PrepaymentTabs({
    super.key,
    required this.tabController,
    required this.selectedIndex,
    required this.loanParameters,
    required this.emiResult,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: child,
          ),
        );
      },
      child: IndexedStack(
        key: ValueKey(selectedIndex),
        index: selectedIndex,
        children: [
          // One-time Prepayment Tab
          OneTimePrepaymentCalculator(
            loanParameters: loanParameters,
            emiResult: emiResult,
            isVisible: selectedIndex == 0,
          ),

          // Recurring Prepayment Tab
          RecurringPrepaymentCalculator(
            loanParameters: loanParameters,
            emiResult: emiResult,
            isVisible: selectedIndex == 1,
          ),

          // Extra EMI Tab
          ExtraEMICalculator(
            loanParameters: loanParameters,
            emiResult: emiResult,
            isVisible: selectedIndex == 2,
          ),
        ],
      ),
    );
  }
}
