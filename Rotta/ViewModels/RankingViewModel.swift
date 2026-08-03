//
//  RankingViewModel.swift
//  Rotta
//

import Foundation
import Observation

@MainActor
@Observable
final class RankingViewModel {
    private(set) var drivers: [DriverModel] = []
    private(set) var scuderias: [ScuderiaModel] = []

    private let database = Database.shared

    func loadDrivers() async {
        drivers = await database.getAllDrivers().sorted { $0.points > $1.points }
    }

    func loadScuderias() async {
        scuderias = await database.getAllScuderias().sorted { $0.points > $1.points }
    }
}
