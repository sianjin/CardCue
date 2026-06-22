import Foundation

struct QuarterlyCategory: Codable, Identifiable {
    var cardName: String
    var quarter: String
    var categories: [String]

    var id: String { "\(cardName)_\(quarter)" }
}

extension QuarterlyCategory {
    static func currentQuarterKey() -> String {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let quarter = (month - 1) / 3 + 1
        return "\(year)Q\(quarter)"
    }
}
