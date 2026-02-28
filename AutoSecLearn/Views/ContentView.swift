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
                    Label("Giovanna", systemImage: "person.fill")
                }

            RembertView()
                .tabItem {
                    Label("Rembert", systemImage: "person.fill")
                }

            MeaganView()
                .tabItem {
                    Label("Meagan", systemImage: "person.fill")
                }

            AlecView()
                .tabItem {
                    Label("Alec", systemImage: "person.fill")
                }
        }
        .tint(AppTheme.primary)
    }
}
