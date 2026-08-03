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

    func load() async {
        scuderias = await database.getAllScuderias()
    }
}

@MainActor
@Observable
final class DriverListViewModel {
    private(set) var drivers: [DriverModel] = []
    private let database = Database.shared

    func load() async {
        drivers = await database.getAllDrivers()
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
