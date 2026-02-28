import SwiftUI

struct ContentView: View {
    @Environment(UserProgressManager.self) var progressManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ModuleListView()
                .tabItem {
                    Label("Modules", systemImage: "book.fill")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(Color(hex: "667eea"))
    }
}

#Preview {
    ContentView()
        .environment(UserProgressManager())
        .environment(SoundManager())
        .environment(NotificationManager())
}
