//
//  WatchFocusWidget.swift
//  WatchFocusWidget
//
//  Created by 방유빈 on 2024/02/28.
//

import WidgetKit
import SwiftUI
import DYColor
import RealmSwift

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [], configuration: ConfigurationAppIntent(category: WidgetCategory.defaultsAllCategory))
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [TodoObject(title: "Todo1", deadline: nil, createDate: Date().timeIntervalSince1970, isChecked: false)], configuration: ConfigurationAppIntent(category: WidgetCategory.defaultsAllCategory))
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let todos: [TodoObject] = await loadTodo()
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, todos: todos, configuration: configuration)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    private func loadTodo() async -> [TodoObject] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.watchFocus")
                let realmURL = container?.appendingPathComponent("default.realm")
                let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
                do {
                    let realm = try Realm(configuration: config)
                    let results = realm.objects(TodoObject.self)
                    let todos = Array(results.filter{ !$0.isChecked })
                    continuation.resume(returning: todos)
                } catch {
                    print("Realm 불러오기 실패 : \(error.localizedDescription)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var todos: [TodoObject]
    let configuration: ConfigurationAppIntent
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
    @Environment(\.colorScheme) var scheme
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
    var todos:[TodoObject] {
        entry.todos.filter {
            if let entryCategory = entry.configuration.widgetCategory.category {
                if let categoryid = $0.categoryId {
                    return Category.idToCategory(withId: categoryid)?.id == entryCategory.id
                } else {
                    return false
                }
            } else {
                return true
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.configuration.widgetCategory.category?.name ?? "Todos")
                .font(Font.system(size: 20, weight: .heavy))
                .padding(.bottom, 5)
            if todos.isEmpty {
                Spacer()
                Text("Complete all Todos")
                    .frame(maxWidth: .infinity)
                    .font(.wfTitleFont)
                    .bold()
                Spacer()
            } else {
                VStack {
                    ForEach(todos.prefix(prefixCount)) { todo in
                        HStack{
                            Button(intent: CheckTodoIntent(todoId: todo.id.stringValue)) {
                                todo.isChecked ? Image(systemName: "checkmark.circle.fill") :
                                Image(systemName: "circle")
                            }
                            .buttonStyle(.plain)
                            .font(size == .defaultSize ? Font.system(size: 20) : Font.system(size: 15))
                            .foregroundStyle(Category.idToCategory(withId: todo.categoryId)?.color.getDYColor.dynamicColor ?? DYColor.wfBlackWhite.dynamicColor)
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
