import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const HomeLoanAdvisorApp());
}

class HomeLoanAdvisorApp extends StatelessWidget {
  const HomeLoanAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Loan Advisor',
      debugShowCheckedModeBanner: false,
      
      // Use our custom Material 3 theme system
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respects user's system preference
      
      // Temporary home page to test theme
      home: const ThemeTestPage(),
    );
  }
}

/// Comprehensive theme test page showing all Material 3 components
/// This demonstrates the complete design system implementation
class ThemeTestPage extends StatefulWidget {
  const ThemeTestPage({super.key});

  @override
  State<ThemeTestPage> createState() => _ThemeTestPageState();
}

class _ThemeTestPageState extends State<ThemeTestPage> {
  int _selectedIndex = 0;
  bool _switchValue = true;
  double _sliderValue = 20;
  String _textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Loan Advisor'),
        actions: [
          IconButton(
            onPressed: () => _showThemeDialog(context),
            icon: const Icon(Icons.palette),
            tooltip: 'View Theme Details',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Section
            _buildSection(
              'Typography System',
              [
                Text('Display Large', style: theme.textTheme.displayLarge),
                const SizedBox(height: 8),
                Text('Headline Medium', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Title Large', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Body Large - Inter font provides excellent readability for financial content and currency displays like ₹50,00,000', 
                     style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
                Text('Label Medium', style: theme.textTheme.labelMedium),
              ],
            ),

            const SizedBox(height: 24),

            // Currency Display Section
            _buildSection(
              'Financial Typography',
              [
                const _CurrencyDisplay(
                  label: 'Loan Amount',
                  amount: 5000000, // ₹50 lakhs
                  isPositive: null,
                ),
                const SizedBox(height: 12),
                const _CurrencyDisplay(
                  label: 'Total Savings',
                  amount: 875000, // ₹8.75 lakhs saved
                  isPositive: true,
                ),
                const SizedBox(height: 12),
                const _CurrencyDisplay(
                  label: 'Interest Cost',
                  amount: 1250000, // ₹12.5 lakhs interest
                  isPositive: false,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Button Section
            _buildSection(
              'Button System',
              [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Calculate EMI'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text('View Strategies'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Compare Options'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Learn More'),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Cards Section
            _buildSection(
              'Card System',
              [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Loan Summary', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Your current home loan details', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        const LinearProgressIndicator(value: 0.3),
                        const SizedBox(height: 8),
                        Text('30% Complete', style: theme.textTheme.labelMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.savings),
                    title: const Text('Extra EMI Strategy'),
                    subtitle: const Text('Save ₹8,75,000 over loan term'),
                    trailing: Chip(
                      label: const Text('Recommended'),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Input Section
            _buildSection(
              'Input Fields',
              [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount',
                    prefixText: '₹ ',
                    suffixText: 'lakhs',
                    helperText: 'Enter your home loan amount',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => _textFieldValue = value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate',
                    suffixText: '% p.a.',
                    prefixIcon: Icon(Icons.percent),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Controls Section
            _buildSection(
              'Interactive Controls',
              [
                Row(
                  children: [
                    Switch(
                      value: _switchValue,
                      onChanged: (value) => setState(() => _switchValue = value),
                    ),
                    const SizedBox(width: 12),
                    const Text('Include insurance premium'),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Loan Tenure: ${_sliderValue.round()} years'),
                Slider(
                  value: _sliderValue,
                  min: 5,
                  max: 30,
                  divisions: 25,
                  label: '${_sliderValue.round()} years',
                  onChanged: (value) => setState(() => _sliderValue = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chips Section
            _buildSection(
              'Chip System',
              [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const Chip(
                      avatar: Icon(Icons.home, size: 18),
                      label: Text('Home Loan'),
                    ),
                    Chip(
                      label: const Text('First Time Buyer'),
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                    const Chip(
                      label: Text('Tax Benefits'),
                      deleteIcon: Icon(Icons.close, size: 18),
                      onDeleted: null,
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.calculate, size: 18),
                      label: const Text('Calculate'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb),
            label: 'Strategies',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline),
            label: 'Progress',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme System'),
        content: const Text('Material 3 design system with Inter font family, optimized for financial applications and Indian market preferences.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Looks Great!'),
          ),
        ],
      ),
    );
  }
}

/// Custom widget for displaying currency amounts with proper formatting
class _CurrencyDisplay extends StatelessWidget {
  final String label;
  final double amount;
  final bool? isPositive; // null for neutral, true for positive, false for negative

  const _CurrencyDisplay({
    required this.label,
    required this.amount,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Import and use the currency formatter
    final formattedAmount = '₹${(amount / 100000).toStringAsFixed(2)} lakhs';
    
    Color textColor;
    if (isPositive == true) {
      textColor = const Color(0xFF2E7D32); // Green for positive
    } else if (isPositive == false) {
      textColor = const Color(0xFFD32F2F); // Red for negative
    } else {
      textColor = theme.colorScheme.onSurface; // Neutral
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(
          formattedAmount,
          style: theme.textTheme.titleLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
