//
//  Fonts.swift
//  Rotta
//

import SwiftUI

/// Tipografia do app. Os nomes espelham as fontes registradas em `UIAppFonts`.
enum Fonts {
    static let bodyRegular = Font.custom("SFPro-Regular", size: 17)
    static let bodyEmphasized = Font.custom("SFPro-Semibold", size: 17)
    static let footnoteRegular = Font.custom("SFPro-Regular", size: 13)
    static let footnoteEmphasized = Font.custom("SFPro-Semibold", size: 13)
    static let weekdayCalendar = Font.custom("SFPro-Medium", size: 12)

    static let title1 = Font.custom("Formula1-Display-Bold", size: 34)
    static let title2 = Font.custom("Formula1-Display-Bold", size: 22)
    static let title3 = Font.custom("Formula1-Display-Bold", size: 20)

    static let subtitle1 = Font.custom("Formula1-Display-Regular", size: 17)
    static let subtitle2 = Font.custom("Formula1-Display-Regular", size: 14)

    static let headline = Font.custom("SFPro-Semibold", size: 17)
}
