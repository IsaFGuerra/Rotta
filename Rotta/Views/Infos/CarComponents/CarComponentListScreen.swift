//
//  CarComponentListScreen.swift
//  Rotta
//

import SwiftUI

struct CarComponentListScreen: View {
    @State private var viewModel = CarComponentListViewModel()

    var body: some View {
        InfoListScaffold {
            // O header original era um placeholder de círculos, sem imagens reais.
            PlaceholderCircleHeader()
        } content: {
            ForEach(viewModel.components) { component in
                NavigationLink {
                    CarComponentDetailScreen(component: component)
                } label: {
                    ChevronRow(title: component.name ?? "") {
                        image(for: component)
                            .frame(width: 50, height: 50)
                            .clipShape(.rect(cornerRadius: 25))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Componentes")
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func image(for component: ComponentModel) -> some View {
        if let name = component.image, let image = UIImage(named: name) {
            Image(uiImage: image).resizable().scaledToFit()
        } else {
            Image(systemName: "person.fill").resizable().scaledToFit()
        }
    }
}

private struct PlaceholderCircleHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<2, id: \.self) { _ in
                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle()
                            .fill(Color(.systemTeal))
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
