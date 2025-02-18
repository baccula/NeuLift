import SwiftUI
import SwiftData

@main
struct NeuLiftApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: [UserProfile.self, Workout.self, Exercise.self, WorkoutTemplate.self]) // ✅ Attach SwiftData
        }
    }
}
