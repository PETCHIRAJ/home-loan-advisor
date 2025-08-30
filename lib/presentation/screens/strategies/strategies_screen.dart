import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class StrategiesScreen extends StatelessWidget {
  const StrategiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Optimization Strategies',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Strategies Coming Soon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Calculate your EMI first to get personalized strategies',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
