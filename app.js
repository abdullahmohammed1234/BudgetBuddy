require('dotenv').config();
const express = require('express');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const app = express();
const port = 3000;

// Initialize Gemini AI only if key is set
let model = null;
if (process.env.GEMINI_API_KEY) {
  const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
  model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
}

// In-memory storage for budget
let currentBudget = null;

// In-memory storage for expenses and goals
let expenses = [];
let savingsGoals = [];
let savingsRate = 100; // assumed monthly savings
let categories = ['Housing/Meal Plan', 'Food/Groceries', 'Transportation', 'Tuition/Loans', 'Books/Supplies', 'Entertainment/Social', 'Savings/Emergency'];
let reminders = [];

// Function to generate budgeting tips using Gemini
async function generateBudgetTips() {
  if (!model) {
    console.log('Gemini model not initialized, using fallback tips');
    return [
      { title: 'Track Your Expenses', description: 'Keep a record of every penny you spend. This will help you understand where your money is going and identify areas to cut back.' },
      { title: 'Set Realistic Goals', description: 'Don\'t try to save too much too quickly. Set achievable goals and gradually increase your savings over time.' },
      { title: 'Use the 50/30/20 Rule', description: 'Allocate 50% of your income to needs, 30% to wants, and 20% to savings and debt repayment.' },
      { title: 'Automate Your Savings', description: 'Set up automatic transfers to your savings account so you don\'t have to think about it.' }
    ];
  }
  try {
    const prompt = "Generate 5 practical and unique budgeting tips for college students. Format each tip with a title and a brief description.";
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    // Parse the text into tips array
    const tips = text.split('\n\n').map(tip => {
      const lines = tip.split('\n');
      const title = lines[0].replace(/^\d+\.\s*/, '').trim();
      const description = lines.slice(1).join(' ').trim();
      return { title, description };
    }).filter(tip => tip.title && tip.description);
    return tips;
  } catch (error) {
    console.error('Error generating tips:', error);
    // Fallback to static tips
    return [
      { title: 'Track Your Expenses', description: 'Keep a record of every penny you spend. This will help you understand where your money is going and identify areas to cut back.' },
      { title: 'Set Realistic Goals', description: 'Don\'t try to save too much too quickly. Set achievable goals and gradually increase your savings over time.' },
      { title: 'Use the 50/30/20 Rule', description: 'Allocate 50% of your income to needs, 30% to wants, and 20% to savings and debt repayment.' },
      { title: 'Automate Your Savings', description: 'Set up automatic transfers to your savings account so you don\'t have to think about it.' }
    ];
  }
}

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

app.get('/tips', async (req, res) => {
  const tips = await generateBudgetTips();
  res.render('tips', { title: 'Tips', tips });
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