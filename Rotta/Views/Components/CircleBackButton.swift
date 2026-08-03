//
//  CircleBackButton.swift
//  Rotta
//

import SwiftUI

/// Botão de voltar amarelo usado nas telas empilhadas.
/// Substitui o `UIBarButtonItem(customView:)` que cada VC montava à mão.
struct CircleBackButton: ViewModifier {
    let systemImage: String
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: systemImage)
                            .font(.system(size: 20))
                            .foregroundStyle(Color.rottaYellow)
                    }
                }
            }
    }
}

extension View {
    /// Volta com chevron (telas de lista/detalhe).
    func circleBackButton() -> some View {
        modifier(CircleBackButton(systemImage: "chevron.left.circle.fill"))
    }

    /// Volta com "x" (telas de ranking, como no original).
    func closeBackButton() -> some View {
        modifier(CircleBackButton(systemImage: "xmark.circle.fill"))
    }
}
