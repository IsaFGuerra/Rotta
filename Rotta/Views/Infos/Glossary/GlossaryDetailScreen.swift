//
//  GlossaryDetailScreen.swift
//  Rotta
//

import SwiftUI

struct GlossaryDetailScreen: View {
    let term: GlossaryModel

    var body: some View {
        DetailScaffold {
            Image(.drs2)
                .resizable()
                .scaledToFill()
        } content: {
            Text(term.title ?? "")
                .font(Fonts.title3)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 150)

            DetailTextBox {
                Text(term.details ?? "")
                    .font(Fonts.bodyRegular)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }

            DetailTextBox {
                VStack(spacing: 8) {
                    Text(term.subtitle ?? "")
                        .font(Fonts.subtitle1)

                    Text(term.details ?? "")
                        .font(Fonts.bodyRegular)
                }
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            }

            ExploreCarousel(title: "Explore nosso glossário")
        }
        .navigationTitle("Detalhes")
    }
}
