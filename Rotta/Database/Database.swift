//
//  Database.swift
//  Rotta
//
//  Created by Marcos on 12/06/25.
//

import Foundation
import CloudKit

enum CloudKitConfig {
    static let containerIdentifier = "iCloud.com.isadoraguerra.Rotta"
}

class Database {
    static var shared = Database()
    
    private let container = CKContainer(identifier: CloudKitConfig.containerIdentifier)
    private var privateDatabase: CKDatabase {
        return container.publicCloudDatabase
    }
    
    private let formulaService = FormulaService()
    private let driverService = DriverService()
    private let scuderiaService = ScuderiaService()
    private let eventService = EventService()
    private let carService = CarService()
    private let componentService = ComponentService()
    private let ruleService = RuleService()
    private let glossaryService = GlossaryService()
    private let trackService = TrackService()
    
    private init() {}
    
    // MARK: - Formula Functions
    func getAllFormulas() async -> [FormulaModel] {
        return await formulaService.getAll()
    }
    
    func getFormula(by id: UUID) async -> FormulaModel? {
        return await formulaService.get(by: id)
    }
    
    func addFormula(name: String, color: String) async -> UUID? {
        await formulaService.add(name: name, color: color)
    }
    
    // MARK: - Driver Functions
    func getAllDrivers() async -> [DriverModel] {
        return await driverService.getAll()
    }
    
    func getDriversByFormula(idFormula: UUID) async -> [DriverModel] {
        return await driverService.getByFormula(idFormula: idFormula)
    }
    
    func getDriversByScuderia(scuderiaId: UUID) async -> [DriverModel] {
        return await driverService.getByScuderia(scuderiaId: scuderiaId)
    }
    
    func addDriver(name: String, country: String, number: Int16, points: Int16, scuderia: String, idScuderia: UUID, idFormula: UUID, photo: String, scuderiaLogo: String, height: String, birthDate: Date, championship: String, details: String) async {
        _ = await driverService.add(name: name, country: country, number: number, points: Int16(points), scuderia: scuderia, idScuderia: idScuderia, idFormula: idFormula, photo: photo, scuderiaLogo: scuderiaLogo, height: height, birthDate: birthDate, championship: championship, details: details)
    }

    func updateDriver(
        id: UUID,
        points: Int16? = nil,
        number: Int16? = nil,
        scuderia: String? = nil,
        idScuderia: UUID? = nil,
        scuderiaLogo: String? = nil
    ) async {
        await driverService.update(
            id: id,
            points: points,
            number: number,
            scuderia: scuderia,
            idScuderia: idScuderia,
            scuderiaLogo: scuderiaLogo
        )
    }

    func findDriver(name: String, idFormula: UUID) async -> DriverModel? {
        await driverService.find(name: name, idFormula: idFormula)
    }
    
    // MARK: - Scuderia Functions
    func getAllScuderias() async -> [ScuderiaModel] {
        return await scuderiaService.getAll()
    }
    
    func getScuderia(by id: UUID) async -> ScuderiaModel? {
        return await scuderiaService.get(by: id)
    }
    
    func getScuderiasByFormula(idFormula: UUID) async -> [ScuderiaModel] {
        return await scuderiaService.getByFormula(idFormula: idFormula)
    }
    
    func addScuderia(name: String, logo: String, points: Double, historicPoints: Int16, idFormula: UUID, country: String, pole: Int16, victory: Int16, podium: Int16, details: String) async -> UUID? {
        await scuderiaService.add(name: name, logo: logo, points: points, historicPoints: historicPoints, idFormula: idFormula, country: country, pole: pole, victory: victory, podium: podium, details: details)
    }

    func updateScuderia(id: UUID, points: Double? = nil, historicPoints: Int16? = nil, pole: Int16? = nil, victory: Int16? = nil, podium: Int16? = nil) async {
        await scuderiaService.update(id: id, points: points, historicPoints: historicPoints, pole: pole, victory: victory, podium: podium)
    }

    func findScuderia(name: String, idFormula: UUID) async -> ScuderiaModel? {
        await scuderiaService.find(name: name, idFormula: idFormula)
    }
    
    // MARK: - Event Functions
    func getAllEvents() async -> [EventModel] {
        return await eventService.getAll()
    }
    
    func getEvent(by id: UUID) async -> EventModel? {
        return await eventService.get(by: id)
    }
    
    func getAllEventsByFormula(by idFormula: UUID) async -> [EventModel] {
        return await eventService.getByFormula(idFormula: idFormula)
    }
    
