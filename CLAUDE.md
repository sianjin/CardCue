# CLAUDE.md

# CardMap Development Rules

Read this file before making any code changes.

## Product Philosophy

CardMap is NOT a fintech platform.

CardMap is a small utility app.

Its goal is to be only slightly better than Apple Notes for managing credit card usage rules.

Users should open the app, find the answer they need in a few seconds, and close it.

## Core Principles

1. Simplicity over features
2. Local-first
3. No user accounts
4. No financial data access
5. No subscriptions
6. No AI
7. No analytics
8. No tracking

If there is a choice between a simple solution and a powerful solution, always choose the simple solution.

## Technology Constraints

Use:

* SwiftUI
* UserDefaults
* Codable
* Bundled JSON

Avoid:

* Backend
* Database servers
* Cloud sync
* Firebase
* Plaid
* Bank APIs

## Never Build

Do NOT add:

* AI assistant
* Chat interface
* Credit score tracking
* Spending tracking
* Budget tracking
* Expense tracking
* Annual fee analysis
* Benefit tracking
* Wallet health score
* Reward optimization engine
* Card recommendation engine
* New card suggestions
* Affiliate links
* Push notifications
* Social features
* User accounts
* Cloud backup
* Premium subscriptions

## Success Criteria

A user can:

* Save favorite cards
* Add short notes
* Quickly see which card to use
* View rotating category updates

If these goals are met, the feature set is complete.
