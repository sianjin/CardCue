import Foundation
import Combine

final class CategoryOrderStore: ObservableObject {
    @Published var order: [String] = []

    private let storageKey = "category_order"

    init() {
        load()
    }

    // Merges the live category list into the saved order:
    // - preserves the user's existing order
    // - appends any new categories (in canonical order) at the end
    // - removes categories that no longer appear in active rows
    func sync(to activeCategories: [String]) {
        let active = Set(activeCategories)
        var merged = order.filter { active.contains($0) }
        let existing = Set(merged)
        let canonical = KnownCards.canonicalCategories
        for category in canonical where active.contains(category) && !existing.contains(category) {
            merged.append(category)
        }
        if merged != order {
            order = merged
            save()
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        order.move(fromOffsets: source, toOffset: destination)
        save()
    }

    private func load() {
        if let saved = UserDefaults.standard.stringArray(forKey: storageKey) {
            order = saved
        }
    }

    private func save() {
        UserDefaults.standard.set(order, forKey: storageKey)
    }
}
