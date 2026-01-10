const express = require('express');
const app = express();
const port = 3000;

// In-memory storage for budget
let currentBudget = null;

// In-memory storage for expenses and goals
let expenses = [];
let savingsGoals = [];
let savingsRate = 100; // assumed monthly savings
let categories = ['Housing/Meal Plan', 'Food/Groceries', 'Transportation', 'Tuition/Loans', 'Books/Supplies', 'Entertainment/Social', 'Savings/Emergency'];
let reminders = [];

// Set view engine to EJS
app.set('view engine', 'ejs');
    
// Middleware
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.render('landing', { title: 'Home' });
});

app.get('/onboarding', (req, res) => {
  res.render('onboarding', { title: 'Onboarding' });
});

app.get('/budget', (req, res) => {
  if (currentBudget) {
    res.render('budget', { ...currentBudget, title: 'Budget' });
  } else {
    res.redirect('/onboarding');
  }
});

app.post('/budget', (req, res) => {
  const { income, rent, tuition, goals, preference } = req.body;
  const incomeNum = parseFloat(income) || 0;
  const rentNum = parseFloat(rent) || 0;
  const tuitionNum = parseFloat(tuition) || 0;

  // Basic calculations
  let food = 300; // assumed
  let transportation = 150; // assumed
  let books = 200; // assumed
  let entertainment = 250; // assumed

  let needs = rentNum + tuitionNum + food + transportation + books;
  let wants = entertainment;
  let savings = incomeNum - needs - wants;

  if (savings < 0) {
    // Adjust if over budget
    savings = 0;
    wants = Math.max(0, incomeNum - needs);
  }

  // Adjust based on preference
  if (preference === 'strict') {
    // 50/30/20
    needs = incomeNum * 0.5;
    wants = incomeNum * 0.3;
    savings = incomeNum * 0.2;
  }

  // Adjust based on goals
  if (goals === 'debt') {
    savings += 100; // extra for debt
  } else if (goals === 'graduation') {
    savings += 100; // extra for graduation
  }

  const budget = {
    income: incomeNum,
    categories: [
      { name: 'Housing/Meal Plan', amount: rentNum },
      { name: 'Food/Groceries', amount: food },
      { name: 'Transportation', amount: transportation },
      { name: 'Tuition/Loans', amount: tuitionNum },
      { name: 'Books/Supplies', amount: books },
      { name: 'Entertainment/Social', amount: wants },
      { name: 'Savings/Emergency', amount: savings }
    ]
  };
  const labels = budget.categories.map(c => c.name);
  const data = budget.categories.map(c => c.amount);
  currentBudget = { budget, labels, data };
  res.render('budget', { budget, labels, data, title: 'Budget' });
});

app.get('/progress', (req, res) => {
  res.render('progress', { title: 'Progress' });
});

app.get('/about', (req, res) => {
  res.render('about', { title: 'About' });
});

app.get('/expenses', (req, res) => {
  res.render('expenses', { title: 'Expenses', categories, expenses });
});

app.get('/goals', (req, res) => {
  res.render('goals', { title: 'Goals', savingsGoals, savingsRate });
});

app.get('/reports', (req, res) => {
  // Calculate report data
  const categorySpent = categories.map(cat => {
    return expenses.filter(e => e.category === cat).reduce((sum, e) => sum + e.amount, 0);
  });
  const categoryLabels = categories;
  const trendLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4']; // simplified
  const dailySpending = [50, 60, 40, 70]; // simplified
  const comparisonLabels = categories;
  const comparisonData = {
    budget: currentBudget ? currentBudget.data : categories.map(() => 0),
    spent: categorySpent
  };
  res.render('reports', { title: 'Reports', categoryLabels, categorySpent, trendLabels, dailySpending, comparisonLabels, comparisonData });
});

app.get('/tips', (req, res) => {
  res.render('tips', { title: 'Tips' });
});

app.get('/reminders', (req, res) => {
  res.render('reminders', { title: 'Reminders', reminders });
});

// POST routes
app.post('/expenses', (req, res) => {
  const { amount, category, date, notes } = req.body;
  expenses.push({ amount: parseFloat(amount), category, date, notes });
  res.redirect('/expenses');
});

app.post('/goals', (req, res) => {
  const { name, target } = req.body;
  const id = savingsGoals.length + 1;
  savingsGoals.push({ id, name, target: parseFloat(target), current: 0 });
  res.redirect('/goals');
});

app.post('/goals/:id/update', (req, res) => {
  const id = parseInt(req.params.id);
  const { amount } = req.body;
  const goal = savingsGoals.find(g => g.id === id);
  if (goal) {
    goal.current += parseFloat(amount);
  }
  res.redirect('/goals');
});

app.post('/reminders', (req, res) => {
  const { type, date, message } = req.body;
  reminders.push({ type, date, message });
  res.redirect('/reminders');
});

app.listen(port, () => {
  console.log(`BudgetBuddy app listening at http://localhost:${port}`);
});