import SwiftUI
import SwiftData

struct ExercisePickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise] // fetch stored exercises
    let onSelect: ([Exercise]) -> Void
    @State private var selectedExercises: Set<Exercise> = []

    var body: some View {
        NavigationStack {
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
                    .contentShape(Rectangle()) // Makes the whole row tappable
                    .onTapGesture {
                        toggleSelection(exercise)
                    }
                }
            }
            .navigationTitle("Select Exercises")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onSelect(Array(selectedExercises))
                    }
                    .disabled(selectedExercises.isEmpty)
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
}
