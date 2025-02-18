import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise] // ✅ Fetch stored exercises
    @State private var showingAddExercise = false

    var body: some View {
        NavigationStack {
            List {
                if exercises.isEmpty {
                    Text("❌ No exercises found. Try adding one.").foregroundColor(.red)
                } else {
                    ForEach(exercises) { exercise in
                        Text(exercise.name)
                    }
                }
            }
            .navigationTitle("Exercise Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExercise = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView()
                    .onDisappear {
                        try? modelContext.save() // 🔥 Ensure changes persist
                    }
                    .onAppear {
                        let request = FetchDescriptor<Exercise>()
                        let results = (try? modelContext.fetch(request)) ?? []
                        print("📌 Exercises in Library on Load:", results.map { $0.name })  // 🔥 Debug at app launch
                    }
            }
        }
    }

    private func deleteExercise(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(exercises[index])
        }
        try? modelContext.save()
    }
}
