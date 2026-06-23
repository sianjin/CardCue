import SwiftUI

@main
struct CardMapApp: App {
    @StateObject private var store = CardStore()
    @StateObject private var categoryOrder = CategoryOrderStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(categoryOrder)
        }
    }
}
