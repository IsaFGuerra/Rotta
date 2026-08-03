//
//  InfosScreen.swift
//  Rotta
//

import SwiftUI

/// Carrossel horizontal de cards que levam às sub-seções.
struct InfosScreen: View {
    private enum Destination: Hashable {
        case glossary, scuderias, drivers, components
    }

    private struct Card: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let imageResource: ImageResource
        let destination: Destination
    }

    private let cards: [Card] = [
        Card(
            title: "Glossário",
            subtitle: "Entenda os principais termos utilizados na Fórmula 2",
            imageResource: .glossaryCategoryInfos,
            destination: .glossary
        ),
        Card(
            title: "Scuderias",
            subtitle: "Conheça as scuderias da Fórmula 2",
            imageResource: .componentsCategoryInfos,
            destination: .scuderias
        ),
        Card(
            title: "Pilotos",
            subtitle: "Conheça os pilotos da Fórmula 2",
            imageResource: .componentsCategoryInfos,
            destination: .drivers
        ),
        Card(
            title: "Peças",
            subtitle: "Conheça as peças que compõem os carros da Fórmula 2",
            imageResource: .componentsCategoryInfos,
            destination: .components
        )
    ]

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cards) { card in
                        NavigationLink {
                            view(for: card.destination)
                        } label: {
                            InfoCard(
                                title: card.title,
                                subtitle: card.subtitle,
                                imageResource: card.imageResource
                            )
                            // Mesma proporção do `sizeForItemAt` original: 93% da largura.
                            .frame(width: proxy.size.width * 0.93, height: proxy.size.height)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.backgroundPrimary)
    }

    @ViewBuilder
    private func view(for destination: Destination) -> some View {
        switch destination {
        case .glossary: GlossaryListScreen()
        case .scuderias: ScuderiaListScreen()
        case .drivers: DriverListScreen()
        case .components: CarComponentListScreen()
        }
    }
}

/// Card com imagem de fundo, gradiente e título/subtítulo na base.
private struct InfoCard: View {
    let title: String
    let subtitle: String
    let imageResource: ImageResource

    var body: some View {
        // Os `overlay` mantêm a imagem e o texto dentro do frame do card;
        // um ZStack faria o `scaledToFill` esticar o card inteiro.
        Color.backgroundPrimary
            .overlay {
                Image(imageResource)
                    .resizable()
                    .scaledToFill()
            }
            .overlay { Gradients.cardInfos }
            .overlay(alignment: .bottom) {
                VStack(spacing: 12) {
                    Text(title)
                        .font(Fonts.title1)

                    Text(subtitle)
                        .font(Fonts.bodyRegular)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .foregroundStyle(Color.labelsPrimary)
                .padding(.horizontal, 65)
                .padding(.bottom, 25)
            }
            .clipShape(.rect(cornerRadius: 37))
    }
}
