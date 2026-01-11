import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final goals = provider.goals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return ListTile(
            title: Text(goal.name),
            subtitle: Text('Current: \$${goal.current.toStringAsFixed(2)} / Target: \$${goal.target.toStringAsFixed(2)}'),
            trailing: CircularProgressIndicator(
              value: goal.target > 0 ? goal.current / goal.target : 0,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add goal screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}