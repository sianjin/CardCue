import Foundation

struct UserCard: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var note: String
    var pinned: Bool
    var customCategory: String?

    init(id: UUID = UUID(), name: String, note: String = "", pinned: Bool = false, customCategory: String? = nil) {
        self.id = id
        self.name = name
        self.note = note
        self.pinned = pinned
        self.customCategory = customCategory
    }
}
