import Foundation
import Combine

final class CardStore: ObservableObject {
    @Published var cards: [UserCard] = []

    private let storageKey = "user_cards"

    init() {
        load()
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([UserCard].self, from: data) else {
            return
        }
        cards = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func add(_ card: UserCard) {
        cards.append(card)
        save()
    }

    func update(_ card: UserCard) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        cards[index] = card
        save()
    }

    func delete(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        save()
    }

    func move(from source: IndexSet, to destination: Int) {
        cards.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func saveCurrentOrder() {
        save()
    }
}
