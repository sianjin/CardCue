import SwiftUI

struct CardEditView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let onSave: (UserCard) -> Void

    @State private var name: String
    @State private var note: String
    @State private var customCategories: [String]
    @State private var showingCardPicker = false
    @State private var editingSlot: Int? = nil

    private let existing: UserCard?

    @State private var didSave = false

    init(existing: UserCard? = nil, onSave: @escaping (UserCard) -> Void) {
        self.existing = existing
        self.title = existing == nil ? "New Card" : "Edit Card"
        self.onSave = onSave
        _name = State(initialValue: existing?.name ?? "")
        _note = State(initialValue: existing?.note ?? "")
        _customCategories = State(initialValue: existing?.customCategories ?? [])
    }

    private var isConfigurable: Bool { KnownCards.isConfigurable(name) }
    private var slots: Int { KnownCards.slots(for: name) }

    private var isValid: Bool {
        guard !name.isEmpty else { return false }
        if isConfigurable {
            return customCategories.filter { !$0.isEmpty }.count == slots
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Card Name") {
                    Button {
                        showingCardPicker = true
                    } label: {
                        HStack {
                            Text(name.isEmpty ? "Select a card…" : name)
                                .foregroundStyle(name.isEmpty ? .secondary : .primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tint(.primary)
                }

                if isConfigurable {
                    Section {
                        ForEach(0..<slots, id: \.self) { slot in
                            Button {
                                editingSlot = slot
                            } label: {
                                HStack {
                                    let chosen = slot < customCategories.count ? customCategories[slot] : ""
                                    Text(chosen.isEmpty ? "Select category…" : chosen)
                                        .foregroundStyle(chosen.isEmpty ? .secondary : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .tint(.primary)
                        }
                    } header: {
                        Text(slots > 1 ? "Bonus Categories" : "Bonus Category")
                    } footer: {
                        Text("This card earns \(KnownCards.rewardText(for: name)) on your chosen \(slots > 1 ? "categories" : "category").")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Cue") {
                    TextEditor(text: $note)
                        .textInputAutocapitalization(.sentences)
                        .frame(minHeight: 80)
                        .overlay(alignment: .topLeading) {
                            if note.isEmpty {
                                Text(name.isEmpty ? "e.g. When to use this card" : KnownCards.defaultCue(for: name))
                                    .foregroundStyle(.tertiary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                }


            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let card = UserCard(
                            id: existing?.id ?? UUID(),
                            name: name,
                            note: note.trimmingCharacters(in: .whitespaces),
                            customCategories: isConfigurable ? customCategories.filter { !$0.isEmpty } : []
                        )
                        onSave(card)
                        didSave = true
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
            .sensoryFeedback(.success, trigger: didSave)
            .sheet(isPresented: $showingCardPicker) {
                CardPickerView(selected: $name) {
                    if !KnownCards.isConfigurable(name) { customCategories = [] }
                    else { customCategories = Array(repeating: "", count: KnownCards.slots(for: name)) }
                }
            }
            .sheet(item: $editingSlot) { slot in
                let binding = Binding<String>(
                    get: { slot < customCategories.count ? customCategories[slot] : "" },
                    set: { value in
                        while customCategories.count <= slot { customCategories.append("") }
                        customCategories[slot] = value
                    }
                )
                CategoryPickerView(selected: binding, excludedCategories: categoriesExcludingSlot(slot))
            }
        }
    }

    private func categoriesExcludingSlot(_ slot: Int) -> Set<String> {
        var used = Set(customCategories.enumerated().compactMap { i, c in i != slot && !c.isEmpty ? c : nil })
        return used
    }
}

struct CardPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selected: String
    var onSelect: (() -> Void)? = nil
    @State private var query = ""

    private var results: [String] { KnownCards.suggestions(for: query) }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(results.enumerated()), id: \.offset) { _, card in
                    CardPickerRow(card: card, isSelected: card == selected) {
                        selected = card
                        onSelect?()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Choose Card")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search cards…")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .overlay {
                if results.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
        }
    }
}

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selected: String
    var excludedCategories: Set<String> = []
    @State private var query = ""

    private var results: [String] {
        let all = KnownCards.canonicalCategories.filter { $0 != "Everything Else" && !excludedCategories.contains($0) }
        guard !query.isEmpty else { return all }
        let lower = query.lowercased()
        return all.filter { $0.lowercased().contains(lower) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(results.enumerated()), id: \.offset) { _, category in
                    CardPickerRow(card: category, isSelected: category == selected) {
                        selected = category
                        dismiss()
                    }
                }
            }
            .navigationTitle("Bonus Category")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search categories…")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .overlay {
                if results.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
        }
    }
}

private struct CardPickerRow: View {
    let card: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(card)
                    .foregroundStyle(Color.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
