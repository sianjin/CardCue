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
        let slots: Int  // how many bonus categories the user can choose
    }

    static let configurableCards: [ConfigurableCard] = [
        ConfigurableCard(name: "Citi Custom Cash", rewardText: "5%", slots: 1),
        ConfigurableCard(name: "Bank of America Customized Cash Rewards", rewardText: "3%", slots: 1),
        ConfigurableCard(name: "U.S. Bank Cash+", rewardText: "5%", slots: 2),
    ]

    static func isConfigurable(_ cardName: String) -> Bool {
        configurableCards.contains { $0.name == cardName }
    }

    static func rewardText(for cardName: String) -> String {
        configurableCards.first { $0.name == cardName }?.rewardText ?? ""
    }

    static func slots(for cardName: String) -> Int {
        configurableCards.first { $0.name == cardName }?.slots ?? 1
    }

    // Canonical categories in display order.
    // Do NOT add entries here without first adding them to MVP.md and getting approval.
    static let canonicalCategories: [String] = [
        // Everyday
        "Groceries",
        "Groceries – Online",
        "Gas",
        "Gas – Costco",
        "Dining",
        "Drug Stores",
        "Transit & Commute",
        // Rideshare
        "Rideshare – Uber",
        "Rideshare – Lyft",
        // Flights
        "Flights – General",
        "Flights – via Portal",
        "Flights – Delta Only",
        "Flights – United Only",
        "Flights – Southwest Only",
        "Flights – JetBlue Only",
        "Flights – American Airlines Only",
        "Flights – Alaska Airlines Only",
        // Hotels
        "Hotels – General",
        "Hotels – via Portal",
        "Hotels – Hyatt Only",
        "Hotels – Hilton Only",
        "Hotels – Marriott Only",
        "Hotels – IHG Only",
        "Hotels – Wyndham Only",
        // Other travel
        "Car Rentals",
        "Car Rentals – via Portal",
        // Entertainment & Lifestyle
        "Streaming",
        "Entertainment",
        "Fitness",
        // Shopping
        "Amazon & Whole Foods",
        "Costco",
        "Sam's Club",
        "BJ's Wholesale",
        "Home Improvement",
        "Online Shopping",
        // Card-Specific
        "Apple Purchases",
        "PayPal Purchases",
        "Rent",
        // Catch-all
        "Everything Else",
    ]
}
