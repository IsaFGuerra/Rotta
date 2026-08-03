//
//  InfoListScaffold.swift
//  Rotta
//

import SwiftUI

/// Estrutura compartilhada das listas de Infos: gradiente de fundo, header de
/// imagens no topo e a lista logo abaixo.
struct InfoListScaffold<Header: View, Content: View>: View {
    @ViewBuilder var header: Header
    @ViewBuilder var content: Content

    var body: some View {
        ZStack(alignment: .top) {
            Gradients.glossary
                .ignoresSafeArea()

            VStack(spacing: 20) {
                header

                ScrollView {
                    LazyVStack(spacing: 16) {
                        content
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top, 54)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .circleBackButton()
    }
}
