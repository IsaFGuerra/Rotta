//
//  ChevronRow.swift
//  Rotta
//

import SwiftUI

/// Linha de lista com ícone opcional, título e chevron.
/// Cobre `GlossaryCell`, `ScuderiaCell`, `DriverCell` e `CarComponentCell`.
struct ChevronRow<Leading: View>: View {
    let title: String
    var horizontalPadding: CGFloat = 16
    @ViewBuilder var leading: Leading

    var body: some View {
        HStack(spacing: 16) {
            leading

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.fillsSelector)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .background(Color.fillsRows, in: .rect(cornerRadius: 12))
        .contentShape(.rect)
    }
}

extension ChevronRow where Leading == EmptyView {
    init(title: String, horizontalPadding: CGFloat = 16) {
        self.init(title: title, horizontalPadding: horizontalPadding) { EmptyView() }
    }
}
