# DATA_MODEL.md

# CardMap Data Model

## UserCard

```swift
struct UserCard: Codable, Identifiable {
    let id: UUID

    var name: String

    var note: String

    var pinned: Bool
}
```

Example:

```json
{
  "id": "...",
  "name": "Costco Visa",
  "note": "Default gas card",
  "pinned": true
}
```

## RewardRule

Represents category mappings.

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
  "cardName": "Costco Visa",
  "category": "Gas",
  "rewardText": "5%"
}
```

## QuarterlyCategory

Used for rotating bonus cards.

```swift
struct QuarterlyCategory: Codable {
    var cardName: String

    var quarter: String

    var categories: [String]
}
```

Example:

```json
{
  "cardName": "Discover",
  "quarter": "2026Q3",
  "categories": [
    "Gas",
    "EV Charging"
  ]
}
```

## Storage

Use:

* UserDefaults
* Codable JSON

No databases.

No cloud sync.

No accounts.

## Source Files

cards.json

reward_rules.json

quarterly_categories.json

