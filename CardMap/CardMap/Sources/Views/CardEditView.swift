import SwiftUI

struct CardEditView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let onSave: (UserCard) -> Void

    @State private var name: String
    @State private var note: String
    @State private var pinned: Bool
    @State private var customCategory: String
    @State private var showingCardPicker = false
    @State private var showingCategoryPicker = false

    private let existing: UserCard?

    init(existing: UserCard? = nil, onSave: @escaping (UserCard) -> Void) {
        self.existing = existing
        self.title = existing == nil ? "New Card" : "Edit Card"
        self.onSave = onSave
        _name = State(initialValue: existing?.name ?? "")
        _note = State(initialValue: existing?.note ?? "")
        _pinned = State(initialValue: existing?.pinned ?? false)
        _customCategory = State(initialValue: existing?.customCategory ?? "")
    }

    private var isConfigurable: Bool { KnownCards.isConfigurable(name) }
    private var isValid: Bool { !name.isEmpty && (!isConfigurable || !customCategory.isEmpty) }

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
                        Button {
                            showingCategoryPicker = true
                        } label: {
                            HStack {
                                Text(customCategory.isEmpty ? "Select bonus category…" : customCategory)
                                    .foregroundStyle(customCategory.isEmpty ? .secondary : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .tint(.primary)
                    } header: {
                        Text("Bonus Category")
                    } footer: {
                        Text("This card earns \(KnownCards.rewardText(for: name)) on your chosen category.")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Note") {
                    TextField("e.g. No foreign transaction fee", text: $note)
                        .textInputAutocapitalization(.sentences)
                }

                Section {
                    Toggle("Pin to top", isOn: $pinned)
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
                            pinned: pinned,
                            customCategory: isConfigurable ? customCategory : nil
                        )
                        onSave(card)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showingCardPicker) {
                CardPickerView(selected: $name) {
                    // Clear custom category when card changes
                    if !KnownCards.isConfigurable(name) { customCategory = "" }
                }
            }
            .sheet(isPresented: $showingCategoryPicker) {
                CategoryPickerView(selected: $customCategory)
            }
        }
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
    @State private var query = ""

    private var results: [String] {
        let all = KnownCards.canonicalCategories.filter { $0 != "Everything Else" }
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
