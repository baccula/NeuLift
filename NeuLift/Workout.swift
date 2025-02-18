import SwiftData
import Foundation

@Model
class Workout {
    var date: Date
    var loggedExercises: [LoggedExercise]
    var startTime: Date?
    var endTime: Date? // 🔥 store end time

    init(date: Date, loggedExercises: [LoggedExercise] = [], startTime: Date? = nil, endTime: Date? = nil) {
        self.date = date
        self.loggedExercises = loggedExercises
        self.startTime = startTime
        self.endTime = endTime
    }

    var duration: TimeInterval? {
        guard let start = startTime, let end = endTime else { return nil }
        return end.timeIntervalSince(start)
    }
}
