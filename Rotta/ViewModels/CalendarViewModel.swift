//
//  CalendarViewModel.swift
//  Rotta
//

import Foundation
import Observation

@MainActor
@Observable
final class CalendarViewModel {
    /// 25 meses centrados no mês atual (12 antes, 12 depois), como no original.
    private(set) var months: [Date] = []
    var currentMonthIndex = 12
    var selectedDate: Date?

    /// Eventos agrupados por dia (chave em UTC, igual ao `EventService`).
    private(set) var eventsByDay: [Date: [EventModel]] = [:]

    /// Eventos da rodada selecionada, exibidos no card inferior.
    private(set) var scheduleEvents: [EventModel] = []

    private let eventService = EventService()
    private var allEvents: [EventModel] = []

    private static var utcCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()

    var currentMonth: Date {
        months.indices.contains(currentMonthIndex) ? months[currentMonthIndex] : Date()
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMM"
        return formatter.string(from: currentMonth).capitalized
    }

    init() {
        buildMonths()
    }

    private func buildMonths() {
        let calendar = Calendar.current
        let now = Date()
        guard let start = calendar.date(byAdding: .month, value: -12, to: now) else { return }

        months = (0..<25).compactMap {
            calendar.date(byAdding: .month, value: $0, to: start)
        }
        currentMonthIndex = 12
    }

    func hasEvent(on date: Date) -> Bool {
        let key = Self.utcCalendar.startOfDay(for: date)
        return !(eventsByDay[key]?.isEmpty ?? true)
    }

    /// Carrega todos os eventos de uma vez e monta o cache por dia.
    func loadAllEvents() async {
        allEvents = await eventService.getAll()

        var grouped: [Date: [EventModel]] = [:]
        for event in allEvents {
            guard let date = event.date else { continue }
            grouped[Self.utcCalendar.startOfDay(for: date), default: []].append(event)
        }
        eventsByDay = grouped

        if scheduleEvents.isEmpty {
            scheduleEvents = allEvents
        }
    }

    /// Ao tocar num dia, mostra a rodada inteira daquele evento.
    func select(date: Date) {
        selectedDate = date

        let key = Self.utcCalendar.startOfDay(for: date)
        guard let roundNumber = eventsByDay[key]?.first?.roundNumber else { return }

        scheduleEvents = allEvents.filter { $0.roundNumber == roundNumber }
    }

    /// Dias do mês com `nil` para preencher a primeira e a última semana.
    func days(in month: Date) -> [Date?] {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: month) else { return [] }

        let firstOfMonth = interval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        let numberOfDays = calendar.range(of: .day, in: .month, for: month)?.count ?? 0
        for day in 0..<numberOfDays {
            days.append(calendar.date(byAdding: .day, value: day, to: firstOfMonth))
        }

        while days.count % 7 != 0 {
            days.append(nil)
        }

        return days
    }
}
