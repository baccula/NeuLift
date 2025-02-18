import SwiftUI
import SwiftData

struct MainView: View {
    @Query private var profiles: [UserProfile] // ✅ Fetch UserProfile safely
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true // ✅ Detect reset state
    @State private var selectedTab = 0

    var body: some View {
        if hasCompletedOnboarding, let userProfile = profiles.first {
            // ✅ Only show Main UI if onboarding is complete and a profile exists
            TabView(selection: $selectedTab) {
                HomeView(profile: userProfile)
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell.fill")
                    }
                    .tag(0)

                WorkoutTemplateView(onSelectTemplate: { _ in })
                    .tabItem {
                        Label("Templates", systemImage: "folder.fill")
                    }
                    .tag(1)

                ExerciseLibraryView()
                    .tabItem {
                        Label("Exercises", systemImage: "list.bullet")
                    }
                    .tag(2)

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
        } else {
            // ✅ If no profile exists OR onboarding was reset, show onboarding
            OnboardingView()
        }
    }
}
