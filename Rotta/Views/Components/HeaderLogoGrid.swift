//
//  HeaderLogoGrid.swift
//  Rotta
//

import SwiftUI

/// Duas linhas de cinco imagens, usadas como cabeçalho das listas de
/// glossário, scuderias, pilotos e componentes.
struct HeaderLogoGrid: View {
    enum Style {
        /// Recorte circular (pilotos, glossário).
        case circular(diameter: CGFloat)
        /// Ajuste proporcional sem recorte (logos de scuderia).
        case fitted(width: CGFloat, height: CGFloat)
    }

    let imageNames: [String]
    var style: Style = .circular(diameter: 52)

    /// Primeiras cinco em cima, últimas cinco embaixo — igual aos headers originais.
    private var rows: [[String]] {
        let firstRow = Array(imageNames.prefix(5))
        let secondRow = Array(imageNames.suffix(5))
        return [firstRow, secondRow].filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { name in
                        logo(named: name)
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func logo(named name: String) -> some View {
        switch style {
        case let .circular(diameter):
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: diameter, height: diameter)
                .clipShape(.circle)

        case let .fitted(width, height):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
    }
}
