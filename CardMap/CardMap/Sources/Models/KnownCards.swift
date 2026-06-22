import Foundation

enum KnownCards {
    static let all: [String] = {
        let fromRules = RewardStore.shared.rewardRules.map(\.cardName)
        let fromQuarterly = RewardStore.shared.quarterlyCategories.map(\.cardName)
        let configurable = configurableCards.map(\.name)
        var seen = Set<String>()
        return (fromRules + fromQuarterly + configurable)
            .filter { seen.insert($0).inserted }
            .sorted()
    }()

    static func suggestions(for query: String) -> [String] {
        guard !query.isEmpty else { return all }
        let lower = query.lowercased()
        return all.filter { $0.lowercased().contains(lower) }
    }

    struct ConfigurableCard {
        let name: String
        let rewardText: String
    }

    static let configurableCards: [ConfigurableCard] = [
        ConfigurableCard(name: "Citi Custom Cash", rewardText: "5%"),
        ConfigurableCard(name: "PayPal Debit Card", rewardText: "5%"),
        ConfigurableCard(name: "Bank of America Customized Cash", rewardText: "3%"),
        ConfigurableCard(name: "U.S. Bank Cash+", rewardText: "5%"),
    ]

    static func isConfigurable(_ cardName: String) -> Bool {
        configurableCards.contains { $0.name == cardName }
    }

    static func rewardText(for cardName: String) -> String {
        configurableCards.first { $0.name == cardName }?.rewardText ?? ""
    }

    static let canonicalCategories: [String] = [
        "Groceries",
        "Gas",
        "Dining",
        "Drug Stores",
        "Transit & Commute",
        "Flights",
        "Hotels",
        "Car Rentals",
        "Rideshare",
        "Travel Portal",
        "Streaming",
        "Entertainment",
        "Fitness",
        "Amazon",
        "Wholesale Clubs",
        "Home Improvement",
        "Online Shopping",
        "Apple Purchases",
        "PayPal Purchases",
        "Everything Else",
    ]
}
