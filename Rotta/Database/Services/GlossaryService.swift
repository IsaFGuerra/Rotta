//
//  CarService.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import Foundation
import CloudKit

class GlossaryService {
    private let privateDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        privateDatabase = container.publicCloudDatabase
    }

    func getAll() async -> [GlossaryModel] {
        var terms: [GlossaryModel] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Glossary", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()
                    let term = GlossaryModel(
                        id: record.rottaUUID,
                        title: record["title"] as? String ?? "",
                        details: record["details"] as? String ?? "",
                        subtitle: record["subtitle"] as? String ?? "",
                        image: record["image"] as? String ?? ""
                    )
                    terms.append(term)
                } catch {
                    print("Erro ao processar record Glossary: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Erro ao buscar Glossary terms: \(error.localizedDescription)")
        }
        return terms
    }

    func get(by id: UUID) async -> GlossaryModel? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await privateDatabase.record(for: recordID)
            return GlossaryModel(
                id: record.rottaUUID,
                title: record["title"] as? String ?? "",
                details: record["details"] as? String ?? "",
                subtitle: record["subtitle"] as? String ?? "",
                image: record["image"] as? String ?? ""

            )
        } catch {
            print("Erro ao buscar Glossary por ID: \(error.localizedDescription)")
            return nil
        }
    }

    func add(title: String? = nil, details: String? = nil, subtitle: String? = nil, image: String? = nil) async {
        let record = CKRecord.rottaRecord(type: "Glossary")
        if let title { record["title"] = title }
        if let details { record["details"] = details }
        if let subtitle { record["subtitle"] = subtitle }
        if let image { record["image"] = image }
        do {
            let saved = try await privateDatabase.save(record)
            print("Glossary term salvo com sucesso: \(saved.recordID.recordName)")
        } catch {
            print("Erro ao salvar Glossary term: \(error.localizedDescription)")
        }
    }
}
