# RULES.md

# CardCue Data Rules

Rules for maintaining `reward_rules.json` and `quarterly_categories.json`.

## Card Name Rules

Each real-world credit card must have exactly one canonical name in `reward_rules.json`. Name mismatches are the #1 source of bugs — a user who saved a card under the old name gets no reward rules matched.

- One entry per physical card. Do NOT add issuer-prefixed aliases (e.g. "Synchrony PayPal Cashback Mastercard" when "PayPal Cashback Mastercard" already exists).
- Use the name cardholders actually call the card, not the issuer's internal name.
- Before adding a new card, search `reward_rules.json` for any existing entry for the same product. Update it rather than adding a new name.
- If a card gets renamed, update the single canonical name. Do NOT add an alias — aliases accumulate and cause the same mismatch bug.

Known canonical names:
- "PayPal Cashback Mastercard" (not "Synchrony PayPal Cashback Mastercard")
- "Fidelity Rewards Visa Signature" (not "Fidelity Rewards Visa")

## Category Rules

The canonical category list lives in `MVP.md`. It is the source of truth.

- Do NOT add a new category string to `reward_rules.json` unless it already exists in the canonical list in `MVP.md`.
- Do NOT invent new category names (e.g. "Costco", "JetBlue Purchases", "Top Spend Category", "Choice Category 1"). Use only the exact strings from the canonical list.
- If a card's bonus applies to a subcategory that doesn't exist yet, stop and ask the user to approve adding it to `MVP.md` first.

## Quarterly Rotating Category Rules

Rules for `quarterly_categories.json`:

- Only include the current quarter and future confirmed quarters. Remove past quarters when they expire — stale data adds noise.
- Do NOT add a future quarter until the card issuer officially announces it. Chase Freedom Flex and Discover typically announce one quarter at a time; do not fabricate or project future quarters.
- Each category string must match the canonical list exactly (same rules as `reward_rules.json`).
