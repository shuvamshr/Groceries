//
//  ProductViewModel.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 14/8/2026.
//

import Foundation
import Combine

final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    init() {
        load()
    }
    
    func load() {
        self.products = loadJSONProduct()
    }
    
    func loadLocalProduct() -> [Product] {
        
        let localProducts = [
            Product(title: "Pineapple", image: "pineapple"),
            Product(title: "Tomato", description: "Please get the Roma kind, not the Gourmet. I'll go ham if I receive a Gourmet."),
            Product(title: "Orange", isPurchased: true)
        ]
       
        return localProducts
    }
    
    func loadJSONProduct() -> [Product] {
        
        guard let url: URL = Bundle.main.url(forResource: "SampleProducts", withExtension: "json") else { return [] }
        
        do {
            let data: Data = try Data(contentsOf: url)
            let JSONProducts: [Product] = try JSONDecoder().decode([Product].self, from: data)
            return JSONProducts
        } catch {
            return []
        }
    }

    
    func update() {
        
    }
    
    func delete() {
        
    }
    
}
