//
//  SegmentedControlView.swift
//  Rotta
//

import SwiftUI

/// Segmented control customizado com indicador amarelo deslizante.
struct SegmentedControlView: View {
    let items: [String]
    @Binding var selectedIndex: Int

    @Namespace private var indicator

    var body: some View {
        GeometryReader { proxy in
            let segmentWidth = proxy.size.width / CGFloat(items.count)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.rottaYellow)
                    .frame(width: segmentWidth)
                    .padding(.vertical, 2)
                    .offset(x: segmentWidth * CGFloat(selectedIndex))

                HStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, title in
                        Button {
                            guard index != selectedIndex else { return }
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                selectedIndex = index
                            }
                        } label: {
                            Text(title)
                                .font(index == selectedIndex ? Fonts.footnoteEmphasized : Fonts.footnoteRegular)
                                .foregroundStyle(index == selectedIndex ? Color.black : Color.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(height: 32)
        .background(Color.fillsUnselected, in: .capsule)
    }
}
