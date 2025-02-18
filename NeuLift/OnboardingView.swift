import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false // ✅ Persist state across sessions
    @State private var step = 1
    @State private var name = ""
    @State private var birthdate = Date()
    @State private var gender = "Other"
    @State private var weight = 150
    @State private var height = 70

    let genders = ["Male", "Female", "Other"]

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainView() // ✅ Persistently switches to MainView after onboarding
            } else {
                NavigationStack {
                    VStack {
                        if step == 1 {
                            WelcomeScreen(onNext: { step = 2 }) // 🔥 Step 1: Welcome Screen
                        } else if step == 2 {
                            ProfileSetupView(
                                name: $name,
                                birthdate: $birthdate,
                                gender: $gender,
                                weight: $weight,
                                height: $height,
                                onFinish: completeOnboarding
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            checkForExistingProfile()
        }
    }

    private func completeOnboarding() {
        let profile = UserProfile(name: name, birthdate: birthdate, gender: gender, weight: weight, height: height)
        modelContext.insert(profile)
        try? modelContext.save()

        // ✅ Persist completion state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            hasCompletedOnboarding = true // ✅ This prevents the app from showing onboarding again
            print("🚀 Onboarding Complete - Switching to MainView")
        }
    }

    private func checkForExistingProfile() {
        let fetchRequest = FetchDescriptor<UserProfile>()
        let profiles = (try? modelContext.fetch(fetchRequest)) ?? []
        if !profiles.isEmpty {
            hasCompletedOnboarding = true // ✅ Skip onboarding if profile exists
        }
    }
}
