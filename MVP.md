# MVP.md

# CardCue MVP

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

Generated automatically from user cards and reward rules.

### Canonical Categories

Every category is a real place people spend money. No card-marketing terms.
All reward rule entries in the JSON must use one of these exact names.

Apply subcategories only where there is a meaningful accuracy difference between specific contexts. For flat/simple categories, one row is enough.

**Everyday**
- Groceries
- Groceries – Online *(online orders, pickup, and delivery only; e.g. CSP earns 3x here)*
- Gas
- Dining
- Drug Stores
- Transit & Commute

**Rideshare** *(subcategories because key cards earn on only one platform)*
- Rideshare – Uber
- Rideshare – Lyft

**Travel**
- Flights – General *(any airline, direct booking, no portal)*
- Flights – via Portal *(boosted rate when booking through card's own travel portal)*
- Flights – Delta Only *(Delta SkyMiles cards only)*
- Flights – United Only *(United cards only)*
- Flights – Southwest Only *(Southwest cards only)*
- Flights – JetBlue Only *(Barclays JetBlue cards only)*
- Flights – American Airlines Only *(Citi AAdvantage, Barclays Aviator only)*
- Flights – Alaska Airlines Only *(BofA Alaska card only)*
- Hotels – General *(any hotel, direct booking)*
- Hotels – via Portal *(boosted rate through card travel portal)*
- Hotels – Hyatt Only *(Chase Hyatt cards only)*
- Hotels – Hilton Only *(Amex Hilton cards only)*
- Hotels – Marriott Only *(Chase/Amex Marriott cards only)*
- Hotels – IHG Only *(Chase IHG cards only)*
- Hotels – Wyndham Only *(Barclays Wyndham cards only)*
- Car Rentals
- Car Rentals – via Portal *(boosted rate when booking through card's own travel portal)*

**Entertainment & Lifestyle**
- Streaming
- Entertainment
- Fitness

**Shopping**
- Amazon & Whole Foods
- Costco
- Sam's Club
- BJ's Wholesale
- Home Improvement
- Online Shopping

**Card-Specific**
- Apple Purchases
- PayPal Purchases
- Rent *(Bilt Mastercard)*

**Catch-all**
- Everything Else *(show the highest flat-rate card the user owns; this row always appears if user has any card)*

### Best-Rate Logic

For each canonical category, pick the card with the highest reward rate among the user's saved cards. If two cards tie, prefer the one listed first in the user's My Cards order.

Only show a category row if the user has at least one card with a rule for that category — except "Everything Else" which always appears.

Everything Else is a true catch-all: among all cards the user owns, show the one with the highest "Everything Else" rate. This is meaningful because flat-rate cards (Fidelity 2%, Robinhood Gold 3%) are best for uncategorized spend.

### User-Configurable Cards

Some cards let the user choose their own bonus category. These cards cannot be mapped automatically — the user must declare their choice during card setup.

Cards with user-configurable categories:
- Citi Custom Cash (5% on one chosen category)
- Bank of America Customized Cash Cash Rewards (3% on one chosen category)
- U.S. Bank Cash+ (5% on two chosen categories)

**Flow:** After selecting one of these cards in the card picker, a second step appears — "What is your bonus category?" — with a picker showing the canonical category list. The user's selection is stored as a reward rule for that card.

Example result in Quick Reference:
Groceries → Citi Custom Cash → 5%

### Adding New Categories

Do NOT add a new category to the JSON without first:
1. Adding it to this list in MVP.md
2. Getting explicit approval

Every new category adds a permanent row to every user's Quick Reference. Keep the list tight.

## Menu

☰

* Manage Cards
* About
* Privacy

Nothing else.

## Rotating Categories

Support:

* Discover it Cash Back
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
