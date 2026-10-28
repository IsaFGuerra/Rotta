//
//  CalendarScreen.swift
//  Rotta
//

import SwiftUI

struct CalendarScreen: View {
    let formulaName: String
    @State private var viewModel = CalendarViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                MonthCalendarView(viewModel: viewModel)
                    .frame(height: 500)
                    .background(Color.fillsUnselected, in: .rect(cornerRadius: 20))

                EventScheduleCard(events: viewModel.scheduleEvents)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
        .background(Color.black)
        .task(id: formulaName) {
            await viewModel.loadAllEvents(formulaName: formulaName)
        }
    }
}
