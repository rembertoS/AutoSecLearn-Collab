import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            GiovannaView()
                .tabItem {
                    Label("Flashcards", systemImage: "rectangle.on.rectangle")
                }

            RembertView()
                .tabItem {
                    Label("Modules", systemImage: "book.fill")
                }

            MeaganView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }

            AlecView()
                .tabItem {
                    Label("Certs", systemImage: "seal.fill")
                }
        }
        .tint(AppTheme.primary)
    }
}
