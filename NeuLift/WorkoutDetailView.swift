import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var workout: Workout
    @State private var showingExercisePicker = false
    @State private var showingTemplatePicker = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    // Rest Timer State
    @State private var restTime: TimeInterval = 0
    @State private var restTimer: Timer?
    @State private var showingRestTimer = false
    @State private var activeExercise: LoggedExercise?

    var body: some View {
        NavigationStack {
            VStack {
                // Session Timer
                Text("Workout Duration: \(formattedDuration(elapsedTime))")
                    .font(.title2)
                    .padding()
                    .onAppear {
                        if workout.startTime != nil && workout.endTime == nil {
                            startTimer()
                        } else {
                            elapsedTime = workout.duration ?? 0
                        }
                    }
                
                // Scrollable Exercise List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($workout.loggedExercises) { $loggedExercise in
                            LoggedExerciseRowView(
                                loggedExercise: $loggedExercise,
                                onPlayButton: {
                                    // Set the active exercise and start the rest timer.
                                    activeExercise = loggedExercise
                                    startRestTimer()
                                },
                                onRemoveSet: {
                                    removeSet(from: loggedExercise)
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // End Workout Button
                if workout.endTime == nil {
                    Button(action: endWorkout) {
                        Label("End Workout", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    }
                }
            }
            .navigationTitle(workout.date.formatted(date: .abbreviated, time: .omitted))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingTemplatePicker = true }) {
                        Image(systemName: "folder.fill.badge.plus")
                    }
                    Button(action: { showingExercisePicker = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingTemplatePicker, content: {
                WorkoutTemplateView(onSelectTemplate: { selectedTemplate in
                    applyTemplate(selectedTemplate)
                    showingTemplatePicker = false
                })
            })
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { selectedExercises in
                    for exercise in selectedExercises {
                        if !workout.loggedExercises.contains(where: { $0.exercise.name == exercise.name }) {
                            let loggedExercise = LoggedExercise(
                                exercise: exercise,
                                sets: [ExerciseSet(reps: 0, weight: 0)]
                            )
                            workout.loggedExercises.append(loggedExercise)
                            modelContext.insert(loggedExercise)
                        }
                    }
                    try? modelContext.save()
                    showingExercisePicker = false
                }
            }
            .fullScreenCover(isPresented: $showingRestTimer) {
                RestTimerView(
                    restTime: $restTime,
                    onNextSet: nextSet,
                    onNextExercise: nextExercise
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func applyTemplate(_ template: WorkoutTemplate) {
        for exercise in template.exercises {
            if !workout.loggedExercises.contains(where: { $0.exercise.name == exercise.name }) {
                let loggedExercise = LoggedExercise(
                    exercise: exercise,
                    sets: [ExerciseSet(reps: 0, weight: 0)]
                )
                workout.loggedExercises.append(loggedExercise)
                modelContext.insert(loggedExercise)
            }
        }
        try? modelContext.save()
    }
    
    private func removeSet(from loggedExercise: LoggedExercise) {
        if !loggedExercise.sets.isEmpty {
            loggedExercise.sets.removeLast()
            
            // If no sets remain, remove the entire exercise from the session.
            if loggedExercise.sets.isEmpty {
                if let index = workout.loggedExercises.firstIndex(where: { $0.exercise.id == loggedExercise.exercise.id }) {
                    workout.loggedExercises.remove(at: index)
                }
            }
        }
    }
    
    private func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
    
    private func startTimer() {
        guard workout.endTime == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let startTime = workout.startTime {
                elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    private func endWorkout() {
        workout.endTime = Date()
        try? modelContext.save()
        timer?.invalidate()
        timer = nil
        dismiss()
    }
    
    private func startRestTimer() {
        restTime = 0
        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            restTime += 1
        }
        showingRestTimer = true
    }
    
    private func nextSet() {
        stopRestTimer()
        if let exercise = activeExercise {
            exercise.sets.append(ExerciseSet(reps: 0, weight: 0))
            try? modelContext.save()
        }
    }
    
    private func nextExercise() {
        stopRestTimer()
    }
    
    private func stopRestTimer() {
        restTimer?.invalidate()
        restTimer = nil
        showingRestTimer = false
    }
}

struct LoggedExerciseRowView: View {
    @Binding var loggedExercise: LoggedExercise
    var onPlayButton: (() -> Void)?
    var onRemoveSet: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(loggedExercise.exercise.name)
                .font(.headline)
            
            // Header for Weight and Reps columns.
            HStack {
                Spacer()
                Text("Weight")
                    .frame(width: 60, alignment: .center)
                Spacer()
                Text("Reps")
                    .frame(width: 60, alignment: .center)
                Spacer()
            }
            .font(.subheadline)
            .bold()
            
            // Input Fields for Sets.
            VStack {
                ForEach(loggedExercise.sets.indices, id: \.self) { index in
                    let isLastSet = index == loggedExercise.sets.count - 1
                    HStack {
                        // Weight Input
                        TextField("Weight", value: $loggedExercise.sets[index].weight, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        Spacer(minLength: 20)

                        // Reps Input
                        TextField("Reps", value: $loggedExercise.sets[index].reps, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        Spacer(minLength: 20)

                        // 🔥 Keep Alignment: Make Sure Every Row Has Reserved Button Space
                        if isLastSet {
                            Button(action: { onPlayButton?() }) {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }

                            Button(action: { onRemoveSet?() }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                            .disabled(loggedExercise.sets.isEmpty)
                        } else {
                            // 🔥 Invisible Buttons to Maintain Alignment
                            Image(systemName: "circle.fill") // Placeholder for Play button
                                .opacity(0)
                                .frame(width: 30)
                            
                            Image(systemName: "circle.fill") // Placeholder for Remove button
                                .opacity(0)
                                .frame(width: 30)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
