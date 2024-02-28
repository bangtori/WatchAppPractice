//
//  WatchFocusWidgetBundle.swift
//  WatchFocusWidget
//
//  Created by 방유빈 on 2024/02/28.
//

import WidgetKit
import SwiftUI

@main
struct WatchFocusWidgetBundle: WidgetBundle {
    var body: some Widget {
        WatchFocusWidget()
        WatchFocusWidgetLiveActivity()
    }
}
