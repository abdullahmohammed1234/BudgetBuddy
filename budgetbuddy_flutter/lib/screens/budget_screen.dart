import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/budget_provider.dart';
import '../models/goal.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);
    final budget = provider.budget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BudgetBuddy'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.account_balance_wallet), text: 'Budget'),
            Tab(icon: Icon(Icons.receipt), text: 'Expenses'),
            Tab(icon: Icon(Icons.flag), text: 'Goals'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Reports'),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => _showAddExpenseDialog(context),
              child: const Icon(Icons.add),
            )
          : _currentIndex == 2
              ? FloatingActionButton(
                  onPressed: () => _showAddGoalDialog(context),
                  child: const Icon(Icons.add),
                )
              : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          // Budget Tab
          budget == null
              ? const Center(child: Text('No budget found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Your Monthly Budget',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: budget.categories.map((category) {
                              return PieChartSectionData(
                                value: category.amount,
                                title: '\$${category.amount.toStringAsFixed(0)}',
                                color: Colors.primaries[budget.categories.indexOf(category) % Colors.primaries.length],
                                radius: 80,
                                titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: budget.categories.length,
                        itemBuilder: (context, index) {
                          final category = budget.categories[index];
                          return ListTile(
                            title: Text(category.name),
                            trailing: Text('\$${category.amount.toStringAsFixed(2)}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
          // Expenses Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (provider.expenses.isEmpty)
                  const Center(child: Text('No expenses yet. Tap + to add.'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = provider.expenses[index];
                      return ListTile(
                        title: Text(expense.category),
                        subtitle: Text('${expense.date} - ${expense.notes}'),
                        trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Goals Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (provider.goals.isEmpty)
                  const Center(child: Text('No goals yet. Tap + to add.'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.goals.length,
                    itemBuilder: (context, index) {
                      final goal = provider.goals[index];
                      return ListTile(
                        title: Text(goal.name),
                        subtitle: Text('Current: \$${goal.current.toStringAsFixed(2)} / Target: \$${goal.target.toStringAsFixed(2)}'),
                        trailing: CircularProgressIndicator(
                          value: goal.target > 0 ? goal.current / goal.target : 0,
                        ),
                        onTap: () => _showUpdateGoalDialog(context, goal),
                      );
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Reports Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Spending vs Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: List.generate(provider.categories.length, (index) {
                        final category = provider.categories[index];
                        final spent = provider.expenses.where((e) => e.category == category).fold(0.0, (sum, e) => sum + e.amount);
                        final budgeted = budget?.categories.firstWhere((c) => c.name == category).amount ?? 0;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: budgeted,
                              color: Colors.blue,
                            ),
                            BarChartRodData(
                              toY: spent,
                              color: Colors.red,
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(provider.categories[value.toInt()], style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...provider.categories.map((category) {
                  final spent = provider.expenses.where((e) => e.category == category).fold(0.0, (sum, e) => sum + e.amount);
                  final budgeted = budget?.categories.firstWhere((c) => c.name == category).amount ?? 0;
                  final status = spent > budgeted ? 'Over Budget' : 'On Track';
                  return ListTile(
                    title: Text(category),
                    subtitle: Text('Budgeted: \$${budgeted.toStringAsFixed(2)} | Spent: \$${spent.toStringAsFixed(2)}'),
                    trailing: Text(status, style: TextStyle(color: spent > budgeted ? Colors.red : Colors.green)),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context, listen: false);
    final _amountController = TextEditingController();
    final _notesController = TextEditingController();
    String _selectedCategory = provider.categories.first;
    String _selectedDate = DateTime.now().toIso8601String().split('T').first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: provider.categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    _selectedCategory = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: TextEditingController(text: _selectedDate),
                  decoration: const InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      _selectedDate = picked.toIso8601String().split('T').first;
                      // Update the controller
                    }
                  },
                ),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                provider.addExpense(amount, _selectedCategory, _selectedDate, _notesController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context, listen: false);
    final _nameController = TextEditingController();
    final _targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Goal Name'),
              ),
              TextField(
                controller: _targetController,
                decoration: const InputDecoration(labelText: 'Target Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final target = double.tryParse(_targetController.text) ?? 0;
                provider.addGoal(_nameController.text, target);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateGoalDialog(BuildContext context, Goal goal) {
    final provider = Provider.of<BudgetProvider>(context, listen: false);
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update ${goal.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current: \$${goal.current.toStringAsFixed(2)} / Target: \$${goal.target.toStringAsFixed(2)}'),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Add Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0;
                provider.updateGoal(goal.id, amount);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}