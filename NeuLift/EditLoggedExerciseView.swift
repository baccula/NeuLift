import SwiftUI
import SwiftData

struct EditLoggedExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var loggedExercise: LoggedExercise

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text(loggedExercise.exercise.name)) {
                        HStack {
                            Text("Reps").frame(maxWidth: .infinity, alignment: .leading)
                            Text("Weight").frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .font(.headline)
                        .padding(.horizontal)

                        ForEach($loggedExercise.sets) { $set in
                            HStack {
                                TextField("Reps", value: $set.reps, format: .number)
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)

                                TextField("Weight", value: $set.weight, format: .number)
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                }

                HStack {
                    Button(action: addSet) {
                        Label("Add Set", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button(action: removeSet) {
                        Label("Remove Set", systemImage: "minus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(loggedExercise.sets.isEmpty) // 🔥 disable if no sets left
                }
                .padding()

                Button("Save Changes") {
                    try? modelContext.save()
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
            .navigationTitle("Edit Exercise")
        }
    }

    private func addSet() {
        loggedExercise.sets.append(ExerciseSet(reps: 10, weight: 0))
    }

    private func removeSet() {
        if !loggedExercise.sets.isEmpty {
            loggedExercise.sets.removeLast()
        }
    }
}
