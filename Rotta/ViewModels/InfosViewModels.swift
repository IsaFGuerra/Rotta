//
//  InfosViewModels.swift
//  Rotta
//

import Foundation
import Observation

@MainActor
@Observable
final class GlossaryListViewModel {
    private(set) var terms: [GlossaryModel] = []
    private let database = Database.shared

    func load() async {
        terms = await database.getAllGlossaryTerms()
    }
}

@MainActor
@Observable
final class ScuderiaListViewModel {
    private(set) var scuderias: [ScuderiaModel] = []
    private let database = Database.shared

    func load(formulaName: String) async {
        guard let formula = await database.getAllFormulas().first(where: { FormulaNames.matches($0.name, uiName: formulaName) }) else {
            scuderias = []
            return
        }
        scuderias = await database.getScuderiasByFormula(idFormula: formula.id)
    }
}

@MainActor
@Observable
final class DriverListViewModel {
    private(set) var drivers: [DriverModel] = []
    private let database = Database.shared

    func load(formulaName: String) async {
        guard let formula = await database.getAllFormulas().first(where: { FormulaNames.matches($0.name, uiName: formulaName) }) else {
            drivers = []
            return
        }
        drivers = await database.getDriversByFormula(idFormula: formula.id)
    }
}

@MainActor
@Observable
final class CarComponentListViewModel {
    private(set) var components: [ComponentModel] = []
    private let database = Database.shared

    func load() async {
        components = await database.getAllComponents()
    }
}
