//
//  CarService.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import Foundation
import CloudKit

class FormulaService {
    private let privateDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        privateDatabase = container.publicCloudDatabase
    }

    func getAll() async -> [FormulaModel] {
        var formulas: [FormulaModel] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Formula", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let formula = FormulaModel(
                        id: record.rottaUUID,
                        name: record["name"] as? String ?? "",
                        color: record["color"] as? String ?? ""
                    )
                    formulas.append(formula)
                } catch {
                    print("Erro ao processar record Formula: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Formulas: \(error.localizedDescription)")
        }
        return formulas
    }

    func get(by id: UUID) async -> FormulaModel? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await privateDatabase.record(for: recordID)
            return FormulaModel(
                id: record.rottaUUID,
                name: record["name"] as? String ?? "",
                color: record["color"] as? String ?? ""
            )
        } catch {
            print("Erro ao buscar Formula por ID: \(error.localizedDescription)")
            return nil
        }
    }

    func add(name: String, color: String) async -> UUID? {
        let record = CKRecord.rottaRecord(type: "Formula")
        record["name"] = name
        record["color"] = color
        do {
            let saved = try await privateDatabase.save(record)
            print("Formula salva com sucesso: \(saved.recordID.recordName)")
            return saved.rottaUUID
        } catch {
            print("Erro ao salvar Formula: \(error.localizedDescription)")
            return nil
        }
    }
}
