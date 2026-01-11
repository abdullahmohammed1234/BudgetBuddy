import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/budget.dart';
import '../models/expense.dart';
import '../models/goal.dart';
import '../models/reminder.dart';

class BudgetProvider with ChangeNotifier {
  Budget? _budget;
  List<Expense> _expenses = [];
  List<Goal> _goals = [];
  List<Reminder> _reminders = [];
  double _savingsRate = 100;

  final List<String> _categories = [
    'Housing/Meal Plan',
    'Food/Groceries',
    'Transportation',
    'Tuition/Loans',
    'Books/Supplies',
    'Entertainment/Social',
    'Savings/Emergency'
  ];

  Budget? get budget => _budget;
  List<Expense> get expenses => _expenses;
  List<Goal> get goals => _goals;
  List<Reminder> get reminders => _reminders;
  List<String> get categories => _categories;

  BudgetProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetJson = prefs.getString('budget');
    if (budgetJson != null) {
      _budget = Budget.fromJson(json.decode(budgetJson));
    }
    final expensesJson = prefs.getString('expenses');
    if (expensesJson != null) {
      _expenses = (json.decode(expensesJson) as List)
          .map((e) => Expense.fromJson(e))
          .toList();
    }
    final goalsJson = prefs.getString('goals');
    if (goalsJson != null) {
      _goals = (json.decode(goalsJson) as List)
          .map((g) => Goal.fromJson(g))
          .toList();
    }
    final remindersJson = prefs.getString('reminders');
    if (remindersJson != null) {
      _reminders = (json.decode(remindersJson) as List)
          .map((r) => Reminder.fromJson(r))
          .toList();
    }
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_budget != null) {
      await prefs.setString('budget', json.encode(_budget!.toJson()));
    }
    await prefs.setString('expenses', json.encode(_expenses.map((e) => e.toJson()).toList()));
    await prefs.setString('goals', json.encode(_goals.map((g) => g.toJson()).toList()));
    await prefs.setString('reminders', json.encode(_reminders.map((r) => r.toJson()).toList()));
  }

  void createBudget(double income, double rent, double tuition, String goals, String preference) {
    double food = 300;
    double transportation = 150;
    double books = 200;
    double entertainment = 250;

    double needs = rent + tuition + food + transportation + books;
    double wants = entertainment;
    double savings = income - needs - wants;

    if (savings < 0) {
      savings = 0;
      wants = income - needs > 0 ? income - needs : 0;
    }

    if (preference == 'strict') {
      needs = income * 0.5;
      wants = income * 0.3;
      savings = income * 0.2;
    }

    if (goals == 'debt') {
      savings += 100;
    } else if (goals == 'graduation') {
      savings += 100;
    }

    List<Category> categories = [
      Category(name: 'Housing/Meal Plan', amount: rent),
      Category(name: 'Food/Groceries', amount: food),
      Category(name: 'Transportation', amount: transportation),
      Category(name: 'Tuition/Loans', amount: tuition),
      Category(name: 'Books/Supplies', amount: books),
      Category(name: 'Entertainment/Social', amount: wants),
      Category(name: 'Savings/Emergency', amount: savings),
    ];

    List<String> labels = categories.map((c) => c.name).toList();
    List<double> data = categories.map((c) => c.amount).toList();

    _budget = Budget(
      income: income,
      categories: categories,
      labels: labels,
      data: data,
    );

    saveData();
    notifyListeners();
  }

  void addExpense(double amount, String category, String date, String notes) {
    _expenses.add(Expense(
      amount: amount,
      category: category,
      date: date,
      notes: notes,
    ));
    saveData();
    notifyListeners();
  }

  void addGoal(String name, double target) {
    int id = _goals.isNotEmpty ? _goals.last.id + 1 : 1;
    _goals.add(Goal(
      id: id,
      name: name,
      target: target,
    ));
    saveData();
    notifyListeners();
  }

  void updateGoal(int id, double amount) {
    final goal = _goals.firstWhere((g) => g.id == id);
    goal.current += amount;
    saveData();
    notifyListeners();
  }

  void addReminder(String type, String date, String message) {
    _reminders.add(Reminder(
      type: type,
      date: date,
      message: message,
    ));
    saveData();
    notifyListeners();
  }

  Map<String, dynamic> getReportsData() {
    List<double> categorySpent = _categories.map((cat) {
      return _expenses.where((e) => e.category == cat).fold(0.0, (sum, e) => sum + e.amount);
    }).toList();

    List<String> trendLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    List<double> dailySpending = [50, 60, 40, 70]; // Placeholder

    Map<String, List<double>> comparisonData = {
      'budget': _budget?.data ?? List.filled(_categories.length, 0),
      'spent': categorySpent,
    };

    return {
      'categoryLabels': _categories,
      'categorySpent': categorySpent,
      'trendLabels': trendLabels,
      'dailySpending': dailySpending,
      'comparisonLabels': _categories,
      'comparisonData': comparisonData,
    };
  }
}