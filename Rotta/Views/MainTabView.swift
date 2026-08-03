//
//  MainTabView.swift
//  Rotta
//

import SwiftUI

struct MainTabView: View {
    private let formulas = ["Fórmula 2", "Fórmula 3", "F1 Academy"]

    @State private var selectedFormula = "Fórmula 2"
    @State private var selectedTab = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            formulaPicker
                .padding(.horizontal, 16)
                .padding(.top, 44)

            SegmentedControlView(
                items: ["Calendário", "Ranking", "Infos"],
                selectedIndex: $selectedTab
            )
            .padding(.horizontal, 16)
            .padding(.top, 20)

            Group {
                switch selectedTab {
                case 0: CalendarScreen()
                case 1: TopThreeScreen()
                default: InfosScreen()
                }
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.backgroundPrimary)
        .navigationBarHidden(true)
    }

    private var formulaPicker: some View {
        Menu {
            ForEach(formulas, id: \.self) { formula in
                Button {
                    selectedFormula = formula
                } label: {
                    if formula == selectedFormula {
                        Label(formula, systemImage: "checkmark")
                    } else {
                        Text(formula)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selectedFormula)
                    .font(Fonts.title1)
                Image(systemName: "chevron.down")
            }
            .foregroundStyle(Color.labelsPrimary)
        }
    }
}
