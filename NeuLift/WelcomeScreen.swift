//
//  WelcomeScreen.swift
//  NeuLift
//
//  Created by Mike Neuwirth on 2/17/25.
//


import SwiftUI

struct WelcomeScreen: View {
    var onNext: () -> Void

    var body: some View {
        VStack {
            Text("Welcome to NeuLift!")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("Track your workouts and stay on top of your fitness goals!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button("Get Started") {
                onNext()
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
