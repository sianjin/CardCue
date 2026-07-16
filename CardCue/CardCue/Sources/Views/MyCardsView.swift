import SwiftUI

struct MyCardsView: View {
    @EnvironmentObject private var store: CardStore

    @Binding var showingAbout: Bool
    @Binding var showingPrivacy: Bool

    @State private var showingAdd = false
    @State private var editingCard: UserCard? = nil
    @State private var deleteCount = 0

    var body: some View {
        NavigationStack {
            Group {
                if store.cards.isEmpty {
                    emptyState
                } else {
                    cardList
                }
            }
            .navigationTitle("My Cards")
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
                if !store.cards.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                CardEditView { card in store.add(card) }
            }
            .sheet(item: $editingCard) { card in
                CardEditView(existing: card) { updated in store.update(updated) }
            }
            .sensoryFeedback(.impact, trigger: deleteCount)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "creditcard")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Cards Yet")
                .font(.headline)
            Text("Tap + to add your first card.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var cardList: some View {
        List {
            ForEach(store.cards) { card in
                CardRowView(card: card)
                    .contentShape(Rectangle())
                    .onTapGesture { editingCard = card }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = store.cards.firstIndex(where: { $0.id == card.id }) {
                                store.delete(at: IndexSet([index]))
                                deleteCount += 1
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .onDelete {
                store.delete(at: $0)
                deleteCount += 1
            }
            .onMove { store.move(from: $0, to: $1) }
        }
    }
}
