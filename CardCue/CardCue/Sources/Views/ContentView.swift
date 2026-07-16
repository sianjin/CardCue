import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab = 0
    @State private var showingAbout = false
    @State private var showingPrivacy = false

    var body: some View {
        TabView(selection: $selectedTab) {
            MyCardsView(showingAbout: $showingAbout, showingPrivacy: $showingPrivacy)
                .tabItem {
                    Label("My Cards", systemImage: "creditcard")
                }
                .tag(0)

            QuickReferenceView(showingAbout: $showingAbout, showingPrivacy: $showingPrivacy)
                .tabItem {
                    Label("Quick Reference", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyView()
        }
    }
}
