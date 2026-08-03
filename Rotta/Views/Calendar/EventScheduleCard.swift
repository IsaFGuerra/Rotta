//
//  EventScheduleCard.swift
//  Rotta
//

import SwiftUI

/// Card com a programação da rodada: cabeçalho do país + até três dias.
/// Equivale ao `OpenCalendarComponent`.
struct EventScheduleCard: View {
    let events: [EventModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let schedule {
                EventHeaderView(
                    raceNumber: "Rodada \(schedule.round)",
                    flag: schedule.country.getCountryFlag(),
                    countryName: schedule.country
                )

                if let first = schedule.firstDay {
                    TwoEventDayView(day: first)
                }

                if let second = schedule.secondDay {
                    SingleEventDayView(day: second, iconColor: .cyan)
                }

                if let third = schedule.thirdDay {
                    SingleEventDayView(day: third, iconColor: .cyan)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Image("lusail-international-circuit")
                .resizable()
                .scaledToFill()
                .overlay(Gradients.calendar)
        }
        .clipShape(.rect(cornerRadius: 16))
    }

    private var schedule: Schedule? { Schedule(events: events) }
}

// MARK: - Modelagem da programação

/// Reproduz a lógica de agrupamento do `OpenCalendarComponent.configure(with:)`.
private struct Schedule {
    struct DayEntry {
        let weekday: String
        let dayNumber: String
        let events: [EventModel]
    }

    let round: Int16
    let country: String
    let firstDay: DayEntry?
    let secondDay: DayEntry?
    let thirdDay: DayEntry?

    init?(events: [EventModel]) {
        let calendar = Calendar.current
        let sorted = events.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        guard let fallback = sorted.first else { return nil }

        let now = Date()
        let defaultEvent = sorted.first { ($0.date ?? Date()) >= now } ?? fallback

        let grouped = Dictionary(grouping: sorted) { event in
            calendar.startOfDay(for: event.date ?? Date())
        }

        let defaultDay = calendar.startOfDay(for: defaultEvent.date ?? Date())
        guard let defaultDayEvents = grouped[defaultDay] else { return nil }

        round = defaultEvent.roundNumber
        country = defaultEvent.country

        let byStartTime = defaultDayEvents.sorted { $0.startTime < $1.startTime }
        firstDay = byStartTime.count >= 2
            ? Schedule.entry(for: defaultDay, events: Array(byStartTime.prefix(2)), calendar: calendar)
            : nil

        secondDay = Schedule.nextEntry(after: defaultDay, offset: 1, grouped: grouped, calendar: calendar)
        thirdDay = Schedule.nextEntry(after: defaultDay, offset: 2, grouped: grouped, calendar: calendar)
    }

    private static func nextEntry(
        after day: Date,
        offset: Int,
        grouped: [Date: [EventModel]],
        calendar: Calendar
    ) -> DayEntry? {
        guard let target = calendar.date(byAdding: .day, value: offset, to: day),
              let events = grouped[target],
              let first = events.sorted(by: { $0.startTime < $1.startTime }).first
        else { return nil }

        return entry(for: target, events: [first], calendar: calendar)
    }

    private static func entry(for day: Date, events: [EventModel], calendar: Calendar) -> DayEntry {
        DayEntry(
            weekday: day.formatted(.dateTime.weekday(.abbreviated)).uppercased(),
            dayNumber: "\(calendar.component(.day, from: day))",
            events: events
        )
    }
}

// MARK: - Subcomponentes

/// Cabeçalho: número da rodada, bandeira e país, com divisória embaixo.
private struct EventHeaderView: View {
    let raceNumber: String
    let flag: String
    let countryName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 10) {
                Text(raceNumber)
                    .font(Fonts.subtitle1)

                HStack(spacing: 1) {
                    Text(flag)
                    Text(countryName)
                        .font(Fonts.title2)
                }
            }
            .foregroundStyle(.white)
            .padding(8)

            Rectangle()
                .fill(Color.dividerSecondary)
                .frame(height: 0.5)
        }
    }
}

/// Um dia com um único evento.
private struct SingleEventDayView: View {
    let day: Schedule.DayEntry
    let iconColor: Color

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            DayNumberView(weekday: day.weekday, dayNumber: day.dayNumber)
                .frame(alignment: .center)

            if let event = day.events.first {
                EventInfoView(event: event, iconColor: iconColor)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 8)
        .background(Color.backgroundSecondary, in: .rect(cornerRadius: 12))
    }
}

/// Um dia com dois eventos separados por uma linha.
private struct TwoEventDayView: View {
    let day: Schedule.DayEntry

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            DayNumberView(weekday: day.weekday, dayNumber: day.dayNumber)
                .padding(.top, 16)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(day.events.enumerated()), id: \.offset) { index, event in
                    if index > 0 {
                        Rectangle()
                            .fill(Color.dividerSecondary)
                            .frame(height: 0.5)
                    }
                    EventInfoView(event: event, iconColor: .f2Quali)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
        .background(Color.backgroundSecondary, in: .rect(cornerRadius: 12))
    }
}

/// Dia da semana em cima, número embaixo.
private struct DayNumberView: View {
    let weekday: String
    let dayNumber: String

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(weekday)
                .font(Fonts.subtitle2)
            Text(dayNumber)
                .font(Fonts.title2)
        }
        .foregroundStyle(.white)
        .fixedSize()
    }
}

/// Bolinha colorida + nome do evento + horário.
private struct EventInfoView: View {
    let event: EventModel
    let iconColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Circle()
                    .fill(iconColor)
                    .frame(width: 8, height: 8)

                Text(event.name)
                    .font(Fonts.headline)
            }

            Text("\(event.startTime) - \(event.endTime)")
                .font(Fonts.bodyRegular)
        }
        .foregroundStyle(.white)
        .padding(.top, 8)
    }
}
