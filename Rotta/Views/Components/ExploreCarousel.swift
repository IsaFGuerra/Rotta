//
//  ExploreCarousel.swift
//  Rotta
//

import SwiftUI

/// Carrossel paginado com dois itens por página, usado no rodapé das telas de
/// detalhe do glossário e dos componentes.
///
/// - Note: o conteúdo continua sendo um placeholder, como no `GlossaryExploreCell`
///   e no `CarComponentExploreCell` originais.
struct ExploreCarousel: View {
    let title: String
    var items: [String] = Array(repeating: "Palavra", count: 10)

    private var pages: [[String]] {
        stride(from: 0, to: items.count, by: 2).map { start in
            Array(items[start..<min(start + 2, items.count)])
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(Fonts.subtitle1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
                .padding(.top, 12)

            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(pages.enumerated()), id: \.offset) { _, page in
                            HStack(spacing: 24) {
                                ForEach(Array(page.enumerated()), id: \.offset) { _, item in
                                    circleItem(title: item)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .padding(.horizontal, 24)

                HStack {
                    Image(systemName: "chevron.left")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.gray)
                .padding(.horizontal, 4)
                .allowsHitTesting(false)
            }
        }
        .frame(height: 156)
        .frame(maxWidth: .infinity)
        .background(Color.fillsTextbox, in: .rect(cornerRadius: 32))
    }

    private func circleItem(title: String) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.blue)
                .frame(width: 60, height: 60)

            Text(title)
                .font(.system(size: 14))
        }
    }
}
