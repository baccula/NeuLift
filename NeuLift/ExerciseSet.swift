import SwiftData

@Model
class ExerciseSet {
    var reps: Int
    var weight: Int // 🔥 changed from Double to Int

    init(reps: Int, weight: Int) {
        self.reps = reps
        self.weight = weight
    }
}
