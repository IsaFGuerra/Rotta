//
//  CarService.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import Foundation
import CloudKit

class EventService {
    private let privateDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        privateDatabase = container.publicCloudDatabase
    }

    func getAll() async -> [EventModel] {
        var events: [EventModel] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Event", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let event = EventModel(
                        id: record.rottaUUID,
                        roundNumber: record["roundNumber"] as? Int16 ?? 0,
                        country: record["country"] as? String ?? "",
                        name: record["name"] as? String ?? "",
                        date: record["date"] as? Date,
                        startTime: record["startTime"] as? String ?? "",
                        endTime: record["endTime"] as? String ?? "",
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "")
                    )
                    events.append(event)
                } catch {
                    print("Erro ao processar record Event: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Events: \(error.localizedDescription)")
        }
        return events
    }

    func get(by id: UUID) async -> EventModel? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await privateDatabase.record(for: recordID)
            return EventModel(
                id: record.rottaUUID,
                roundNumber: record["roundNumber"] as? Int16 ?? 0,
                country: record["country"] as? String ?? "",
                name: record["name"] as? String ?? "",
                date: record["date"] as? Date,
                startTime: record["startTime"] as? String ?? "",
                endTime: record["endTime"] as? String ?? "",
                idFormula: UUID(uuidString: record["idFormula"] as? String ?? "")
            )
        } catch {
            print("Erro ao buscar Event por ID: \(error.localizedDescription)")
            return nil
        }
    }

    func getByFormula(idFormula: UUID) async -> [EventModel] {
        var events: [EventModel] = []
        let predicate = NSPredicate(format: "idFormula == %@", idFormula.uuidString)
        let query = CKQuery(recordType: "Event", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let event = EventModel(
                        id: record.rottaUUID,
                        roundNumber: record["roundNumber"] as? Int16 ?? 0,
                        country: record["country"] as? String ?? "",
                        name: record["name"] as? String ?? "",
                        date: record["date"] as? Date,
                        startTime: record["startTime"] as? String ?? "",
                        endTime: record["endTime"] as? String ?? "",
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "")
                    )
                    events.append(event)
                } catch {
                    print("Erro ao processar record Event: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Events por Fórmula: \(error.localizedDescription)")
        }
        if events.isEmpty {
            return await getAll().filter { $0.idFormula == idFormula }
        }
        return events
    }

    func getEventsInRange(startDate: Date, endDate: Date) async -> [EventModel] {
        let allEvents = await getAll()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let startOfPeriod = calendar.startOfDay(for: startDate)
        let endOfPeriod = calendar.startOfDay(for: endDate)
        
        let filtered = allEvents.filter { event in
            guard let eventDate = event.date else { return false }
            let eventDayStart = calendar.startOfDay(for: eventDate)
            return eventDayStart >= startOfPeriod && eventDayStart < endOfPeriod
        }
        
        return filtered
    }

    func getOnDate(_ date: Date) async -> [EventModel] {
        let allEvents = await getAll()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let filtered = allEvents.filter {
            guard let eventDate = $0.date else { return false }
            return eventDate >= startOfDay && eventDate < endOfDay
        }

        return filtered
    }

    func add(roundNumber: Int16, country: String, name: String, date: Date? = nil, startTime: String, endTime: String, idFormula: UUID? = nil) async -> UUID? {
        let record = CKRecord.rottaRecord(type: "Event")
        record["roundNumber"] = roundNumber
        record["country"] = country
        record["name"] = name
        if let date = date { record["date"] = date }
        record["startTime"] = startTime
        record["endTime"] = endTime
        if let idFormula = idFormula { record["idFormula"] = idFormula.uuidString }
        do {
            let saved = try await privateDatabase.save(record)
            print("Event salvo com sucesso: \(saved.recordID.recordName)")
            return saved.rottaUUID
        } catch {
            print("Erro ao salvar Event: \(error.localizedDescription)")
            return nil
        }
    }

    func find(roundNumber: Int16, name: String, idFormula: UUID) async -> EventModel? {
        await getByFormula(idFormula: idFormula).first {
            $0.roundNumber == roundNumber && $0.name == name
        }
    }

    func update(
        id: UUID,
        country: String? = nil,
        date: Date? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        roundNumber: Int16? = nil,
        name: String? = nil
    ) async {
        do {
            let record = try await privateDatabase.record(for: CKRecord.ID(recordName: id.uuidString))
            if let country { record["country"] = country }
            if let date { record["date"] = date }
            if let startTime { record["startTime"] = startTime }
            if let endTime { record["endTime"] = endTime }
            if let roundNumber { record["roundNumber"] = roundNumber }
            if let name { record["name"] = name }
            _ = try await privateDatabase.save(record)
            print("Event atualizado: \(id)")
        } catch {
            print("Erro ao atualizar Event: \(error.localizedDescription)")
        }
    }
}
