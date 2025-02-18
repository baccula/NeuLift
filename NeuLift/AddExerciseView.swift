import SwiftUI
import SwiftData

struct AddExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var category = "Other"

    let categories = ["Upper Body", "Lower Body", "Core", "Cardio", "Other"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Exercise Details")) {
                    TextField("Exercise Name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                }

                Button("Save Exercise") {
                    saveExercise()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("New Exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func saveExercise() {
        let newExercise = Exercise(name: name, category: category)
        modelContext.insert(newExercise)

        do {
            try modelContext.save()
            print("✅ Exercise saved: \(newExercise.name)")
            
            // 🔥 Fetch all exercises after saving
            let request = FetchDescriptor<Exercise>()
            let results = (try? modelContext.fetch(request)) ?? []
            print("📌 All Exercises After Save:", results.map { $0.name })  // 🔥 Confirm saved items
            
            dismiss()
        } catch {
            print("❌ Error saving exercise: \(error)")
        }
    }

    // 🔥 Function to print all exercises
    private func exercisesList() -> [String] {
        let request = FetchDescriptor<Exercise>()
        let results = (try? modelContext.fetch(request)) ?? []
        return results.map { $0.name }
    }
}
