//
//  CarService.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import Foundation
import CloudKit

class ScuderiaService {
    private let privateDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        privateDatabase = container.publicCloudDatabase
    }

    func getAll() async -> [ScuderiaModel] {
        var scuderias: [ScuderiaModel] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Scuderia", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let scuderia = ScuderiaModel(
                        id: record.rottaUUID,
                        name: record["name"] as? String ?? "",
                        logo: record["logo"] as? String ?? "",
                        points: record["points"] as? Double ?? 0.0,
                        historicPoints: record["historicPoints"] as? Int16 ?? 0,
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                        country: record["country"] as? String ?? "",
                        pole: record["pole"] as? Int16 ?? 0,
                        victory: record["victory"] as? Int16 ?? 0,
                        podium: record["podium"] as? Int16 ?? 0,
                        details: record["details"] as? String ?? ""
                    )
                    scuderias.append(scuderia)
                } catch {
                    print("Erro ao processar record Scuderia: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Scuderias: \(error.localizedDescription)")
        }
        return scuderias
    }

    func get(by id: UUID) async -> ScuderiaModel? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await privateDatabase.record(for: recordID)
            return ScuderiaModel(
                id: record.rottaUUID,
                name: record["name"] as? String ?? "",
                logo: record["logo"] as? String ?? "",
                points: record["points"] as? Double ?? 0.0,
                historicPoints: record["historicPoints"] as? Int16 ?? 0,
                idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                country: record["country"] as? String ?? "",
                pole: record["pole"] as? Int16 ?? 0,
                victory: record["victory"] as? Int16 ?? 0,
                podium: record["podium"] as? Int16 ?? 0,
                details: record["details"] as? String ?? ""
            )
        } catch {
            print("Erro ao buscar Scuderia por ID: \(error.localizedDescription)")
            return nil
        }
    }

    func getByFormula(idFormula: UUID) async -> [ScuderiaModel] {
        var scuderias: [ScuderiaModel] = []
        let predicate = NSPredicate(format: "idFormula == %@", idFormula.uuidString)
        let query = CKQuery(recordType: "Scuderia", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let scuderia = ScuderiaModel(
                        id: record.rottaUUID,
                        name: record["name"] as? String ?? "",
                        logo: record["logo"] as? String ?? "",
                        points: record["points"] as? Double ?? 0.0,
                        historicPoints: record["historicPoints"] as? Int16 ?? 0,
                        idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                        country: record["country"] as? String ?? "",
                        pole: record["pole"] as? Int16 ?? 0,
                        victory: record["victory"] as? Int16 ?? 0,
                        podium: record["podium"] as? Int16 ?? 0,
                        details: record["details"] as? String ?? ""
                    )
                    scuderias.append(scuderia)
                } catch {
                    print("Erro ao processar record Scuderia: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Scuderias por Fórmula: \(error.localizedDescription)")
        }
        if scuderias.isEmpty {
            return await getAll().filter { $0.idFormula == idFormula }
        }
        return scuderias
    }

    func add(name: String, logo: String, points: Double, historicPoints: Int16, idFormula: UUID, country: String, pole: Int16, victory: Int16, podium: Int16, details: String) async -> UUID? {
        let record = CKRecord.rottaRecord(type: "Scuderia")
        record["name"] = name
        record["logo"] = logo
        record["points"] = points
        record["historicPoints"] = historicPoints
        record["idFormula"] = idFormula.uuidString
        record["country"] = country
        record["pole"] = pole
        record["victory"] = victory
        record["podium"] = podium
        record["details"] = details
        do {
            let saved = try await privateDatabase.save(record)
            print("Scuderia salva com sucesso: \(saved.recordID.recordName)")
            return saved.rottaUUID
        } catch {
            print("Erro ao salvar Scuderia: \(error.localizedDescription)")
            return nil
        }
    }

    func find(name: String, idFormula: UUID) async -> ScuderiaModel? {
        let predicate = NSPredicate(
            format: "name == %@ AND idFormula == %@",
            name,
            idFormula.uuidString
        )
        let matches = await getByFormula(idFormula: idFormula).filter { $0.name == name }
        if let match = matches.first { return match }

        var scuderias: [ScuderiaModel] = []
        let query = CKQuery(recordType: "Scuderia", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                if let record = try? result.1.get() {
                    scuderias.append(
                        ScuderiaModel(
                            id: record.rottaUUID,
                            name: record["name"] as? String ?? "",
                            logo: record["logo"] as? String ?? "",
                            points: record["points"] as? Double ?? 0.0,
                            historicPoints: record.rottaInt16("historicPoints"),
                            idFormula: UUID(uuidString: record["idFormula"] as? String ?? "") ?? UUID(),
                            country: record["country"] as? String ?? "",
                            pole: record.rottaInt16("pole"),
                            victory: record.rottaInt16("victory"),
                            podium: record.rottaInt16("podium"),
                            details: record["details"] as? String ?? ""
                        )
                    )
                }
            }
        } catch {
            print("Erro ao buscar Scuderia por nome: \(error.localizedDescription)")
        }
        return scuderias.first
    }

    func update(
        id: UUID,
        points: Double? = nil,
        historicPoints: Int16? = nil,
        pole: Int16? = nil,
        victory: Int16? = nil,
        podium: Int16? = nil,
        logo: String? = nil,
        details: String? = nil
    ) async {
        do {
            let record = try await privateDatabase.record(for: CKRecord.ID(recordName: id.uuidString))
            if let points { record["points"] = points }
            if let historicPoints { record["historicPoints"] = historicPoints }
            if let pole { record["pole"] = pole }
            if let victory { record["victory"] = victory }
            if let podium { record["podium"] = podium }
            if let logo { record["logo"] = logo }
            if let details { record["details"] = details }
            _ = try await privateDatabase.save(record)
            print("Scuderia atualizada: \(id)")
        } catch {
            print("Erro ao atualizar Scuderia: \(error.localizedDescription)")
        }
    }
}
