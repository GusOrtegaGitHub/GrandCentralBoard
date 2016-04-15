//
//  HarvestTeamStats.swift
//  GrandCentralBoard
//
//  Created by Karol Kozub on 2016-04-11.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Decodable


struct DailyBillingStats {
    let day: NSDate
    let groups: [BillingStatsGroup]
}


extension DailyBillingStats : Decodable {
    static func decode(json: AnyObject) throws -> DailyBillingStats {
        var hoursForUserIDs = [Int: Double]()
        let entries: [DayEntry] = try json => "day_entries"

        for entry in entries {
            hoursForUserIDs[entry.userID] = (hoursForUserIDs[entry.userID] ?? 0) + entry.hours
        }

        var countsForTypes = [BillingStatsGroupType: Int]()
        var hoursForTypes = [BillingStatsGroupType: Double]()

        for hours in hoursForUserIDs.values {
            let type = BillingStatsGroup.typeForHours(hours)

            countsForTypes[type] = (countsForTypes[type] ?? 0) + 1
            hoursForTypes[type] = (hoursForTypes[type] ?? 0.0) + hours
        }

        var groups = [BillingStatsGroup]()

        for type in BillingStatsGroup.allTypes() {
            let count = countsForTypes[type] ?? 0
            let hours = hoursForTypes[type] ?? 0.0
            let averageHours = hours / Double(max(count, 1))

            let group = BillingStatsGroup(type: type, count: count, averageHours: averageHours)

            groups.append(group)
        }

        return DailyBillingStats(day: NSDate(), groups: groups)
    }

    private struct DayEntry : Decodable {
        let userID: Int
        let hours: Double

        static func decode(json: AnyObject) throws -> DayEntry {
            return try DayEntry(userID: json => "user_id", hours: json => "hours")
        }
    }
}
