//
//  WatchFocusWidgetLiveActivity.swift
//  WatchFocusWidget
//
//  Created by 방유빈 on 2024/02/28.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WatchFocusWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var progress: Double
        var remainTime: Int
    }
    // Fixed non-changing properties about your activity go here!
    var totalTime: Int
    var timerType: TimerType
    var iterationCount: Int
    var progressColor: WfColor {
        return timerType == .focus ? .wfMainPurple : .wfMainBlue
    }
}

struct WatchFocusWidgetLiveActivity: Widget {
    @Environment(\.colorScheme) var scheme
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WatchFocusWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Session \(context.attributes.iterationCount)")
                    .font(.wfBody1Font)
                    .bold()
                Text("\(context.state.remainTime.timeFormatting())")
                    .font(.wfTitleFont)
                HStack {
                    Text("0 m")
                        .font(.wfCalloutFont)
                        .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                    WfProgressBar(progress: 1.0 - context.state.progress, progressColor: context.attributes.progressColor)
                    Text("\(context.attributes.totalTime / 60) m")
                        .font(.wfCalloutFont)
                        .foregroundStyle(WfColor.wfGray.returnColor(scheme: scheme))
                }
                .padding()
                if context.attributes.timerType == .focus {
                    Text("\(context.attributes.totalTime / 60)분 동안 집중해봅시다.")
                        .font(.wfCalloutFont)
                } else {
                    Text("\(context.attributes.totalTime / 60)분 동안 쉬어갈게요.")
                        .font(.wfCalloutFont)
                }
            }
            .padding()
//            .foregroundStyle(scheme == .light ? .black : .white)
            .activityBackgroundTint(Color.white.opacity(0.5))
//            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        context.attributes.timerType == .focus ? Image(systemName: "flame.fill") : Image(systemName: "cup.and.saucer.fill")
                    }
                    .padding(5)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(100 - context.state.progress.toPercent())%")
                        .padding(5)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Session \(context.attributes.iterationCount)")
                        .bold()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.remainTime.timeFormatting())
                        .font(.wfTitleFont)
                    HStack(alignment: .top) {
                        Text("0 m")
                        WfProgressBar(progress: 1.0 - context.state.progress, progressColor: context.attributes.progressColor)
                        Text("\(context.attributes.totalTime / 60) m")
                    }
                    .padding(5)
                }
            } compactLeading: {
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 3)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(context.state.progress, 1.0)))
                        .stroke(context.attributes.progressColor.returnColor(scheme: scheme), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(Angle(degrees: -90))
                }
                .padding(2)
            } compactTrailing: {
                Text("\(100 - context.state.progress.toPercent())%")
            } minimal: {
                Text("\(100 - context.state.progress.toPercent())")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

