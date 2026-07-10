import SwiftUI

struct PrivacyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("CardCue stores your card names and notes locally on your device. If iCloud is enabled, a private backup is also kept in your iCloud account so your data survives reinstalling the app. CardCue has no servers and never sees your data.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section("What we collect") {
                    Label("Nothing", systemImage: "checkmark.shield")
                }

                Section("What stays on your device") {
                    Label("Card names and notes", systemImage: "iphone")
                }

                Section("What we never access") {
                    Label("Bank accounts", systemImage: "xmark.circle")
                    Label("Financial data", systemImage: "xmark.circle")
                    Label("Location", systemImage: "xmark.circle")
                    Label("Contacts", systemImage: "xmark.circle")
                }
            }
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
