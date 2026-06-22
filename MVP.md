# MVP.md

# CardMap MVP

## Goal

Help users remember:

* Which cards they use most often
* Which card to use for a category

Nothing else.

## Screen 1: My Cards

Display favorite cards.

Example:

⭐ Discover
Rotating bonus card

⭐ Costco Visa
Default gas card

⭐ Fidelity Visa
Everything else

⭐ CSP
Travel card

Features:

* Add card
* Edit card
* Delete card
* Reorder cards
* Pin card

Each card contains:

* Card name
* Optional note

No card images.

No bank logos.

Text-first design.

## Screen 2: Quick Reference

Display:

Category → Card → Reward (best rate across user's cards)

One row per category. Show the card with the highest reward for that category.

Example:

Gas → Costco Anywhere Visa → 5%

Groceries → Amex Blue Cash Preferred → 6%

Dining → Amex Gold Card → 4x

Flights → Chase Sapphire Preferred → 3x

Hotels → Chase Sapphire Preferred → 3x

Travel Portal → Chase Sapphire Reserve → 10x

Car Rentals → Chase Sapphire Preferred → 3x

Rideshare → Chase Sapphire Preferred → 3x

Streaming → Amex Blue Cash Preferred → 6%

Entertainment → Capital One Savor → 4%

Drug Stores → Discover it Cash Back → 5% (rotating)

Transit & Commute → Amex Blue Cash Preferred → 3%

Amazon → Chase Freedom Flex → 5% (rotating)

Wholesale Clubs → Chase Freedom Flex → 5% (rotating)

Home Improvement → Discover it Cash Back → 5% (rotating)

Online Shopping → Chase Sapphire Preferred → 3x

Fitness → Chase Freedom Flex → 5% (rotating)

Apple Purchases → Apple Card → 3%

PayPal Purchases → PayPal Cashback Mastercard → 3%

Everything Else → Fidelity Rewards Visa → 2%

Generated automatically from user cards and reward rules.

### Canonical Categories (22 total)

Every category is a real place people spend money. No card-marketing terms.
All reward rule entries in the JSON must use one of these exact names.

**Everyday**
- Groceries
- Gas
- Dining
- Drug Stores
- Transit & Commute

**Travel**
- Flights
- Hotels
- Car Rentals
- Rideshare
- Travel Portal *(boosted rate when booking through card's own portal)*

**Entertainment & Lifestyle**
- Streaming
- Entertainment
- Fitness

**Shopping**
- Amazon
- Wholesale Clubs
- Home Improvement
- Online Shopping

**Card-Specific**
- Apple Purchases
- PayPal Purchases

**Catch-all**
- Everything Else

### Best-Rate Logic

For each canonical category, pick the card with the highest reward rate among the user's saved cards. If two cards tie, prefer the one listed first in the user's My Cards order.

Only show a category row if the user has at least one card with a rule for that category.

### User-Configurable Cards

Some cards let the user choose their own bonus category. These cards cannot be mapped automatically — the user must declare their choice during card setup.

Cards with user-configurable categories:
- Citi Custom Cash (5% on one chosen category)
- PayPal Debit Card (custom cash back category)
- Bank of America Customized Cash (3% on one chosen category)
- U.S. Bank Cash+ (5% on two chosen categories)

**Flow:** After selecting one of these cards in the card picker, a second step appears — "What is your bonus category?" — with a picker showing the canonical category list. The user's selection is stored as a reward rule for that card.

Example result in Quick Reference:
Groceries → Citi Custom Cash → 5%

## Menu

☰

* Manage Cards
* About
* Privacy

Nothing else.

## Rotating Categories

Support:

* Discover
* Chase Freedom Flex

Use bundled JSON data.

Update category mappings automatically based on current quarter.

## Non-Goals

This app does NOT:

* Analyze spending
* Connect bank accounts
* Recommend cards
* Track benefits
* Track annual fees
* Optimize rewards
* Provide financial advice
