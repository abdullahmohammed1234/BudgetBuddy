import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import 'onboarding_screen.dart';
import 'budget_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final hasBudget = provider.budget != null;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'The Personalized Budget Buddy for University Students',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Managing money as a student can be tough with tuition, part-time jobs, and social expenses. Let BudgetBuddy create a personalized budget to help you save for the future, pay off loans, and enjoy student life without financial stress.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'How it works',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStep('1. Tell us about your student life', Icons.person_add),
                      _buildStep('2. AI generates your budget', Icons.lightbulb),
                      _buildStep('3. Track and adjust', Icons.check_circle),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildStep('1. Tell us about your student life', Icons.person_add),
                      const SizedBox(height: 20),
                      _buildStep('2. AI generates your budget', Icons.lightbulb),
                      const SizedBox(height: 20),
                      _buildStep('3. Track and adjust', Icons.check_circle),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 40),
            if (hasBudget) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BudgetScreen()),
                  );
                },
                child: const Text('View My Budget'),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                );
              },
              child: const Text('Create Budget'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String text, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Colors.blue),
        const SizedBox(height: 10),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }
}