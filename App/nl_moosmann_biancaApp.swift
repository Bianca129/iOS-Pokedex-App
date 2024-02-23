import SwiftUI

@main
struct PokemonApp: App {
    @State private var systemLanguage: String = Locale.current.languageCode ?? "en"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, .init(identifier: systemLanguage))
        }
    }
}



