//
//  DriverService.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import CloudKit
import UIKit

class DriverService {
    private let publicDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        publicDatabase = container.publicCloudDatabase
    }

    func getAll() async -> [DriverModel] {
        await queryDrivers(NSPredicate(value: true))
    }

    func getByFormula(idFormula: UUID) async -> [DriverModel] {
        let queried = await queryDrivers(NSPredicate(format: "idFormula == %@", idFormula.uuidString))
        if queried.isEmpty {
            return await getAll().filter { $0.idFormula == idFormula }
        }
        return queried
    }

    func getByScuderia(scuderiaId: UUID) async -> [DriverModel] {
        let queried = await queryDrivers(NSPredicate(format: "idScuderia == %@", scuderiaId.uuidString))
        if queried.isEmpty {
            return await getAll().filter { $0.idScuderia == scuderiaId }
        }
        return queried
    }

    func find(name: String, idFormula: UUID) async -> DriverModel? {
        let predicate = NSPredicate(
            format: "name == %@ AND idFormula == %@",
            name,
            idFormula.uuidString
        )
        if let match = await queryDrivers(predicate).first {
            return match
        }
        return await getAll().first { $0.name == name && $0.idFormula == idFormula }
    }

    func getDriverWithScuderiaIcon(by id: UUID) async -> DriverModel? {
        do {
            let driverRecord = try await publicDatabase.record(for: CKRecord.ID(recordName: id.uuidString))
            var driver = map(driverRecord)

            let scuderiaID = driver.idScuderia
                ?? UUID(uuidString: driverRecord["idScuderia"] as? String ?? "")
            if let scuderiaID {
                let scuderiaRecord = try await publicDatabase.record(
                    for: CKRecord.ID(recordName: scuderiaID.uuidString)
                )
                driver.scuderiaLogo = scuderiaRecord["logo"] as? String ?? driver.scuderiaLogo
                driver.scuderia = scuderiaRecord["name"] as? String ?? driver.scuderia
                driver.idScuderia = scuderiaID
            }
            return driver
        } catch {
            print("Erro ao buscar Driver com scuderia: \(error.localizedDescription)")
            return nil
        }
    }

    func add(
        name: String,
        country: String,
        number: Int16,
        points: Int16,
        scuderia: String,
        idScuderia: UUID,
        idFormula: UUID,
        photo: String,
        scuderiaLogo: String,
        height: String,
        birthDate: Date,
        championship: String,
        details: String
    ) async -> UUID? {
        let record = CKRecord.rottaRecord(type: "Driver")
        record["name"] = name
        record["country"] = country
        record["number"] = number
        record["points"] = points
        record["scuderia"] = scuderia
        record["idScuderia"] = idScuderia.uuidString
        record["idFormula"] = idFormula.uuidString
        record["photo"] = photo
        record["scuderiaLogo"] = scuderiaLogo
        record["height"] = height
        record["birthDate"] = birthDate
        record["championship"] = championship
        record["details"] = details
        do {
            let saved = try await publicDatabase.save(record)
            print("Driver salvo com sucesso: \(saved.recordID.recordName)")
            return saved.rottaUUID
        } catch {
            print("Erro ao salvar Driver: \(error.localizedDescription)")
            return nil
        }
    }

    func update(
        id: UUID,
        points: Int16? = nil,
        number: Int16? = nil,
        scuderia: String? = nil,
        idScuderia: UUID? = nil,
        scuderiaLogo: String? = nil,
        idFormula: UUID? = nil
    ) async {
        do {
            let record = try await publicDatabase.record(for: CKRecord.ID(recordName: id.uuidString))
            if let points { record["points"] = points }
            if let number { record["number"] = number }
            if let scuderia { record["scuderia"] = scuderia }
            if let idScuderia { record["idScuderia"] = idScuderia.uuidString }
            if let scuderiaLogo { record["scuderiaLogo"] = scuderiaLogo }
            if let idFormula { record["idFormula"] = idFormula.uuidString }
            _ = try await publicDatabase.save(record)
            print("Driver atualizado: \(id)")
        } catch {
            print("Erro ao atualizar Driver: \(error.localizedDescription)")
        }
    }

    private func queryDrivers(_ predicate: NSPredicate) async -> [DriverModel] {
        var drivers: [DriverModel] = []
        let query = CKQuery(recordType: "Driver", predicate: predicate)
        do {
            let results = try await publicDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    drivers.append(map(try result.1.get()))
                } catch {
                    print("Erro ao processar record Driver: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Drivers: \(error.localizedDescription)")
        }
        return drivers
    }

    private func map(_ record: CKRecord) -> DriverModel {
        DriverModel(
            id: record.rottaUUID,
            name: record["name"] as? String ?? "",
            country: record["country"] as? String ?? "",
            number: record.rottaInt16("number"),
            points: record.rottaInt16("points"),
            scuderia: record["scuderia"] as? String ?? "",
            idScuderia: UUID(uuidString: record["idScuderia"] as? String ?? ""),
            idFormula: UUID(uuidString: record["idFormula"] as? String ?? ""),
            photo: record["photo"] as? String ?? "",
            scuderiaLogo: record["scuderiaLogo"] as? String ?? "",
            height: record["height"] as? String ?? "",
            birthDate: record["birthDate"] as? Date ?? Date(),
            championship: record["championship"] as? String ?? "",
            details: record["details"] as? String ?? ""
        )
    }
}
