import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true // ✅ Track onboarding state
    @State private var showingResetConfirmation = false
    @State private var shouldReset = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("App Settings")) {
                    Button(role: .destructive, action: {
                        showingResetConfirmation = true
                    }) {
                        Label("Reset App", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset App?", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) {}

                Button("Reset", role: .destructive) {
                    shouldReset = true
                }
            } message: {
                Text("This will delete all user data, workouts, exercises, and templates. This action cannot be undone.")
            }
            .onChange(of: shouldReset) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        resetApp()
                        shouldReset = false
                    }
                }
            }
        }
    }

    private func resetApp() {
        let entityTypes: [any PersistentModel.Type] = [UserProfile.self, Workout.self, Exercise.self, WorkoutTemplate.self]

        for entityType in entityTypes {
            deleteAllInstances(of: entityType)
        }

        try? modelContext.save()

        // ✅ Ensure app resets back to onboarding
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding") // ✅ Force onboarding
        }
    }

    private func deleteAllInstances<T: PersistentModel>(of type: T.Type) {
        let fetchRequest = FetchDescriptor<T>()
        if let results = try? modelContext.fetch(fetchRequest) {
            for object in results {
                modelContext.delete(object)
            }
        }
    }
}
