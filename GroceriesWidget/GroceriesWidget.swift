//
//  GroceriesWidget.swift
//  GroceriesWidget
//
//  Created by Shuvam Shrestha on 18/9/2026.
//

import WidgetKit
import SwiftUI



// Data Model

struct ShoppingItem: Identifiable {
    let id: String
    let title: String
    let isPurchased: Bool = false
}

struct ShoppingList: Identifiable {
    let id: String
    let title: String
    let items: [ShoppingItem]
}

enum ShoppingData {
    static let lists: [ShoppingList] = [
        ShoppingList(id: "01", title: "Woolies", items: [
            ShoppingItem(id: "01", title: "Tomato"),
            ShoppingItem(id: "02", title: "Potato"),
            ShoppingItem(id: "03", title: "Zomato"),
        ]),
        ShoppingList(id: "02", title: "Coles", items: [
            ShoppingItem(id: "01", title: "Tomato"),
            ShoppingItem(id: "02", title: "Potato"),
            ShoppingItem(id: "03", title: "Zomato"),
        ]),
    ]
}

struct ShoppingWidgetEntry: TimelineEntry {
    let date: Date
    let headline: String
}

struct ShoppingWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> ShoppingWidgetEntry {
        ShoppingWidgetEntry(date: .now, headline: "I'm a placeholder")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ShoppingWidgetEntry) -> Void) {
        completion(ShoppingWidgetEntry(date: .now, headline: "I'm a placeholder"))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ShoppingWidgetEntry>) -> Void) {
        let timeline = Timeline(entries: [ShoppingWidgetEntry(date: .now, headline: "I'm a timeline")], policy: .never)
        completion(timeline)
    }
}

struct ShoppingWidgetView: View {
    var entry: ShoppingWidgetEntry
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        if family == .systemSmall {
            VStack {
                Image(systemName: "basket.fill")
                Text(entry.headline)
            }
        } else if family == .systemMedium {
            VStack {
                Image(systemName: "basket.fill")
                    .imageScale(.large)
                Text(entry.headline)
                    .font(.headline)
                Button("Open App") {
                    
                }
            }
        } else if family == .systemLarge {
            VStack {
                HStack {
                    Image(systemName: "basket.fill")
                        .imageScale(.large)
                    Image(systemName: "carrot.fill")
                }
                    .imageScale(.large)
                Text(entry.headline)
                    .font(.largeTitle)
                Button("Open App") {
                    
                }
            }
        } else {
            Text("Something Went Wrong")
        }
    }
}

struct ShoppingWidget: Widget {
    let kind: String = "ShoppingWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShoppingWidgetProvider()) { entry in
            ShoppingWidgetView(entry: entry)
                .containerBackground(Color.white, for: .widget)
        }
        .configurationDisplayName("Shopping")
        .description("Widget for Shopping List")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview("Shopping - Small", as: .systemSmall) {
    ShoppingWidget()
} timeline: {
    ShoppingWidgetEntry(date: .now, headline: "I'm a small Widget")
}

#Preview("Shopping - Medium", as: .systemMedium) {
    ShoppingWidget()
} timeline: {
    ShoppingWidgetEntry(date: .now, headline: "I'm a mid Widget")
}

#Preview("Shopping - Large", as: .systemLarge) {
    ShoppingWidget()
} timeline: {
    ShoppingWidgetEntry(date: .now, headline: "I'm a large Widget")
}
