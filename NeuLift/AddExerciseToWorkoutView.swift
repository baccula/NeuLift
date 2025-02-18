//
//  AddExerciseToWorkoutView.swift
//  NeuLift
//
//  Created by Mike Neuwirth on 2/17/25.
//


import SwiftUI
import SwiftData

struct AddExerciseToWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var workout: Workout
    var exercise: Exercise

    @State private var sets: [ExerciseSet] = []

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Sets")) {
                        ForEach($sets) { $set in
                            HStack {
                                TextField("Reps", value: $set.reps, format: .number)
                                    .keyboardType(.numberPad)
                                TextField("Weight", value: $set.weight, format: .number)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        .onDelete { sets.remove(atOffsets: $0) }

                        Button("Add Set") {
                            sets.append(ExerciseSet(reps: 10, weight: 0)) // default values
                        }
                    }
                }

                Button("Save Exercise") {
                    let loggedExercise = LoggedExercise(exercise: exercise, sets: sets)
                    workout.loggedExercises.append(loggedExercise)
                    modelContext.insert(loggedExercise)
                    try? modelContext.save()
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Add Exercise")
        }
    }
}
