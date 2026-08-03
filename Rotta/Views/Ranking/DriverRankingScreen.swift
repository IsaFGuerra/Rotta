//
//  DriverRankingScreen.swift
//  Rotta
//

import SwiftUI

struct DriverRankingScreen: View {
    let drivers: [DriverModel]

    var body: some View {
        RankingTable(
            headers: ["Piloto", "Pontos", "Scuderia"],
            rows: drivers
        ) { driver, position in
            DriverRankingRow(driver: driver, position: position)
        } destination: { driver in
            DriverDetailScreen(driver: driver)
        }
        .navigationTitle("Drivers Ranking")
        .navigationBarTitleDisplayMode(.inline)
        .closeBackButton()
    }
}

private struct DriverRankingRow: View {
    let driver: DriverModel
    let position: Int

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("\(position)")
                    .font(Fonts.title2)
                    .frame(width: 34)

                photo
                    .frame(width: 28, height: 28)
                    .clipShape(.rect(cornerRadius: 14))

                HStack(spacing: 4) {
                    Text(driver.shortName)
                        .font(Fonts.subtitle2)
                        .lineLimit(1)

                    Text(driver.country?.getCountryFlag() ?? "🏁")
                        .font(Fonts.subtitle2)
                }
            }

            Spacer(minLength: 8)

            HStack(spacing: 24) {
                Text("\(driver.points)")
                    .font(Fonts.subtitle2)

                logo
                    .frame(width: 56, height: 12)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private var photo: some View {
        if let photo = driver.photo, let image = UIImage(named: photo) {
            Image(uiImage: image).resizable().scaledToFill()
        } else {
            Image(systemName: "person.fill").resizable().scaledToFit()
        }
    }

    @ViewBuilder
    private var logo: some View {
        if let logoName = driver.scuderiaLogo, let image = UIImage(named: logoName) {
            Image(uiImage: image).resizable().scaledToFit()
        } else {
            Image(systemName: "flag.fill").resizable().scaledToFit()
        }
    }
}
