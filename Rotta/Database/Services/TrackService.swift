//
//  TrackService.swift
//  Rotta
//
//  Created by Marcos on 15/06/25.
//

import CloudKit
import Foundation

class TrackService {
    private let privateDatabase: CKDatabase

    init(container: CKContainer = .init(identifier: CloudKitConfig.containerIdentifier)) {
        privateDatabase = container.publicCloudDatabase
    }

    let transformer = ArrayToUUIDTransformer()

    func getAll() async -> [TrackModel] {
        var tracks: [TrackModel] = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Track", predicate: predicate)
        do {
            let results = try await privateDatabase.records(matching: query)
            for result in results.matchResults {
                do {
                    let record = try result.1.get()

                    let formulaData = record["idFormula"] as? Data
                    let idsFormula =
                        transformer.reverseTransformedValue(formulaData)
                        as? [UUID] ?? []

                    let track = TrackModel(
                        id: record.rottaUUID,
                        name: record["name"] as? String ?? "",
                        location: record["location"] as? String ?? "",
                        distance: record["distance"] as? Double ?? 0,
                        idFormula: idsFormula
                    )
                    tracks.append(track)
                } catch {
                    print(
                        "Erro ao processar record Track: \(error.localizedDescription)"
                    )
                }
            }
        } catch {
            print("Erro ao buscar tracks: \(error.localizedDescription)")
        }
        return tracks
    }

    func get(by id: UUID) async -> TrackModel? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await privateDatabase.record(for: recordID)

            let formulaData = record["idFormula"] as? Data
            let idsFormula =
                transformer.reverseTransformedValue(formulaData) as? [UUID]
                ?? []

            return TrackModel(
                id: record.rottaUUID,
                name: record["name"] as? String ?? "",
                location: record["location"] as? String ?? "",
                distance: record["distance"] as? Double ?? 0,
                idFormula: idsFormula
            )
        } catch {
            print(
                "Erro ao buscar track por ID: \(error.localizedDescription)"
            )
            return nil
        }
    }

    func getByFormula(idFormula: UUID) async -> [TrackModel] {
        let tracks = await getAll()
        return tracks.filter { $0.idFormula?.contains(idFormula) == true }
    }

    func add(name: String, location: String, distance: Double, idFormula: [UUID])
        async
    {
        let record = CKRecord.rottaRecord(type: "Track")
        record["name"] = name
        record["location"] = location
        record["distance"] = distance
        record["idFormula"] = transformer.reverseTransformedValue(idFormula) as? Data

        do {
            let saved = try await privateDatabase.save(record)
            print("track salva com sucesso: \(saved.recordID.recordName)")
        } catch {
            print("Erro ao salvar track: \(error.localizedDescription)")
        }
    }
}
