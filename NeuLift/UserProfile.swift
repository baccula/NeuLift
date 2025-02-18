import SwiftData
import Foundation

@Model
class UserProfile {
    var name: String       // 🔹 User's name
    var birthdate: Date    // 🔹 Birthdate (used instead of age)
    var gender: String     // 🔹 Gender selection
    var weight: Int        // 🔹 Weight in pounds (lbs)
    var height: Int        // 🔹 Height in inches

    init(name: String, birthdate: Date, gender: String, weight: Int, height: Int) {
        self.name = name
        self.birthdate = birthdate
        self.gender = gender
        self.weight = weight
        self.height = height
    }
}
