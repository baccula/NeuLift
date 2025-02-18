import SwiftUI
import SwiftData

struct EditWorkoutTemplateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var template: WorkoutTemplate
    @Query private var exercises: [Exercise]
    @State private var selectedExercises: [Exercise] = []

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Template Name")) {
                    TextField("Enter template name", text: $template.name)
                }

                Section(header: Text("Select Exercises")) {
                    List {
                        ForEach(exercises) { exercise in
                            HStack {
                                Text(exercise.name)
                                Spacer()
                                if selectedExercises.contains(where: { $0.id == exercise.id }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(exercise)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Template")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() } // ✅ Top-right save link remains
                }
            }
            .onAppear {
                selectedExercises = template.exercises
            }
        }
    }

    private func toggleSelection(_ exercise: Exercise) {
        if let index = selectedExercises.firstIndex(where: { $0.id == exercise.id }) {
            selectedExercises.remove(at: index)
        } else {
            selectedExercises.append(exercise)
        }
    }

    private func saveChanges() {
        template.exercises = selectedExercises
        try? modelContext.save()
        dismiss()
    }
}
