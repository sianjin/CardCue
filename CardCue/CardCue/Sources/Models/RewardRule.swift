import Foundation

struct RewardRule: Codable, Identifiable {
    var cardName: String
    var category: String
    var rewardText: String

    var id: String { "\(cardName)_\(category)" }
}
