const express = require('express');
const app = express();
const port = 3000;

// Set view engine to EJS
app.set('view engine', 'ejs');

// Serve static files
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
  res.render('landing');
});

app.get('/onboarding', (req, res) => {
  res.render('onboarding');
});

app.get('/budget', (req, res) => {
  // Dummy data for now
  const budget = {
    income: 2500,
    categories: [
      { name: 'Rent', amount: 900 },
      { name: 'Food', amount: 400 },
      { name: 'Transportation', amount: 200 },
      { name: 'Savings', amount: 500 },
      { name: 'Entertainment', amount: 250 },
      { name: 'Buffer', amount: 250 }
    ]
  };
  const labels = budget.categories.map(c => c.name);
  const data = budget.categories.map(c => c.amount);
  res.render('budget', { budget, labels, data });
});

app.get('/progress', (req, res) => {
  res.render('progress');
});

app.get('/about', (req, res) => {
  res.render('about');
});

app.listen(port, () => {
  console.log(`BudgetBuddy app listening at http://localhost:${port}`);
});