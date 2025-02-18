import SwiftUI

struct RestTimerView: View {
    @Binding var restTime: TimeInterval
    var onNextSet: () -> Void
    var onNextExercise: () -> Void

    var body: some View {
        VStack {
            Text("Rest Timer")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("\(formattedDuration(restTime))")
                .font(.system(size: 48, weight: .bold))
                .padding()

            HStack {
                Button("Next Exercise") {
                    onNextExercise()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()

                Button("Next Set") {
                    onNextSet()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
        }
    }

    private func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
}
