//
//  TopThreeScreen.swift
//  Rotta
//

import SwiftUI

/// Tela do segmento "Ranking": pódios de pilotos e scuderias.
struct TopThreeScreen: View {
    let formulaName: String
    @State private var viewModel = RankingViewModel()

    var body: some View {
        VStack(spacing: 16) {
            NavigationLink {
                DriverRankingScreen(drivers: viewModel.drivers)
            } label: {
                PodiumCard(title: "Pilotos") {
                    podiumRow(for: viewModel.drivers) { driver, rank in
                        DriverPodiumEntry(driver: driver, rank: rank)
                    }
                }
            }
            .buttonStyle(.plain)

            NavigationLink {
                ScuderiaRankingScreen(scuderias: viewModel.scuderias)
            } label: {
                PodiumCard(title: "Scuderias") {
                    podiumRow(for: viewModel.scuderias) { scuderia, rank in
                        ScuderiaPodiumEntry(scuderia: scuderia, rank: rank)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .task(id: formulaName) {
            await viewModel.loadDrivers(formulaName: formulaName)
            await viewModel.loadScuderias(formulaName: formulaName)
        }
    }

    /// Ordem visual do pódio: 2º, 1º, 3º.
    /// Sem dados o card encolhe para só o cabeçalho, em vez de esticar.
    @ViewBuilder
    private func podiumRow<Item, Entry: View>(
        for items: [Item],
        @ViewBuilder entry: @escaping (Item, Int) -> Entry
    ) -> some View {
        if !items.isEmpty {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach([2, 1, 3], id: \.self) { rank in
                    Group {
                        if items.indices.contains(rank - 1) {
                            entry(items[rank - 1], rank)
                        } else {
                            Color.clear.frame(height: 1)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

/// Moldura do pódio: título, chevron e o conteúdo sobre o gradiente.
private struct PodiumCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(Fonts.title2)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "chevron.right.circle.fill")
                    .foregroundStyle(Color.rottaYellow)
            }
            .padding(.leading, 32)
            .padding(.trailing, 12)

            content
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Gradients.rankingView)
        .clipShape(.rect(cornerRadius: 32))
    }
}

private struct DriverPodiumEntry: View {
    let driver: DriverModel
    let rank: Int

    var body: some View {
        PodiumEntryLayout(
            rank: rank,
            name: driver.shortName,
            points: "\(driver.points) pontos"
        ) {
            Group {
                if let photo = driver.photo, let image = UIImage(named: photo) {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    Image(systemName: "person.fill").resizable().scaledToFit()
                }
            }
            .frame(width: rank == 1 ? 80 : 60, height: rank == 1 ? 80 : 60)
            .clipShape(.circle)
        }
    }
}

private struct ScuderiaPodiumEntry: View {
    let scuderia: ScuderiaModel
    let rank: Int

    var body: some View {
        PodiumEntryLayout(
            rank: rank,
            name: scuderia.name,
            points: "\(Int(scuderia.points)) pontos"
        ) {
            Image(scuderia.logo)
                .resizable()
                .scaledToFit()
                .frame(width: rank == 1 ? 100 : 60, height: rank == 1 ? 100 : 60)
        }
    }
}

/// Imagem, posição, nome e pontos empilhados.
private struct PodiumEntryLayout<Icon: View>: View {
    let rank: Int
    let name: String
    let points: String
    @ViewBuilder var icon: Icon

    var body: some View {
        VStack(spacing: 8) {
            icon

            Text("\(rank)")
                .font(Fonts.title2)

            Text(name)
                .font(Fonts.footnoteEmphasized)
                .lineLimit(1)

            Text(points)
                .font(Fonts.footnoteRegular)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
    }
}
