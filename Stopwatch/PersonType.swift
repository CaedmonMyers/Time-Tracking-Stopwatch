//
// Stopwatch
// PersonType.swift
//
// Created by Reyna Myers on 26/7/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI


struct PersonType: Identifiable {
    let id = UUID()
    var name: String
    var times: [TimeInterval]
}
