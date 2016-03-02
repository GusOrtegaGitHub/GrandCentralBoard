//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import Foundation
import Decodable

enum WatchWidgetBuilderException : ErrorType, HavingMessage {
    case WrongSettings

    var message: String {
        switch self {
            case .WrongSettings:
                return "Wrong settings format in WatchWidgetBuilder!"
        }
    }
}

final class WatchWidgetBuilder : WidgetBuilding {

    let name = "watch"

    func build(settings: AnyObject) throws -> Widget {

        if let settings = try? TimeSourceSettings.decode(settings) {
            let timeSource = TimeSource(settings: settings)
            let eventSource = EventsSource(settings: EventsSourceSettings(calendarPath: settings.calendarPath))
            return WatchWidget(sources: [timeSource, eventSource])
        }

        throw WatchWidgetBuilderException.WrongSettings
    }
}