//
//  Models+Identifiable.swift
//  Rotta
//
//  Conformances necessárias para usar os models em `List`/`ForEach`.
//

import Foundation

extension DriverModel: Identifiable {}
extension ScuderiaModel: Identifiable {}
extension EventModel: Identifiable {}
extension GlossaryModel: Identifiable {}
extension ComponentModel: Identifiable {}
extension CarModel: Identifiable {}
extension FormulaModel: Identifiable {}
extension RuleModel: Identifiable {}
extension TrackModel: Identifiable {}

extension DriverModel: Hashable {
    static func == (lhs: DriverModel, rhs: DriverModel) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension ScuderiaModel: Hashable {
    static func == (lhs: ScuderiaModel, rhs: ScuderiaModel) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension GlossaryModel: Hashable {
    static func == (lhs: GlossaryModel, rhs: GlossaryModel) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension ComponentModel: Hashable {
    static func == (lhs: ComponentModel, rhs: ComponentModel) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension DriverModel {
    /// "Leonardo Fornaroli" -> "L. Fornaroli"
    var shortName: String {
        let parts = name.components(separatedBy: " ").filter { !$0.isEmpty }
        guard parts.count >= 2, let first = parts.first, let last = parts.last else {
            return name
        }
        return "\(first.prefix(1)). \(last)"
    }
}
