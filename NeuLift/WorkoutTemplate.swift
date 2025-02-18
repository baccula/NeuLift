//
//  WorkoutTemplate.swift
//  NeuLift
//
//  Created by Mike Neuwirth on 2/17/25.
//


import SwiftData

@Model
class WorkoutTemplate {
    var name: String
    var exercises: [Exercise] // 🔥 links to saved exercises

    init(name: String, exercises: [Exercise] = []) {
        self.name = name
        self.exercises = exercises
    }
}