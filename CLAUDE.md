# CLAUDE.md

# CardCue Development Rules

Read this file before making any code changes.

## Related Docs

- `MVP.md` — canonical category list and screen specs (source of truth for categories)
- `RULES.md` — card name rules, category rules, quarterly data rules
- `DATA_MODEL.md` — current struct definitions and storage layout

Update `DATA_MODEL.md` whenever there is a structural change to a model or storage key.

## Product Philosophy

CardCue is NOT a fintech platform.

CardCue is a small utility app.

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
