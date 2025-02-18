import SwiftUI
import SwiftData

struct WorkoutTemplateView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var templates: [WorkoutTemplate] // 🔥 fetch saved templates
    @State private var showingAddTemplate = false

    var onSelectTemplate: (WorkoutTemplate) -> Void // 🔥 Allow selection

    var body: some View {
        NavigationStack {
            List {
                ForEach(templates) { template in
                    Button(action: { // 🔥 Allow selection
                        onSelectTemplate(template)
                    }) {
                        Text(template.name)
                    }
                }
                .onDelete(perform: deleteTemplate)
            }
            .navigationTitle("Workout Templates")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTemplate = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTemplate) {
                AddWorkoutTemplateView()
            }
        }
    }

    private func deleteTemplate(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(templates[index])
        }
    }
}
