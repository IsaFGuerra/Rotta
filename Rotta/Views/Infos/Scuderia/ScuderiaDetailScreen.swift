//
//  ScuderiaDetailScreen.swift
//  Rotta
//

import SwiftUI

struct ScuderiaDetailScreen: View {
    let scuderia: ScuderiaModel

    var body: some View {
        DetailScaffold {
            Image("f3")
                .resizable()
                .scaledToFill()
        } content: {
            Image(scuderia.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 30)

            Text(scuderia.name)
                .font(Fonts.title1)
                .foregroundStyle(Color.labelsPrimary)
                .multilineTextAlignment(.center)

            StatRow(stats: [
                Stat(title: "País", value: scuderia.country.getCountryFlag()),
                Stat(title: "Vitórias", value: "\(scuderia.victory)")
            ])

            StatRow(stats: [
                Stat(title: "Poles", value: "\(scuderia.pole)"),
                Stat(title: "Pódios", value: "\(scuderia.podium)"),
                Stat(title: "Pontos", value: "\(scuderia.historicPoints)")
            ])

            DetailTextBox {
                VStack(spacing: 8) {
                    Text("Resumo Geral")
                        .font(Fonts.subtitle1)
                        .frame(maxWidth: .infinity)

                    Text(scuderia.details)
                        .font(Fonts.subtitle1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundStyle(Color.labelsPrimary)
            }
        }
        .navigationTitle("Detalhes da Scuderia")
    }
}

private struct Stat {
    let title: String
    let value: String
}

/// Linha de estatísticas com divisórias verticais entre os itens.
private struct StatRow: View {
    let stats: [Stat]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                if index > 0 {
                    Rectangle()
                        .fill(Color.rottaGray)
                        .frame(width: 1)
                }

                VStack(spacing: 8) {
                    Text(stat.title)
                        .font(Fonts.subtitle1)

                    Text(stat.value)
                        .font(Fonts.title1)
                }
                .foregroundStyle(Color.labelsPrimary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(16)
        .background(Color.fillsTextbox, in: .rect(cornerRadius: 32))
    }
}
