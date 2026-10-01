//
//  PriceHistoryChart.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Charts
import SwiftUI

struct PriceHistoryChart: View {
    let points: [PricePoint]

    var body: some View {
        Chart(points) { point in
            // `.stepEnd` holds each price flat until the next change.
            LineMark(x: .value("Date", point.date), y: .value("Price", point.price.doubleValue))
                .interpolationMethod(.stepEnd)

            // The last point only extends the line to today, so it gets no dot.
            if point != points.last {
                PointMark(x: .value("Date", point.date), y: .value("Price", point.price.doubleValue))
                    .foregroundStyle(by: .value("Type", point.isPromotion ? "Sale" : "Regular"))
            }
        }
        .chartForegroundStyleScale(["Regular": Color.accentColor, "Sale": Color.red])
        .chartYScale(domain: .automatic(includesZero: false))
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let price = value.as(Double.self) {
                        Text(price, format: .currency(code: Locale.appCurrencyCode))
                    }
                }
            }
        }
    }
}

#Preview {
    PriceHistoryChart(points: LocalGroceryRepository.sampleProducts[0].priceTimeline())
        .frame(height: 220)
        .padding()
}
