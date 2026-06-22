import SwiftUI

struct QuickReferenceView: View {
    @EnvironmentObject private var store: CardStore

    private var currentQuarter: String { QuarterlyCategory.currentQuarterKey() }

    private var rows: [(category: String, cardName: String, reward: String, isCustom: Bool)] {
        RewardStore.shared.quickReference(for: store.cards)
    }

    private var rotatingCards: [String] {
        var seen = Set<String>()
        return RewardStore.shared.quarterlyCategories
            .filter { $0.quarter == currentQuarter }
            .map(\.cardName)
            .filter { name in
                store.cards.contains(where: { $0.name == name }) && seen.insert(name).inserted
            }
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
                }
            }
            .navigationTitle("Quick Reference")
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
            if !rotatingCards.isEmpty {
                Section {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.2.circlepath")
                            .font(.caption)
                        Text("Rotating: \(rotatingCards.joined(separator: ", ")) — \(currentQuarter)")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                }
            }

            Section {
                ForEach(rows, id: \.category) { row in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(row.category)
                                .font(.body)
                            Text(row.cardName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(row.reward)
                            .font(.body.monospacedDigit())
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}
