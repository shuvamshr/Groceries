//
//  LocalGroceryRepository.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 1/10/2026.
//

import Foundation

/// Built-in sample data for previews and for running without Supabase.
struct LocalGroceryRepository: GroceryRepository {
    func fetchProducts() async throws -> [Product] {
        Self.sampleProducts
    }
}

// MARK: - Sample Data

extension LocalGroceryRepository {
    static let sampleProducts: [Product] = [
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000001",
            name: "Full Cream Milk 2L",
            barcode: "9300633603232",
            category: "Dairy",
            // (days from today, regular price)
            priceHistory: [(-90, "3.50"), (-20, "3.80")],
            // (start day, end day, sale price)
            promotions: [(-45, -38, "2.99"), (-1, 3, "2.90")],
            imageURL: wikimediaImage("a/a5/Glass_of_Milk_%2833657535532%29.jpg/330px-Glass_of_Milk_%2833657535532%29.jpg")
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000002",
            name: "Sourdough Loaf",
            barcode: "9310072011691",
            category: "Bakery",
            priceHistory: [(-120, "5.90"), (-60, "6.20"), (-10, "6.50")],
            promotions: [],
            imageURL: wikimediaImage("3/3b/Home_made_sour_dough_bread.jpg/330px-Home_made_sour_dough_bread.jpg")
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000003",
            name: "Ground Coffee 500g",
            barcode: "9300605095829",
            category: "Pantry",
            priceHistory: [(-100, "16.00"), (-30, "18.00")],
            promotions: [(-70, -60, "13.50"), (-2, 5, "12.00")],
            imageURL: wikimediaImage("c/c5/Roasted_coffee_beans.jpg/330px-Roasted_coffee_beans.jpg")
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000004",
            name: "Pink Lady Apples 1kg",
            barcode: "2000000012345",
            category: "Fruit & Veg",
            priceHistory: [(-80, "5.50"), (-15, "5.90")],
            // Already over, so it shouldn't show as a sale.
            promotions: [(-10, -3, "3.90")],
            imageURL: wikimediaImage("a/a6/Pink_lady_and_cross_section.jpg/330px-Pink_lady_and_cross_section.jpg")
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000005",
            name: "Greek Yoghurt 1kg",
            barcode: "9300601111116",
            category: "Dairy",
            priceHistory: [(-60, "6.00"), (-25, "6.50")],
            promotions: [(-3, 4, "4.50")]
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000006",
            name: "Bananas 1kg",
            barcode: "2000000067890",
            category: "Fruit & Veg",
            priceHistory: [(-90, "3.90"), (-40, "4.50"), (-12, "3.50")],
            promotions: [],
            imageURL: wikimediaImage("d/de/Bananavarieties.jpg/330px-Bananavarieties.jpg")
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000007",
            name: "Butter Croissants 4 Pack",
            barcode: "9310072022222",
            category: "Bakery",
            priceHistory: [(-70, "5.00"), (-5, "5.50")],
            promotions: [],
            imageURL: wikimediaImage("2/2a/Croissant-Petr_Kratochvil.jpg/330px-Croissant-Petr_Kratochvil.jpg")
        ),
        sampleProduct(
            id: "A1B2C3D4-0000-0000-0000-000000000008",
            name: "Extra Virgin Olive Oil 750ml",
            barcode: "9300652033333",
            category: "Pantry",
            priceHistory: [(-110, "11.00"), (-50, "13.00")],
            promotions: [(-1, 6, "9.75")]
        ),
    ]
}

// MARK: - Helpers

private extension LocalGroceryRepository {
    /// Dates are day offsets from today so the samples never go stale. The ID
    /// is fixed, like a real database ID, so saved locks still match after a
    /// relaunch. The current shelf price is the last `priceHistory` entry.
    static func sampleProduct(
        id: String,
        name: String,
        barcode: String,
        category: String,
        priceHistory: [(day: Int, price: String)],
        promotions: [(start: Int, end: Int, price: String)],
        imageURL: URL? = nil
    ) -> Product {
        let id = UUID(uuidString: id)!
        let changes = priceHistory.map {
            PriceChange(id: UUID(), productID: id, price: price($0.price), changedAt: daysFromNow($0.day))
        }
        return Product(
            id: id,
            name: name,
            barcode: barcode,
            category: category,
            imageURL: imageURL,
            shelfPrice: changes.last!.price,
            promotions: promotions.map {
                Promotion(id: UUID(), productID: id, salePrice: price($0.price),
                          startDate: daysFromNow($0.start), endDate: daysFromNow($0.end))
            },
            priceHistory: changes
        )
    }

    /// Photos from Wikimedia Commons. The yoghurt and olive oil have none, to
    /// show the placeholder.
    static func wikimediaImage(_ path: String) -> URL {
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/" + path)!
    }

    static func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: .now)!
    }

    /// From a string, because `Decimal(3.80)` goes through `Double` and picks
    /// up its rounding error.
    static func price(_ string: String) -> Decimal {
        Decimal(string: string)!
    }
}
