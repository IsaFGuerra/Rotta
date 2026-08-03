//
//  DetailScaffold.swift
//  Rotta
//

import SwiftUI

/// Estrutura das telas de detalhe: imagem de topo (362pt), gradiente sobre a
/// tela inteira e o conteúdo rolando a partir de 212pt.
struct DetailScaffold<Background: View, Content: View>: View {
    @ViewBuilder var background: Background
    @ViewBuilder var content: Content

    var body: some View {
        ZStack(alignment: .top) {
            background
                .frame(height: 362)
                .frame(maxWidth: .infinity)
                .clipped()
                .frame(maxHeight: .infinity, alignment: .top)

            Gradients.glossary
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    content
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
            .padding(.top, 212)
        }
        .ignoresSafeArea(edges: .top)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .circleBackButton()
    }
}

/// Caixa arredondada usada nos blocos de texto das telas de detalhe.
struct DetailTextBox<Content: View>: View {
    var background: Color = .fillsTextbox
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(background, in: .rect(cornerRadius: 32))
    }
}
