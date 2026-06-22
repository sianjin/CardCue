import SwiftUI

struct CardRowView: View {
    let card: UserCard

    var body: some View {
        HStack(spacing: 12) {
            if card.pinned {
                Image(systemName: "pin.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(card.name)
                    .font(.body)
                if !card.note.isEmpty {
                    Text(card.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
