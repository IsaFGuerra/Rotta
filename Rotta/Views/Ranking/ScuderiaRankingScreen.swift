//
//  ScuderiaRankingScreen.swift
//  Rotta
//

import SwiftUI

struct ScuderiaRankingScreen: View {
    let scuderias: [ScuderiaModel]

    var body: some View {
        RankingTable(
            headers: ["Scuderia", "Pontos"],
            rows: scuderias
        ) { scuderia, position in
            ScuderiaRankingRow(scuderia: scuderia, position: position)
        }
        .navigationTitle("Scuderias Ranking")
        .navigationBarTitleDisplayMode(.inline)
        .closeBackButton()
    }
}

private struct ScuderiaRankingRow: View {
    let scuderia: ScuderiaModel
    let position: Int

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Text("\(position)")
                    .font(Fonts.title2)
                    .frame(width: 34)

                Image(scuderia.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 20)

                Text(scuderia.name)
                    .font(Fonts.subtitle2)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Text("\(Int(scuderia.points))")
                .font(Fonts.subtitle2)
        }
        .foregroundStyle(.white)
        .padding(.leading, 8)
        .padding(.trailing, 16)
    }
}
