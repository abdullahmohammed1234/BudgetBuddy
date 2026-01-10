const express = require('express');
const app = express();
const port = 3000;

// In-memory storage for budget
let currentBudget = null;

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

app.listen(port, () => {
  console.log(`BudgetBuddy app listening at http://localhost:${port}`);
});