import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    
    let profile: UserProfile
    @State private var newWorkout: Workout?

    var body: some View {
        NavigationStack {
            VStack {
                if workouts.isEmpty {
                    ContentUnavailableView("No Workouts Yet", systemImage: "list.bullet.rectangle", description: Text("Tap the button below to start your first workout."))
                } else {
                    List {
                        Section {
                            ForEach(workouts.prefix(3)) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    VStack(alignment: .leading) {
                                        Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.headline)

                                        if let duration = workout.duration {
                                            Text("Duration: \(formattedDuration(duration))")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }

                                        Text("\(workout.loggedExercises.count) exercises")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        } header: {
                            Text("Recent Workouts")
                        }

                        Section {
                            NavigationLink(destination: HistoryView()) {
                                Label("View All Workouts", systemImage: "clock")
                            }
                        }
                    }
                }

                Spacer()

                Button(action: startNewWorkout) {
                    Label("Start Workout", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
            }
            .navigationTitle("Welcome, \(profile.name)")
            .navigationDestination(item: $newWorkout) { workout in
                WorkoutDetailView(workout: workout)
            }
        }
    }

    private func startNewWorkout() {
        let workout = Workout(date: Date(), loggedExercises: [], startTime: Date()) // 🔥 start timer
        modelContext.insert(workout)
        newWorkout = workout
    }

    private func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
}
