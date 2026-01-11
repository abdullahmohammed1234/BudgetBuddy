import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import 'budget_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _tuitionController = TextEditingController();
  String _goals = 'saving';
  String _preference = 'flexible';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Student Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Let\'s Create Your Student Budget',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _incomeController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income (jobs, scholarships, etc.) (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rentController,
                decoration: const InputDecoration(
                  labelText: 'Housing/Meal Plan (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your housing cost';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tuitionController,
                decoration: const InputDecoration(
                  labelText: 'Tuition/Student Loans (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your tuition cost';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _goals,
                decoration: const InputDecoration(
                  labelText: 'Financial Goals',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'saving', child: Text('Build Emergency Savings')),
                  DropdownMenuItem(value: 'debt', child: Text('Pay off Student Loans')),
                  DropdownMenuItem(value: 'graduation', child: Text('Save for Graduation')),
                ],
                onChanged: (value) {
                  setState(() {
                    _goals = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _preference,
                decoration: const InputDecoration(
                  labelText: 'Budgeting Style',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'strict', child: Text('Strict (50/30/20 rule)')),
                  DropdownMenuItem(value: 'flexible', child: Text('Flexible for Student Life')),
                ],
                onChanged: (value) {
                  setState(() {
                    _preference = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _generateBudget,
                child: const Text('Generate My Budget'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateBudget() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<BudgetProvider>(context, listen: false);
      provider.createBudget(
        double.parse(_incomeController.text),
        double.parse(_rentController.text),
        double.parse(_tuitionController.text),
        _goals,
        _preference,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BudgetScreen()),
      );
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _rentController.dispose();
    _tuitionController.dispose();
    super.dispose();
  }
}