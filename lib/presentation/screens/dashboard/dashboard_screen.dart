import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard',
      showAppBar: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Home Loan Advisor',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'India\'s first tax-aware EMI calculator with PMAY benefits',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.5,
                children: [
                  _ActionCard(
                    icon: Icons.calculate,
                    title: 'Calculate EMI',
                    subtitle: 'Get instant loan calculations',
                    onTap: () {},
                  ),
                  _ActionCard(
                    icon: Icons.lightbulb,
                    title: 'Strategies',
                    subtitle: 'Optimize your loan',
                    onTap: () {},
                  ),
                  _ActionCard(
                    icon: Icons.trending_up,
                    title: 'Track Progress',
                    subtitle: 'Monitor your savings',
                    onTap: () {},
                  ),
                  _ActionCard(
                    icon: Icons.account_balance,
                    title: 'Compare Banks',
                    subtitle: 'Find best rates',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Features overview
              Text(
                'Key Features',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              const _FeatureCard(
                icon: Icons.receipt_long,
                title: 'Complete Tax Analysis',
                description:
                    'Calculate savings from Section 80C, 24B, and 80EEA',
              ),
              const _FeatureCard(
                icon: Icons.home_work,
                title: 'PMAY Integration',
                description: 'Check eligibility and calculate subsidy benefits',
              ),
              const _FeatureCard(
                icon: Icons.trending_down,
                title: 'Prepayment Strategies',
                description: 'Find the best ways to reduce interest burden',
              ),
              const _FeatureCard(
                icon: Icons.compare_arrows,
                title: 'Live Market Rates',
                description: 'Compare rates from 15+ banks and NBFCs',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
