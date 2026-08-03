//
//  DriverDetailScreen.swift
//  Rotta
//

import SwiftUI

struct DriverDetailScreen: View {
    let driver: DriverModel

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private var birthDate: String {
        guard let date = driver.birthDate else { return "--/--/----" }
        return Self.dateFormatter.string(from: date)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                photo
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.5)
                    .clipped()
                    .frame(maxHeight: .infinity, alignment: .top)

                Color.raceFormula250

                ScrollView {
                    VStack(spacing: 20) {
                        Text(driver.name)
                            .font(Fonts.title1)
                            .foregroundStyle(Color.labelsPrimary)
                            .padding(.top, 265)

                        MainInfosCard(
                            country: driver.country ?? "Unknown",
                            driverNumber: driver.number ?? 0,
                            scuderiaLogo: driver.scuderiaLogo ?? "Unknown"
                        )
                        .frame(height: 95)

                        HeightAndBirthPill(
                            height: driver.height ?? "Unknown",
                            birthDate: birthDate
                        )
                        .frame(height: 46)

                        ChampionPill(champion: driver.championship ?? "Unknown")

                        Text(driver.details ?? "Unknown")
                            .font(Fonts.bodyRegular)
                            .foregroundStyle(Color.labelsPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.fillsTextbox, in: .rect(cornerRadius: 32))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .background(Gradients.driverDetails)
                }
                .scrollIndicators(.hidden)
            }
        }
        .background(Color.raceFormula2)
        .ignoresSafeArea(edges: .top)
        .navigationTitle("Pilotos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .circleBackButton()
    }

    @ViewBuilder
    private var photo: some View {
        if let photoName = driver.photo, let image = UIImage(named: photoName) {
            Image(uiImage: image).resizable().scaledToFill()
        } else {
            Image(systemName: "person.fill").resizable().scaledToFit()
        }
    }
}

// MARK: - Componentes do piloto

/// País | Carro | Equipe, com divisórias.
private struct MainInfosCard: View {
    let country: String
    let driverNumber: Int16
    let scuderiaLogo: String

    var body: some View {
        HStack(spacing: 0) {
            column(title: "País") {
                Text(country.getCountryFlag())
                    .font(Fonts.subtitle1)
            }

            divider

            column(title: "Carro") {
                Text("\(driverNumber)")
                    .font(Fonts.title1)
            }
            .background(Color.fillsTextboxSecondary)

            divider

            column(title: "Equipe") {
                Image(scuderiaLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 67, height: 37.79)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color.fillsTextbox)
        .clipShape(.rect(cornerRadius: 32))
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.fillsTextbox)
            .frame(width: 1)
    }

    private func column<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(Fonts.subtitle1)
            Spacer(minLength: 4)
            content()
        }
        .foregroundStyle(Color.labelsPrimary)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Pílula com altura e data de nascimento.
private struct HeightAndBirthPill: View {
    let height: String
    let birthDate: String

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 4) {
                Text("Altura")
                    .font(Fonts.subtitle2)
                Text("\(height)m")
                    .font(Fonts.footnoteRegular)
            }
            .padding(.leading, 27.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color.fillsTextboxSecondary)
            .overlay(alignment: .trailing) {
                Rectangle()
                    .fill(Color.fillsTextbox)
                    .frame(width: 1)
            }

            HStack(spacing: 4) {
                Text("Nascido em")
                    .font(Fonts.subtitle2)
                Text(birthDate)
                    .font(Fonts.footnoteRegular)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(Color.labelsPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.fillsTextbox)
        .clipShape(.capsule)
    }
}

/// Pílula "Campeão: ...".
private struct ChampionPill: View {
    let champion: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("Campeão:")
                .font(Fonts.subtitle2)
            Text(champion)
                .font(Fonts.footnoteRegular)
                .lineLimit(1)
        }
        .foregroundStyle(Color.labelsPrimary)
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.fillsTextbox)
        .clipShape(.capsule)
    }
}
