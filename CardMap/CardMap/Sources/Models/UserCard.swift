import Foundation

struct UserCard: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var note: String
    var customCategories: [String]

    init(id: UUID = UUID(), name: String, note: String = "", customCategories: [String] = []) {
        self.id = id
        self.name = name
        self.note = note
        self.customCategories = customCategories
    }

    // Migration shim: decode old fields transparently
    enum CodingKeys: String, CodingKey {
        case id, name, note, customCategories, customCategory, pinned
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
        // pinned is ignored — drag replaced it
        if let multi = try c.decodeIfPresent([String].self, forKey: .customCategories) {
            customCategories = multi
        } else if let single = try c.decodeIfPresent(String.self, forKey: .customCategory), !single.isEmpty {
            customCategories = [single]
        } else {
            customCategories = []
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(note, forKey: .note)
        try c.encode(customCategories, forKey: .customCategories)
    }
}
