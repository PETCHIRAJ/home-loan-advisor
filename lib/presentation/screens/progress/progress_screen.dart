import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Progress Tracking',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Progress Tracking Coming Soon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Track your loan progress and savings over time',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
