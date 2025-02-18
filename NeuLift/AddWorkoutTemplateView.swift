import SwiftUI
import SwiftData

struct AddWorkoutTemplateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var exercises: [Exercise] // ✅ Fetch exercises from SwiftData
    @State private var name = ""
    @State private var selectedExercises: Set<Exercise> = [] // ✅ Track selected exercises

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Template Name")) {
                    TextField("Enter template name", text: $name)
                }

                Section(header: Text("Select Exercises")) {
                    if exercises.isEmpty {
                        Text("No exercises available. Add exercises first.")
                            .foregroundColor(.gray)
                    } else {
                        List {
                            ForEach(exercises) { exercise in
                                HStack {
                                    Text(exercise.name)
                                    Spacer()
                                    if selectedExercises.contains(exercise) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleSelection(exercise) // ✅ Fix selection logic
                                }
                            }
                        }
                    }
                }

                Button("Save Template") {
                    saveTemplate()
                }
                .disabled(name.isEmpty || selectedExercises.isEmpty)
                .frame(maxWidth: .infinity)
                .padding()
                .background(name.isEmpty || selectedExercises.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
            .navigationTitle("New Template")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func toggleSelection(_ exercise: Exercise) {
        if selectedExercises.contains(exercise) {
            selectedExercises.remove(exercise)
        } else {
            selectedExercises.insert(exercise)
        }
    }

    private func saveTemplate() {
        let newTemplate = WorkoutTemplate(name: name, exercises: Array(selectedExercises))
        modelContext.insert(newTemplate)
        try? modelContext.save()
        dismiss()
    }
}
