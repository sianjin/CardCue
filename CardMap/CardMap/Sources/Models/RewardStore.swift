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

        // Collect all candidate rules: (category, cardName, rewardText, numericValue, isCustom)
        var candidates: [(category: String, cardName: String, reward: String, value: Double, isCustom: Bool)] = []

        // Rotating quarterly categories (always 5%)
        for quarterly in quarterlyCategories where quarterly.quarter == currentQuarter && cardNames.contains(quarterly.cardName) {
            for category in quarterly.categories {
                candidates.append((category: category, cardName: quarterly.cardName, reward: "5%", value: 5.0, isCustom: false))
            }
        }

        // Static reward rules
        for rule in rewardRules where cardNames.contains(rule.cardName) {
            let value = numericValue(rule.rewardText)
            candidates.append((category: rule.category, cardName: rule.cardName, reward: rule.rewardText, value: value, isCustom: false))
        }

        // User-defined custom category rules
        for card in cards {
            guard let customCategory = card.customCategory,
                  KnownCards.isConfigurable(card.name) else { continue }
            let reward = KnownCards.rewardText(for: card.name)
            let value = numericValue(reward)
            candidates.append((category: customCategory, cardName: card.name, reward: reward, value: value, isCustom: true))
        }

        // For each category, pick best rate; tie-break by My Cards order
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

        // Sort by canonical order, then alphabetically for any uncategorized
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

    // Parse "5%", "3x", "4%" etc. into a comparable Double
    private func numericValue(_ rewardText: String) -> Double {
        let cleaned = rewardText.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "x", with: "")
        return Double(cleaned) ?? 0
    }
}
