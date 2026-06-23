import SwiftUI

@main
struct CardCueApp: App {
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
