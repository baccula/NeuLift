import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]

    var body: some View {
        if let profile = profiles.first {
            TabView {
                HomeView(profile: profile)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
            }
        } else {
            OnboardingView()
        }
    }
}
