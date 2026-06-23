# DATA_MODEL.md

# CardCue Data Model

## UserCard

Stored in UserDefaults. Represents a card the user has saved.

```swift
struct UserCard: Codable, Identifiable {
    let id: UUID
    var name: String
    var note: String
    var customCategories: [String]  // non-empty only for configurable cards (Citi Custom Cash, U.S. Bank Cash+, BofA Customized Cash Rewards)
}
```

Example:
```json
{
  "id": "...",
  "name": "Citi Custom Cash",
  "note": "",
  "customCategories": ["Dining"]
}
```

Migration note: old saves may contain `pinned: Bool` (ignored on decode) and `customCategory: String` (migrated to `customCategories: [String]` automatically).

## RewardRule

Bundled in `reward_rules.json`. One entry per card-category pair.

```swift
struct RewardRule: Codable {
    var cardName: String
    var category: String
    var rewardText: String
}
```

Example:
```json
{
  "cardName": "Costco Anywhere Visa",
  "category": "Gas",
  "rewardText": "4%"
}
```

## QuarterlyCategory

Bundled in `quarterly_categories.json`. Rotating 5% bonus categories per quarter.

```swift
struct QuarterlyCategory: Codable {
    var cardName: String
    var quarter: String        // format: "2026Q3"
    var categories: [String]   // canonical category names
}
```

Example:
```json
{
  "cardName": "Chase Freedom Flex",
  "quarter": "2026Q3",
  "categories": ["Gas", "Transit & Commute", "Entertainment"]
}
```

Only include current and officially announced future quarters. See `RULES.md`.

## Storage

- `UserCard` — `UserDefaults`, key `"user_cards"`, encoded as JSON array
- Category display order — `UserDefaults`, key `"category_order"`, managed by `CategoryOrderStore`
- `RewardRule` and `QuarterlyCategory` — bundled JSON, read-only at runtime

No databases. No cloud sync. No accounts.

## Source Files

| File | Purpose |
|------|---------|
| `reward_rules.json` | All card reward rules |
| `quarterly_categories.json` | Rotating bonus categories by quarter |
