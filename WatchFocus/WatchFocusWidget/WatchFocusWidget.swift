//
//  WatchFocusWidget.swift
//  WatchFocusWidget
//
//  Created by 방유빈 on 2024/02/28.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [])
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [Todo(title: "Todo1", deadline: nil, createDate: Date().timeIntervalSince1970, isChecked: false)])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var todos: [Todo] = []
        let decoder:JSONDecoder = JSONDecoder()
        if let data = UserDefaults.groupShared.object(forKey: UserDefaultsKeys.todo.rawValue) as? Data{
            if let saveData = try? decoder.decode([Todo].self, from: data){
                todos = saveData.filter { $0.isChecked == false }
            }
        }
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, todos: todos)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var todos: [Todo]
    //    let configuration: ConfigurationAppIntent
}

struct WatchFocusWidgetEntryView : View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall, .systemMedium, .systemLarge:
            TodoWidgetView(entry: entry, size: .defaultSize)
        case .accessoryRectangular:
            TodoWidgetView(entry: entry, size: .smallSize)
        default:
            EmptyView()
        }
    }
}

struct WatchFocusWidget: Widget {
    let kind: String = "WatchFocusWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WatchFocusWidgetEntryView(entry: entry)
                .containerBackground(Color.wfBackgroundGray.tertiary, for: .widget)
        }
        .configurationDisplayName("Select ToDo Style")
        .description(Text("Todo 목록 스타일을 선택하여 위젯을 나타낼 수 있습니다."))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular])
    }
}

struct TodoWidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    enum Size {
        case smallSize
        case defaultSize
    }
    let entry: Provider.Entry
    var size: Size
    var prefixCount: Int {
        switch widgetFamily {
        case .systemSmall, .systemMedium :
            return 3
        case .systemLarge:
            return 6
        case .accessoryRectangular:
            return 2
        case .accessoryInline, .accessoryCircular, .systemExtraLarge:
            return 0
        @unknown default:
            return 0
        }
    }
    
    var body: some View {
        VStack(alignment: entry.todos.isEmpty ? .center : .leading) {
            Text("Todos")
                .font(size == .defaultSize ? Font.system(size: 25, weight: .heavy) : Font.system(size: 15, weight: .heavy))
                .padding(.bottom, 5)
            if entry.todos.isEmpty {
                Text("Complete all Todos")
            } else {
                VStack {
                    ForEach(entry.todos.prefix(prefixCount)) { todo in
                        HStack{
                            Button(intent: CheckTodoIntent(todoId: todo.id)) {
                                todo.isChecked ? Image(systemName: "checkmark.circle.fill") :
                                Image(systemName: "circle")
                            }
                            .buttonStyle(.plain)
                            .font(size == .defaultSize ? Font.system(size: 20) : Font.system(size: 15))
                            .foregroundStyle(Color.wfMainPurple)
                            .padding(.trailing, 5)
                            
                            VStack(alignment: .leading) {
                                Text(todo.title)
                                    .font(size == .defaultSize ? .wfBody1Font : .wfCalloutFont)
                                if let deadline = todo.deadline, size == .defaultSize {
                                    Text(deadline.toStringDeadLine())
                                        .font(.wfCalloutFont)
                                        .foregroundStyle(Color.wfGray)
                                }
                            }
                            Spacer()
                        }
                        .padding(.bottom, 3)
                    }
                }
            }
            Spacer()
        }
    }
}