    func getEventsOnDate(_ date: Date) async -> [EventModel] {
        return await eventService.getOnDate(date)
    }
    
    func addEvent(roundNumber: Int16, country: String, name: String, date: Date? = nil, startTime: String, endTime: String, idFormula: UUID? = nil) async {
        _ = await eventService.add(roundNumber: roundNumber, country: country, name: name, date: date, startTime: startTime, endTime: endTime, idFormula: idFormula)
    }

    func updateEvent(id: UUID, country: String? = nil, date: Date? = nil, startTime: String? = nil, endTime: String? = nil) async {
        await eventService.update(id: id, country: country, date: date, startTime: startTime, endTime: endTime)
    }

    func findEvent(roundNumber: Int16, name: String, idFormula: UUID) async -> EventModel? {
        await eventService.find(roundNumber: roundNumber, name: name, idFormula: idFormula)
    }
    
    // MARK: - Car Functions
    func getAllCars() async -> [CarModel] {
        return await carService.getAll()
    }
    
    func getCar(by id: UUID) async -> CarModel? {
        return await carService.get(by: id)
    }
    
    func getAllCarsByFormula(by idFormula: UUID) async -> [CarModel] {
        return await carService.getByFormula(idFormula: idFormula)
    }
    
    func getCarsByComponent(componentId: UUID) async -> [CarModel] {
        return await carService.getByComponent(componentId: componentId)
    }
    
    func addCar(idComponents: [UUID], idFormula: UUID, image: String? = nil) async {
        await carService.add(idComponents: idComponents, idFormula: idFormula, image: image)
    }
    
    // MARK: - Track Functions
    func getAllTracks() async -> [TrackModel] {
        return await trackService.getAll()
    }
    
    func getTrack(by id: UUID) async -> TrackModel? {
        return await trackService.get(by: id)
    }
    
    func getAllTracksByFormula(by idFormula: UUID) async -> [TrackModel] {
        return await trackService.getByFormula(idFormula: idFormula)
    }
    
    func addTrack(name: String, location: String, distance: Double = 0.0, idFormula: [UUID]) async {
        return await trackService.add(name: name, location: location, distance: distance, idFormula: idFormula)
    }
    
    // MARK: - Component Functions
    func getAllComponents() async -> [ComponentModel] {
        return await componentService.getAll()
    }
    
    func getComponent(by id: UUID) async -> ComponentModel? {
        return await componentService.get(by: id)
    }
    
    func addComponent(name: String? = nil, details: String? = nil, property: String? = nil, image: String? = nil) async {
        await componentService.add(name: name, details: details, property: property, image: image)
    }
    
    // MARK: - Rule Functions
    func getAllRules() async -> [RuleModel] {
        return await ruleService.getAll()
    }
    
    func getRule(by id: UUID) async -> RuleModel? {
        return await ruleService.get(by: id)
    }
    
    func getAllRulesByFormula(by idFormula: UUID) async -> [RuleModel] {
        return await ruleService.getByFormula(idFormula: idFormula)
    }
    
    func addRule(name: String? = nil, details: String? = nil, idFormula: UUID? = nil) async {
        await ruleService.add(name: name, details: details, idFormula: idFormula)
    }
    
    // MARK: - Glossary Functions
    func getAllGlossaryTerms() async -> [GlossaryModel] {
        return await glossaryService.getAll()
    }
    
    func getGlossaryTerm(by id: UUID) async -> GlossaryModel? {
        return await glossaryService.get(by: id)
    }
    
    func addGlossaryTerm(title: String? = nil, details: String? = nil, subtitle: String? = nil, image: String? = nil) async {
        await glossaryService.add(title: title, details: details, subtitle: subtitle, image: image)
    }
    
    func deleteAllRecords(of recordTypes: [String]) async {
        for type in recordTypes {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: type, predicate: predicate)
            do {
                let resultados = try await privateDatabase.records(matching: query)
                let recordIDs = resultados.matchResults.compactMap { try? $0.1.get().recordID }
                if !recordIDs.isEmpty {
                    _ = try await privateDatabase.modifyRecords(saving: [], deleting: recordIDs)
                    print("Deleted \(recordIDs.count) records of type \(type)")
                }
            } catch {
                print("Error deleting records for type \(type): \(error.localizedDescription)")
            }
        }
    }

    func resetCloudKit() async {
        let types = ["Formula", "Driver", "Scuderia", "Event", "Car", "Component", "Rule", "Glossary", "Track", CloudKitConfig.seedStateRecordType]
        await deleteAllRecords(of: types)
    }
}
