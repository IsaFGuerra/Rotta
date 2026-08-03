//
//  DriverListScreen.swift
//  Rotta
//

import SwiftUI

struct DriverListScreen: View {
    @State private var viewModel = DriverListViewModel()

    private let headerImages = [
        "alexander_dunne", "amaury_cordeel", "arvid_lindblad", "cian_shields",
        "dino_beganovic", "gabriele_minì", "jak_crawford", "john_bennett",
        "josep_maria_marti", "joshua_dürksen"
    ]

    var body: some View {
        InfoListScaffold {
            HeaderLogoGrid(imageNames: headerImages)
        } content: {
            ForEach(viewModel.drivers) { driver in
                NavigationLink {
                    DriverDetailScreen(driver: driver)
                } label: {
                    ChevronRow(title: driver.shortName) {
                        photo(for: driver)
                            .frame(width: 40, height: 40)
                            .clipShape(.circle)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Pilotos")
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func photo(for driver: DriverModel) -> some View {
        if let photo = driver.photo, let image = UIImage(named: photo) {
            Image(uiImage: image).resizable().scaledToFill()
        } else {
            Image(systemName: "person.fill").resizable().scaledToFit()
        }
    }
}
