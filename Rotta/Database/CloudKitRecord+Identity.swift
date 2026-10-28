//
//  CloudKitRecord+Identity.swift
//  Rotta
//

import CloudKit
import Foundation

enum FormulaNames {
    static let formula2 = "Fórmula 2"
    static let formula3 = "Fórmula 3"
    static let f1Academy = "F1 Academy"

    static let all = [formula2, formula3, f1Academy]

    static func matches(_ stored: String, uiName: String) -> Bool {
        if stored == uiName { return true }
        switch uiName {
        case formula2:
            return stored == "Formula 2" || stored == "Formula2"
        case formula3:
            return stored == "Formula 3" || stored == "Formula3"
        case f1Academy:
            return stored == "Formula 1 Academy" || stored == "F1Academy"
        default:
            return false
        }
    }
}

extension CloudKitConfig {
    static let seedStateRecordType = "SeedState"
    static let seedStateRecordName = "rotta-seed-state"
}

extension CKRecord {
    /// UUID canônico: o `recordName` (quando o add gravou certo) ou o campo `id`.
    var rottaUUID: UUID {
        UUID(uuidString: recordID.recordName)
            ?? UUID(uuidString: self["id"] as? String ?? "")
            ?? UUID()
    }

    static func rottaRecord(type: String, uuid: UUID = UUID()) -> CKRecord {
        let id = uuid.uuidString
        let record = CKRecord(recordType: type, recordID: CKRecord.ID(recordName: id))
        record["id"] = id
        return record
    }

    func rottaInt16(_ key: String) -> Int16 {
        if let value = self[key] as? Int16 { return value }
        if let value = self[key] as? Int64 { return Int16(clamping: value) }
        if let value = self[key] as? Int { return Int16(clamping: value) }
        return 0
    }
}
