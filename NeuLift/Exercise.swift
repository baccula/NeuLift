import SwiftData
import Foundation

@Model
class Exercise {
    @Attribute(.unique) var id: UUID // 🔥 Add unique ID
    var name: String
    var category: String

    init(name: String, category: String = "Other") {
        self.id = UUID() // 🔥 Ensure every exercise has a unique ID
        self.name = name
        self.category = category
    }
}
