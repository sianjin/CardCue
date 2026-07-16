import SwiftUI

struct QuickReferenceView: View {
    @EnvironmentObject private var store: CardStore
    @EnvironmentObject private var categoryOrder: CategoryOrderStore

    @Binding var showingAbout: Bool
    @Binding var showingPrivacy: Bool

    @State private var editMode: EditMode = .inactive

    private var rawRows: [(category: String, cardName: String, reward: String, isCustom: Bool)] {
        RewardStore.shared.quickReference(for: store.cards)
    }

    private var rows: [(category: String, cardName: String, reward: String, isCustom: Bool)] {
        let rowMap = Dictionary(uniqueKeysWithValues: rawRows.map { ($0.category, $0) })
        return categoryOrder.order.compactMap { rowMap[$0] }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.cards.isEmpty {
                    emptyState
                } else if rows.isEmpty {
                    noRulesState
                } else {
                    referenceList
                        .onAppear {
                            ReviewRequester.requestReviewAfterQuickReferenceUse(cardCount: store.cards.count)
                        }
                }
            }
            .navigationTitle("Quick Reference")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button { showingAbout = true } label: {
                            Label("About", systemImage: "info.circle")
                        }
                        Button { showingPrivacy = true } label: {
                            Label("Privacy", systemImage: "hand.raised")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                if !rows.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(editMode == .active ? "Done" : "Edit") {
                            editMode = editMode == .active ? .inactive : .active
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        .onAppear {
            categoryOrder.sync(to: rawRows.map(\.category))
        }
        .onChange(of: rawRows.map(\.category)) { _, newCategories in
            categoryOrder.sync(to: newCategories)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Cards Added")
                .font(.headline)
            Text("Add cards in My Cards to see your quick reference.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private var noRulesState: some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Rules Found")
                .font(.headline)
            Text("No reward rules exist for your current cards.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private var referenceList: some View {
        List {
            Section {
                ForEach(rows, id: \.category) { row in
                    HStack(spacing: 12) {
                        if let symbol = KnownCards.icon(for: row.category) {
                            Image(systemName: symbol)
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .frame(width: 24)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(row.category)
                                .font(.body)
                            Text(row.cardName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(row.reward)
                            .font(.body.monospacedDigit().weight(.medium))
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 6)
                }
                .onMove { source, destination in
                    categoryOrder.move(from: source, to: destination)
                }
            }
        }
    }
}
