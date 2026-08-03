//
//  Gradients.swift
//  Rotta
//

import SwiftUI

/// Gradientes do app, equivalentes aos `CAGradientLayer` usados antes.
/// Cada um mantém as mesmas cores, opacidades e `locations` do original.
enum Gradients {
    static let cardInfos = LinearGradient(
        stops: [
            .init(color: .sprintFormula2.opacity(0.2), location: 0.4),
            .init(color: .raceFormula2.opacity(1.0), location: 0.9)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let calendar = LinearGradient(
        stops: [
            .init(color: .calendarGradientStart.opacity(1.0), location: 0.1),
            .init(color: .calendarGradientEnd.opacity(0.7), location: 0.9)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let glossary = LinearGradient(
        stops: [
            .init(color: .sprintFormula2.opacity(0.8), location: 0.4),
            .init(color: .raceFormula2.opacity(0.7), location: 0.9)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let rankingView = LinearGradient(
        stops: [
            .init(color: .raceFormula2.opacity(0.7), location: 0.0),
            .init(color: .sprintFormula2.opacity(0.5), location: 1.0)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let driverDetails = LinearGradient(
        stops: [
            .init(color: .sprintFormula2.opacity(0.0), location: 0.23),
            .init(color: .raceFormula2.opacity(1.0), location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
