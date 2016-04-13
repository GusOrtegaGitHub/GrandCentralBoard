//
//  CalendarNameSource.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 12.04.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import GrandCentralBoardCore

final class CalendarNameSource : Asynchronous {
    typealias ResultType = Result<Calendar>
    let sourceType: SourceType = .Momentary

    let calendarID: String
    let interval: NSTimeInterval
    let dataProvider: CalendarDataProviding

    init(calendarID: String, dataProvider: CalendarDataProviding, refreshInterval: NSTimeInterval = 3600*24) {
        self.calendarID = calendarID
        self.interval = refreshInterval
        self.dataProvider = dataProvider
    }

    func read(closure: (ResultType) -> Void) {
        dataProvider.fetchCalendar(calendarID) { result in
            switch result {
            case .Success(let calendar): closure(.Success(calendar))
            case .Failure(let error): closure(.Failure(error))
            }
        }
    }
}
