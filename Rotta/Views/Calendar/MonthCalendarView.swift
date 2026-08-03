//
//  MonthCalendarView.swift
//  Rotta
//

import SwiftUI

/// Calendário paginado horizontalmente por mês.
struct MonthCalendarView: View {
    @Bindable var viewModel: CalendarViewModel

    private let weekdays = ["D", "S", "T", "Q", "Q", "S", "S"]

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.monthTitle)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.rottaYellow)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 16)
                .padding(.leading, 30)
                .padding(.trailing, 46)

            HStack(spacing: 0) {
                ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                    Text(day)
                        .font(Fonts.bodyEmphasized)
                        .foregroundStyle(isWeekend(index) ? Color.rottaYellow : Color(.systemGray))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 30)

            monthPager
                .padding(.top, 8)
                .padding(.horizontal, 30)
        }
    }

    private func isWeekend(_ index: Int) -> Bool {
        index == 0 || index == 5 || index == 6
    }

    private var monthPager: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(Array(viewModel.months.enumerated()), id: \.offset) { index, month in
                    MonthGrid(
                        days: viewModel.days(in: month),
                        selectedDate: viewModel.selectedDate,
                        hasEvent: viewModel.hasEvent(on:),
                        onSelect: viewModel.select(date:)
                    )
                    .containerRelativeFrame(.horizontal)
                    .id(index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: Binding(
            get: { Optional(viewModel.currentMonthIndex) },
            set: { if let new = $0 { viewModel.currentMonthIndex = new } }
        ))
    }
}

/// Grade de um único mês.
private struct MonthGrid: View {
    let days: [Date?]
    let selectedDate: Date?
    let hasEvent: (Date) -> Bool
    let onSelect: (Date) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                CalendarDayCellView(
                    date: day,
                    isSelected: isSelected(day),
                    hasEvent: day.map(hasEvent) ?? false
                )
                .frame(height: 60)
                .contentShape(.rect)
                .onTapGesture {
                    if let day { onSelect(day) }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func isSelected(_ day: Date?) -> Bool {
        guard let day, let selectedDate else { return false }
        return Calendar.current.isDate(day, inSameDayAs: selectedDate)
    }
}

/// Um dia: número + pontinho quando há evento.
private struct CalendarDayCellView: View {
    let date: Date?
    let isSelected: Bool
    let hasEvent: Bool

    var body: some View {
        if let date {
            VStack(spacing: 8) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(hasEvent ? .system(size: 16, weight: .bold) : .system(size: 16))
                    .foregroundStyle(numberColor)

                Circle()
                    .fill(dotColor)
                    .frame(width: 8, height: 8)
                    .opacity(hasEvent ? 1 : 0)
            }
        } else {
            Color.clear
        }
    }

    private var numberColor: Color {
        if isSelected && hasEvent { return .f2Sprint }
        if hasEvent { return .rottaYellow }
        return .rottaGray
    }

    private var dotColor: Color {
        isSelected && hasEvent ? .f2Sprint : .rottaYellow
    }
}
