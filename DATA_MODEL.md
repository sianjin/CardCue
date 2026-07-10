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

No databases. No accounts.

### iCloud backup (uninstall/reinstall only)

`CloudBackupStore` mirrors the `user_cards` and `category_order` `UserDefaults` keys to
`NSUbiquitousKeyValueStore` on every save, as a private per-account backup — not multi-device sync.

- `UserDefaults` is always the source of truth for reads while local data exists.
- On `load()`, iCloud is only consulted when the local key is empty (fresh install), and the
  restored value is written back to `UserDefaults` immediately.
- Once local data exists, incoming iCloud values are never applied automatically, so two devices
  signed into the same iCloud account never overwrite each other's data — each device just keeps
  pushing its own state as its own backup.
- Requires the `com.apple.developer.ubiquity-kvstore-identifier` entitlement
  (`CardCue/CardCue.entitlements`).

## Source Files

| File | Purpose |
|------|---------|
| `reward_rules.json` | All card reward rules |
| `quarterly_categories.json` | Rotating bonus categories by quarter |
