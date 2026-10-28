//
//  CarService.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import Foundation
import CloudKit

class CarService {
    private let privateDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        privateDatabase = container.publicCloudDatabase
    }

    func getAll() async -> [CarModel] {
        var cars: [CarModel] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Car", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let idsComponents = record["idComponents"] as? [UUID] ?? []
                    let car = CarModel(
                        id: record.rottaUUID,
                        idComponents: idsComponents,
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                        image: record["image"] as? String
                    )
                    cars.append(car)
                } catch {
                    print("Erro ao processar record Car: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Cars: \(error.localizedDescription)")
        }
        return cars
    }

    func get(by id: UUID) async -> CarModel? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await privateDatabase.record(for: recordID)
            let idsComponents = record["idComponents"] as? [UUID] ?? []
            return CarModel(
                id: record.rottaUUID,
                idComponents: idsComponents,
                idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                image: record["image"] as? String
            )
        } catch {
            print("Erro ao buscar Car por ID: \(error.localizedDescription)")
            return nil
        }
    }

    func getByFormula(idFormula: UUID) async -> [CarModel] {
        var cars: [CarModel] = []
        let predicate = NSPredicate(format: "idFormula == %@", idFormula.uuidString)
        let query = CKQuery(recordType: "Car", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let idsComponents = record["idComponents"] as? [UUID] ?? []
                    let car = CarModel(
                        id: record.rottaUUID,
                        idComponents: idsComponents,
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                        image: record["image"] as? String
                    )
                    cars.append(car)
                } catch {
                    print("Erro ao processar record Car: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Cars por Fórmula: \(error.localizedDescription)")
        }
        return cars
    }

    func getByComponent(componentId: UUID) async -> [CarModel] {
        var cars: [CarModel] = []
        let predicate = NSPredicate(format: "idComponents CONTAINS %@", componentId.uuidString)
        let query = CKQuery(recordType: "Car", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    
                    let car = CarModel(
                        id: record.rottaUUID,
                        idComponents: record["idComponents"] as? [UUID] ?? [],
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                        image: record["image"] as? String
                    )
                    cars.append(car)
                } catch {
                    print("Erro ao processar record Car: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Cars por Componente: \(error.localizedDescription)")
        }
        return cars
    }

    func add(idComponents: [UUID], idFormula: UUID, image: String? = nil) async {
        let record = CKRecord.rottaRecord(type: "Car")
        record["idFormula"] = idFormula.uuidString
        record["idComponents"] = idComponents.map { $0.uuidString }
        if let image = image { record["image"] = image }
        do {
            let saved = try await privateDatabase.save(record)
            print("Car salva com sucesso: \(saved.recordID.recordName)")
        } catch {
            print("Erro ao salvar Car: \(error.localizedDescription)")
        }
    }
}
