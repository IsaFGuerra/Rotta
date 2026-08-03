//
//  RankingTable.swift
//  Rotta
//

import SwiftUI

/// Tabela de ranking com cabeçalho fixo, linhas zebradas e feedback háptico
/// a cada 20pt de rolagem — como faziam `DriverRankingTableView` e
/// `ScuderiaRankingTableView`.
struct RankingTable<Row: Identifiable, RowContent: View, Destination: View>: View {
    let headers: [String]
    let rows: [Row]
    @ViewBuilder let rowContent: (Row, Int) -> RowContent
    let destination: ((Row) -> Destination)?

    @State private var hapticTick = 0
    @State private var lastOffset: CGFloat = 0

    private let scrollThreshold: CGFloat = 20

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                        rowView(row, index: index)
                            .frame(height: 44)
                            .background(index.isMultiple(of: 2)
                                ? Color.white.opacity(0.08)
                                : Color.white.opacity(0.15))
                    }
                }
            }
            .scrollIndicators(.hidden)
            .clipShape(.rect(cornerRadius: 8))
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { _, newValue in
                if abs(newValue - lastOffset) >= scrollThreshold {
                    lastOffset = newValue
                    hapticTick += 1
                }
            }
            .sensoryFeedback(.impact(intensity: 1), trigger: hapticTick)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Gradients.cardInfos)
    }

    private var header: some View {
        HStack(spacing: 12) {
            ForEach(Array(headers.enumerated()), id: \.offset) { index, title in
                Text(title)
                    .font(Fonts.subtitle2)
                    .foregroundStyle(.white)
                    .frame(maxWidth: index == 0 ? .infinity : nil)
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, 3)
        .frame(height: 38)
        .frame(maxWidth: .infinity)
        .background(Color.f2Corrida)
        .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
        .padding(.leading, 46)
    }

    @ViewBuilder
    private func rowView(_ row: Row, index: Int) -> some View {
        if let destination {
            NavigationLink {
                destination(row)
            } label: {
                rowContent(row, index + 1)
            }
            .buttonStyle(.plain)
        } else {
            rowContent(row, index + 1)
        }
    }
}

extension RankingTable {
    init(
        headers: [String],
        rows: [Row],
        @ViewBuilder rowContent: @escaping (Row, Int) -> RowContent,
        @ViewBuilder destination: @escaping (Row) -> Destination
    ) {
        self.headers = headers
        self.rows = rows
        self.rowContent = rowContent
        self.destination = destination
    }
}

extension RankingTable where Destination == EmptyView {
    init(
        headers: [String],
        rows: [Row],
        @ViewBuilder rowContent: @escaping (Row, Int) -> RowContent
    ) {
        self.headers = headers
        self.rows = rows
        self.rowContent = rowContent
        self.destination = nil
    }
}
