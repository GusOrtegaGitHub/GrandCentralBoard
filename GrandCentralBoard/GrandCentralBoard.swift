//
//  Created by Oktawian Chojnacki on 24.02.2016.
//  Copyright © 2016 Oktawian Chojnacki. All rights reserved.
//

import UIKit

final class GrandCentralBoard {

    private let stack = AutoStack()
    private let scheduler = Scheduler()
    private let expectedWidgetsCount = 6

    private var widgets : [Widget]

    var view: UIView {
        return stack
    }

    init(configuration: Configuration) {

        widgets = configuration.settings.flatMap({ widgetConfiguration in
            
            if let builder = configuration.builders.filter({ $0.name == widgetConfiguration.name }).first {
                return try? builder.build(widgetConfiguration.settings)
            }

            return nil
        })

        assert(widgets.count == expectedWidgetsCount)

        widgets.forEach { widget in
            stack.stackView(widget.view)
            scheduler.schedule(Job(target: widget))
        }
    }
}