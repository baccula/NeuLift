import SwiftData

@Model
class LoggedExercise {
    var exercise: Exercise

    @Relationship(deleteRule: .cascade) // ensures sets are deleted when this exercise is removed
    var sets: [ExerciseSet]

    init(exercise: Exercise, sets: [ExerciseSet] = []) {
        self.exercise = exercise
        self.sets = sets
    }
}
