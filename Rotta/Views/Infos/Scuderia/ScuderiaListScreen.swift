//
//  ScuderiaListScreen.swift
//  Rotta
//

import SwiftUI

struct ScuderiaListScreen: View {
    @State private var viewModel = ScuderiaListViewModel()

    private let teamLogos = [
        "aix_logo", "art_logo", "campos_logo", "dams_logo", "hitech_logo",
        "invicta_logo", "mp_logo", "prema_logo", "rodin_logo", "trident_logo"
    ]

    var body: some View {
        InfoListScaffold {
            HeaderLogoGrid(
                imageNames: teamLogos,
                style: .fitted(width: 50, height: 40)
            )
        } content: {
            ForEach(viewModel.scuderias) { scuderia in
                NavigationLink {
                    ScuderiaDetailScreen(scuderia: scuderia)
                } label: {
                    ChevronRow(title: scuderia.name) {
                        Image(scuderia.logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Scuderias")
        .task { await viewModel.load() }
    }
}
