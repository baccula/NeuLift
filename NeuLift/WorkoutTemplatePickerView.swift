import SwiftUI
import SwiftData

struct WorkoutTemplatePickerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss // ✅ Allows closing the view
    @Query private var templates: [WorkoutTemplate] // Fetch templates
    let onSelect: (WorkoutTemplate) -> Void
    @State private var showingAddTemplate = false // ✅ Controls Add Template sheet

    var body: some View {
        NavigationStack {
            VStack {
                if templates.isEmpty {
                    VStack {
                        Text("No templates found.")
                            .foregroundColor(.gray)
                            .padding()

                        Button(action: { showingAddTemplate = true }) {
                            Label("Create New Template", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding()
                        }
                    }
                } else {
                    List {
                        ForEach(templates) { template in
                            Button {
                                onSelect(template)
                                dismiss() // ✅ Close after selecting a template
                            } label: {
                                Text(template.name)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Template")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTemplate = true }) {
                        Image(systemName: "plus") // ✅ "+" button in nav bar
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() } // ✅ Close button
                }
            }
            .sheet(isPresented: $showingAddTemplate) {
                AddWorkoutTemplateView()
            }
        }
    }
}
