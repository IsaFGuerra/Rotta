//
//  DriverModel.swift
//  Rotta
//
//  Created by Marcos on 13/06/25.
//

import Foundation
import CloudKit
import UIKit

struct DriverModel {
    var name: String
    var country: String?
    var number: Int16?
    var points: Int16
    var scuderia: String?
    var idScuderia: UUID?
    var idFormula: UUID?
    var photo: String?
    var scuderiaLogo: String?
    var height: String?
    var birthDate: Date?
    var championship: String?
    var details: String?
    let id: UUID

    init(
        name: String,
        country: String,
        number: Int16,
        points: Int16,
        scuderia: String,
        idScuderia: UUID? = nil,
        idFormula: UUID? = nil,
        photo: String,
        scuderiaLogo: String,
        height: String,
        birthDate: Date,
        championship: String,
        details: String
    ) {
        self.name = name
        self.country = country
        self.number = number
        self.points = points
        self.scuderia = scuderia
        self.idScuderia = idScuderia
        self.idFormula = idFormula
        self.photo = photo
        self.scuderiaLogo = scuderiaLogo
        self.height = height
        self.birthDate = birthDate
        self.championship = championship
        self.details = details
        self.id = UUID()
    }

    init(
        id: UUID,
        name: String,
        country: String,
        number: Int16,
        points: Int16,
        scuderia: String,
        idScuderia: UUID? = nil,
        idFormula: UUID? = nil,
        photo: String,
        scuderiaLogo: String,
        height: String,
        birthDate: Date,
        championship: String,
        details: String
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.number = number
        self.points = points
        self.scuderia = scuderia
        self.idScuderia = idScuderia
        self.idFormula = idFormula
        self.photo = photo
        self.scuderiaLogo = scuderiaLogo
        self.height = height
        self.birthDate = birthDate
        self.championship = championship
        self.details = details
    }
}
