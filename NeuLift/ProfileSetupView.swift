import SwiftUI
import SwiftData

struct ProfileSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var name: String
    @Binding var birthdate: Date
    @Binding var gender: String
    @Binding var weight: Int
    @Binding var height: Int
    var onFinish: () -> Void

    let genders = ["Male", "Female", "Other"]

    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                TextField("Name", text: $name)
                DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                Picker("Gender", selection: $gender) {
                    ForEach(genders, id: \.self) { Text($0) }
                }
            }
            
            Section(header: Text("Body Metrics")) {
                Stepper("Weight: \(weight) lbs", value: $weight, in: 90...350)
                Stepper("Height: \(height) in", value: $height, in: 55...84)
            }
            
            Button("Save & Continue") {
                saveProfile()
            }
            .disabled(name.isEmpty)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
        }
        .navigationTitle("Setup Profile")
        .onAppear {
            print("🔄 ProfileSetupView appeared")
        }
    }

    private func saveProfile() {
        let profile = UserProfile(name: name, birthdate: birthdate, gender: gender, weight: weight, height: height)

        modelContext.insert(profile)

        do {
            try modelContext.save()
            print("✅ Profile successfully saved: \(profile)") // 🔥 Debug print
        } catch {
            print("❌ Error saving profile: \(error)") // 🔥 Debug print
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            print("🚀 Calling onFinish()")
            onFinish()
        }
    }
}
