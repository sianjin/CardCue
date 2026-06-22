import SwiftUI

struct MyCardsView: View {
    @EnvironmentObject private var store: CardStore

    @Binding var showingAbout: Bool
    @Binding var showingPrivacy: Bool

    @State private var showingAdd = false
    @State private var editingCard: UserCard? = nil

    private var pinnedCards: [UserCard] { store.cards.filter(\.pinned) }
    private var unpinnedCards: [UserCard] { store.cards.filter { !$0.pinned } }

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
                        Button {
                            showingAbout = true
                        } label: {
                            Label("About", systemImage: "info.circle")
                        }
                        Button {
                            showingPrivacy = true
                        } label: {
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
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                CardEditView { card in
                    store.add(card)
                }
            }
            .sheet(item: $editingCard) { card in
                CardEditView(existing: card) { updated in
                    store.update(updated)
                }
            }
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
            if !pinnedCards.isEmpty {
                Section("Pinned") {
                    ForEach(pinnedCards) { card in
                        cardRow(card)
                    }
                    .onDelete { offsets in
                        deleteFromSection(offsets: offsets, pinned: true)
                    }
                    .onMove { source, destination in
                        moveInSection(source: source, destination: destination, pinned: true)
                    }
                }
            }

            if !unpinnedCards.isEmpty {
                Section(pinnedCards.isEmpty ? "" : "Cards") {
                    ForEach(unpinnedCards) { card in
                        cardRow(card)
                    }
                    .onDelete { offsets in
                        deleteFromSection(offsets: offsets, pinned: false)
                    }
                    .onMove { source, destination in
                        moveInSection(source: source, destination: destination, pinned: false)
                    }
                }
            }
        }
    }

    private func cardRow(_ card: UserCard) -> some View {
        CardRowView(card: card)
            .contentShape(Rectangle())
            .onTapGesture {
                editingCard = card
            }
            .swipeActions(edge: .leading) {
                Button {
                    store.togglePin(card)
                } label: {
                    Label(card.pinned ? "Unpin" : "Pin", systemImage: card.pinned ? "pin.slash" : "pin")
                }
                .tint(.orange)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    if let index = store.cards.firstIndex(where: { $0.id == card.id }) {
                        store.delete(at: IndexSet([index]))
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }

    private func deleteFromSection(offsets: IndexSet, pinned: Bool) {
        let section = pinned ? pinnedCards : unpinnedCards
        let globalIndices = offsets.compactMap { offset -> Int? in
            let card = section[offset]
            return store.cards.firstIndex(where: { $0.id == card.id })
        }
        store.delete(at: IndexSet(globalIndices))
    }

    private func moveInSection(source: IndexSet, destination: Int, pinned: Bool) {
        var section = pinned ? pinnedCards : unpinnedCards
        section.move(fromOffsets: source, toOffset: destination)

        if pinned {
            store.cards = section + store.cards.filter { !$0.pinned }
        } else {
            store.cards = store.cards.filter(\.pinned) + section
        }
        store.saveCurrentOrder()
    }
}
