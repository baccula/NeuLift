import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout] // Fetch past workouts

    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts.sorted(by: { $0.date > $1.date })) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            Text("\(workout.loggedExercises.count) exercises")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteWorkout) // 🔥 Enables swipe-to-delete
            }
            .navigationTitle("Workout History")
            .toolbar {
                EditButton() // 🔥 Enables bulk delete mode
            }
        }
    }

    private func deleteWorkout(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(workouts[index]) // Remove from SwiftData
        }
        try? modelContext.save() // Save changes
    }
}
