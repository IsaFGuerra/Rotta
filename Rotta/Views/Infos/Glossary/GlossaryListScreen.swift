//
//  GlossaryListScreen.swift
//  Rotta
//

import SwiftUI

struct GlossaryListScreen: View {
    @State private var viewModel = GlossaryListViewModel()

    private let headerImages = [
        "drs_image", "ers_image", "polePosition_image", "dnf_image", "dns_image",
        "dsq_image", "safetyCar_image", "virtualSafetyCar_image", "pitStop_image",
        "undercut_image", "overcut_image", "slipstream_image", "dirtyAir_image",
        "apex_image", "chicane_image", "kerb_image", "marshals_image",
        "parcFerme_image", "formationLap_image", "fastestLap_image"
    ]

    var body: some View {
        InfoListScaffold {
            HeaderLogoGrid(imageNames: headerImages)
        } content: {
            ForEach(viewModel.terms) { term in
                NavigationLink {
                    GlossaryDetailScreen(term: term)
                } label: {
                    ChevronRow(title: term.title ?? "no title")
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Glossário")
        .task { await viewModel.load() }
    }
}
