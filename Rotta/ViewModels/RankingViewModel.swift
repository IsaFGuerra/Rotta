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

    func loadDrivers(formulaName: String) async {
        guard let formulaID = await formulaID(named: formulaName) else {
            drivers = []
            return
        }
        drivers = await database.getDriversByFormula(idFormula: formulaID)
            .sorted { $0.points > $1.points }
    }

    func loadScuderias(formulaName: String) async {
        guard let formulaID = await formulaID(named: formulaName) else {
            scuderias = []
            return
        }
        scuderias = await database.getScuderiasByFormula(idFormula: formulaID)
            .sorted { $0.points > $1.points }
    }

    private func formulaID(named name: String) async -> UUID? {
        await database.getAllFormulas().first(where: { FormulaNames.matches($0.name, uiName: name) })?.id
    }
}
