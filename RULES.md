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

## VERIFY_CARDS.md Sync Rule

`VERIFY_CARDS.md` must be an exact mirror of `reward_rules.json` — every card and every category in the JSON must have a corresponding entry in the checklist, and vice versa.

- When you add or remove a rule in `reward_rules.json`, update `VERIFY_CARDS.md` in the same commit.
- When you add or remove a card from `reward_rules.json`, add or remove the card section in `VERIFY_CARDS.md`.
- Mark new entries as `[ ]` (unverified) until confirmed against the issuer's official page.
- To check for drift, run: `python3 -c "import json,re; rules=json.load(open('CardCue/CardCue/Resources/reward_rules.json')); checklist={}; [checklist.setdefault(r['cardName'],set()).add(r['category']) for r in rules]; ..."` — or just diff manually.

Note: `VERIFY_CARDS.md` does NOT include rotating quarterly categories — those live in `quarterly_categories.json` and are verified separately each quarter.

## Quarterly Rate Verification

At the start of each quarter, re-verify all card rates in `VERIFY_CARDS.md` against issuer websites. Use Gemini (or another AI with live web access) to bulk-check rates that may have changed.

Workflow:
1. Open `VERIFY_CARDS.md` and identify any entries marked `[ ]` or with a verification date older than 3 months.
2. Ask Gemini: *"What is the current reward rate for [card] in [category] based on the issuer's official benefits page?"* — do not trust third-party comparison sites.
3. Update the rate in `reward_rules.json` if it changed.
4. Update the checklist entry to `[x] ... ✓ verified YYYY-MM-DD`.
5. Run a build and commit the updated JSON.

Do NOT update rates based solely on Gemini's answer — always confirm against the issuer's official page before committing.

## Quarterly Rotating Category Rules

Rules for `quarterly_categories.json`:

- Only include the current quarter and future confirmed quarters. Remove past quarters when they expire — stale data adds noise.
- Do NOT add a future quarter until the card issuer officially announces it. Chase Freedom Flex and Discover typically announce one quarter at a time; do not fabricate or project future quarters.
- Each category string must match the canonical list exactly (same rules as `reward_rules.json`).
