import SwiftUI

@main
struct CardMapApp: App {
    @StateObject private var store = CardStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
