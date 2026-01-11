# Flutter App for BudgetBunny

## Overview
Create a mobile Flutter app that replicates the functionality of the web-based BudgetBuddy app for university students. The app will help students manage their budgets, track expenses, set savings goals, and view reports.

## Features
- **Landing Screen**: Introduction to the app with call-to-action to start onboarding.
- **Onboarding Screen**: Form to input monthly income, housing costs, tuition, financial goals, and budgeting preference. Calculates and generates a personalized budget.
- **Budget Screen**: Displays the generated budget with categories (Housing/Meal Plan, Food/Groceries, Transportation, Tuition/Loans, Books/Supplies, Entertainment/Social, Savings/Emergency) and amounts. Includes a pie chart visualization.
- **Expenses Screen**: List of expenses with ability to add new expenses (amount, category, date, notes).
- **Goals Screen**: List of savings goals with ability to add new goals and update progress towards them.
- **Reports Screen**: Charts showing spending vs. budget, spending trends, and category comparisons.
- **Reminders Screen**: List of reminders with ability to add new reminders (type, date, message).
- **Progress Screen**: Static screen showing progress (placeholder).
- **Tips Screen**: Static screen with budgeting tips.
- **About Screen**: Static screen with app information.

## Architecture
- **Framework**: Flutter with Material Design.
- **State Management**: Provider for managing app state (budget, expenses, goals, reminders).
- **Persistence**: SharedPreferences for storing data locally (since web backend is in-memory).
- **Navigation**: BottomNavigationBar for main screens, with additional screens accessible via navigation.
- **Charts**: fl_chart package for pie charts and bar charts.
- **Icons**: Lucide icons or Material icons.

## Data Models
- **Budget**: income, categories (list of Category), labels, data.
- **Category**: name, amount.
- **Expense**: amount, category, date, notes.
- **Goal**: id, name, target, current.
- **Reminder**: type, date, message.

## Screens Structure
- **Main App**: MaterialApp with routes or navigator.
- **Bottom Nav**: Budget, Expenses, Goals, Reports, More (drawer for other screens).
- **Screens**:
  - LandingScreen
  - OnboardingScreen
  - BudgetScreen
  - ExpensesScreen
  - AddExpenseScreen
  - GoalsScreen
  - AddGoalScreen
  - UpdateGoalScreen
  - ReportsScreen
  - RemindersScreen
  - AddReminderScreen
  - ProgressScreen
  - TipsScreen
  - AboutScreen

## Navigation Flow
- App starts at LandingScreen.
- From Landing, go to Onboarding.
- After onboarding, go to BudgetScreen.
- Bottom nav allows switching between main screens.
- From Expenses/Goals/Reminders, can add new items.

## State Management
- **BudgetProvider**: Manages current budget, expenses, goals, reminders.
- Methods: createBudget, addExpense, addGoal, updateGoal, addReminder, getReportsData.

## Dependencies
- provider: ^6.0.5
- shared_preferences: ^2.2.0
- fl_chart: ^0.66.0
- intl: ^0.19.0 (for date formatting)

## Project Structure
```
lib/
  main.dart
  models/
    budget.dart
    expense.dart
    goal.dart
    reminder.dart
  providers/
    budget_provider.dart
  screens/
    landing_screen.dart
    onboarding_screen.dart
    budget_screen.dart
    expenses_screen.dart
    add_expense_screen.dart
    goals_screen.dart
    add_goal_screen.dart
    update_goal_screen.dart
    reports_screen.dart
    reminders_screen.dart
    add_reminder_screen.dart
    progress_screen.dart
    tips_screen.dart
    about_screen.dart
  widgets/
    budget_chart.dart
    expense_list_item.dart
    etc.
```

## Implementation Plan
1. Create Flutter project.
2. Set up dependencies.
3. Define data models.
4. Implement Provider for state.
5. Create screens starting with Landing and Onboarding.
6. Implement Budget logic (similar to web app).
7. Add remaining screens.
8. Implement charts.
9. Add persistence with SharedPreferences.
10. Test and refine UI.