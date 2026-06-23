import Foundation

final class RewardStore {
    static let shared = RewardStore()

    let rewardRules: [RewardRule]
    let quarterlyCategories: [QuarterlyCategory]

    private init() {
        rewardRules = Self.load("reward_rules")
        quarterlyCategories = Self.load("quarterly_categories")
    }

    private static func load<T: Decodable>(_ filename: String) -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return decoded
    }

    func quickReference(for cards: [UserCard]) -> [(category: String, cardName: String, reward: String, isCustom: Bool)] {
        let currentQuarter = QuarterlyCategory.currentQuarterKey()
        let cardNames = Set(cards.map(\.name))
        let cardOrder: [String: Int] = Dictionary(
            uniqueKeysWithValues: cards.enumerated().map { ($1.name, $0) }
        )

        var candidates: [(category: String, cardName: String, reward: String, value: Double, isCustom: Bool)] = []

        // Rotating quarterly categories (always 5%)
        for quarterly in quarterlyCategories where quarterly.quarter == currentQuarter && cardNames.contains(quarterly.cardName) {
            for category in quarterly.categories {
                candidates.append((category: category, cardName: quarterly.cardName, reward: "5%", value: 5.0, isCustom: false))
            }
        }

        // Static reward rules — skip "Everything Else" here; handle it separately below
        for rule in rewardRules where cardNames.contains(rule.cardName) && rule.category != "Everything Else" {
            let value = numericValue(rule.rewardText)
            candidates.append((category: rule.category, cardName: rule.cardName, reward: rule.rewardText, value: value, isCustom: false))
        }

        // User-defined custom categories for configurable cards
        for card in cards {
            guard KnownCards.isConfigurable(card.name), !card.customCategories.isEmpty else { continue }
            let reward = KnownCards.rewardText(for: card.name)
            let value = numericValue(reward)
            for category in card.customCategories {
                candidates.append((category: category, cardName: card.name, reward: reward, value: value, isCustom: true))
            }
        }

        // Everything Else: true catch-all — best flat rate across all user cards
        var bestEverythingElse: (cardName: String, reward: String, value: Double, order: Int)?
        for rule in rewardRules where cardNames.contains(rule.cardName) && rule.category == "Everything Else" {
            let value = numericValue(rule.rewardText)
            let order = cardOrder[rule.cardName] ?? Int.max
            if let current = bestEverythingElse {
                if value > current.value || (value == current.value && order < current.order) {
                    bestEverythingElse = (rule.cardName, rule.rewardText, value, order)
                }
            } else {
                bestEverythingElse = (rule.cardName, rule.rewardText, value, order)
            }
        }

        // For each non-catch-all category, pick best rate; tie-break by My Cards order
        var bestByCategory: [String: (cardName: String, reward: String, value: Double, order: Int, isCustom: Bool)] = [:]
        for c in candidates {
            let order = cardOrder[c.cardName] ?? Int.max
            if let current = bestByCategory[c.category] {
                if c.value > current.value || (c.value == current.value && order < current.order) {
                    bestByCategory[c.category] = (c.cardName, c.reward, c.value, order, c.isCustom)
                }
            } else {
                bestByCategory[c.category] = (c.cardName, c.reward, c.value, order, c.isCustom)
            }
        }

        // Append Everything Else row if any card has a rate for it
        if let ee = bestEverythingElse {
            bestByCategory["Everything Else"] = (ee.cardName, ee.reward, ee.value, ee.order, false)
        }

        // Sort by canonical order, then alphabetically for any unlisted categories
        let canonicalOrder = Dictionary(uniqueKeysWithValues: KnownCards.canonicalCategories.enumerated().map { ($1, $0) })
        return bestByCategory.map { category, best in
            (category: category, cardName: best.cardName, reward: best.reward, isCustom: best.isCustom)
        }
        .sorted { a, b in
            let ia = canonicalOrder[a.category] ?? Int.max
            let ib = canonicalOrder[b.category] ?? Int.max
            return ia == ib ? a.category < b.category : ia < ib
        }
    }

    private func numericValue(_ rewardText: String) -> Double {
        let cleaned = rewardText
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "x", with: "")
        return Double(cleaned) ?? 0
    }
}
