# BudgetBuddy

🏷️ Tagline

Your companion for smarter, stress-free budgeting - powere by Google Gemini.

BudgetBuddy is an explainable AI-powered budgeting companion that turns a user’s income and goals into a clear, personalized monthly plan they can understand and control.

🔖 Project Theme

Financial Clarity for Everyday Decision-Making

Many people want to budget responsibly but feel overwhelmed by complex tools, unclear advice, and financial anxiety. BudgetBuddy simplifies budgeting by combining educational AI reasoning with clear visual guidance—without black-box recommendations or financial risk.

❓ Problem Statement

Students and young adults often want to manage their money better, but struggle because:

Budgeting tools feel overwhelming or overly technical

Advice isn’t personalized to their situation

Tracking expenses creates stress rather than clarity

As a result, many overspend unintentionally, avoid budgeting apps altogether, and fail to build consistent saving habits.

✅ Solution Overview

BudgetBuddy transforms financial confusion into confidence by providing:

Personalized monthly budget breakdowns

Category-based spending guidance

Simple, visual progress tracking

Clear explanations behind every recommendation

⚠️ BudgetBuddy is assistive and educational, not a financial advisory or predictive system. Users remain in full control of all decisions.

🧠 AI Design Principles

Assistive, not advisory

No financial predictions or guarantees

Explainable recommendations

User-editable outputs

Designed for financial literacy, not automation

🧱 Final Tech Stack
🌐 Web Frontend

Framework: Next.js (App Router)

Styling: Tailwind CSS

UI Components: shadcn/ui

Icons: Lucide Icons

Animations: Framer Motion

Charts: Chart.js

📱 Mobile App

Framework: Flutter

Fonts: Inter, Poppins

Icons: Material Icons

Shared design system for consistency

🧠 Backend & AI

Backend: Python + FastAPI

AI Model: Google Gemini 3 Pro

AI Responsibilities:

Budget allocation reasoning

Category recommendations

Plain-language financial explanations

🗄️ Database & Authentication

Database: Firebase Firestore

Authentication: Firebase Auth

Email/password

Google sign-in

☁️ Deployment

Web: Vercel

Backend: Render or Railway

Firebase: Fully managed services

🌐 System Architecture
[ Next.js Web ] ─┐
                  ├── FastAPI Backend ── Gemini 3 Pro
[ Flutter App ] ─┘
                  │
           Firebase (Auth + Firestore)

🧭 Core Pages & MVP Features
1️⃣ Landing Page – 10-Second Hook

Purpose: Immediately communicate value

Includes:

Problem: “Budgeting feels stressful and confusing”

Solution: AI-guided, explainable budgeting

How it works (3 simple steps)

CTA: Create My Budget

2️⃣ User Onboarding

Fast, minimal, non-invasive input form

User Inputs:

Monthly income

Fixed expenses (rent, bills)

Financial goals (saving, reducing spending, emergency fund)

Budgeting preference (strict or flexible)

3️⃣ Budget Generator – ⭐ Core WOW Feature

The heart of the product

Displays:

Monthly budget breakdown

Category allocations (Needs / Wants / Savings)

Animated charts (pie or bar)

Remaining buffer amount

Example Output:

Income:          $2,500
Rent:              $900
Food:              $400
Transportation:    $200
Savings:           $500
Entertainment:     $250
Buffer:            $250

4️⃣ Trust & Transparency Layer (Judge Favorite)

Each category includes:

📊 Budgeting rule used (e.g., 50/30/20)

📚 Financial literacy principle

💡 Plain-language explanation

This ensures the AI is understandable and avoids “black-box” behavior.

5️⃣ Progress Tracker (Light MVP Version)

Spending vs budget chart

Category-level soft alerts

Monthly progress bar

Encouraging, non-judgmental messaging

Focus: Awareness, not guilt.

6️⃣ About / Impact Page

Why this matters

Importance of budgeting literacy

Target users: students & young adults

Ethical AI philosophy

Educational focus over automation

📊 Impact Metrics (Demo Estimates)

Helps users visualize spending habits

Encourages consistent saving behavior

Reduces budgeting anxiety

Improves financial understanding

🛣️ Future Roadmap (Post-Hackathon)

Smart spending insights

Goal-based savings timelines

Export summaries (CSV / PDF)

Bank integrations (future only)

🚫 No investment advice
🚫 No credit scoring
🚫 No financial predictions

🎨 Product Theme & Visual Identity
🎯 Theme

Confidence Through Financial Clarity

🎨 Color Palette

Primary: Deep Indigo #1E1B4B

Accent: Green-Blue #22C55E

Secondary: Soft Teal #2DD4BF

Text: Slate Gray #64748B

Background: Off-White #F8FAFC

Dark Mode: #0F172A

✍️ Typography

Primary: Inter

Headings: Poppins

🖼️ Visual Style

Flat, soft-gradient illustrations

Abstract finance icons

Friendly, neutral characters

Minimal AI motifs

Sources: unDraw, Storyset by Freepik
