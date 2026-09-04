//
//  LocalProductRepository.swift
//  Groceries
//
//  Created by Shuvam Shrestha on 21/8/2026.
//

import Foundation

class LocalProductRepository: ProductRepository {
    private(set) var products: [Product] = []
    
    init() {
        products = load()
    }
    
    func load() -> [Product] {
        let localProducts = [
            Product(title: "Pineapple", price: 12.99, imageURL: "https://www.publicdomainpictures.net/pictures/540000/nahled/yellow-pineapple-1695980459X0Z.jpg"),
            Product(title: "Tomato", price: 4.5, imageURL: "https://www.publicdomainpictures.net/pictures/540000/nahled/red-tomato-1695981612wVo.jpg"),
            Product(title: "Orange", price: 3.5, imageURL: "https://www.publicdomainpictures.net/pictures/540000/nahled/orange-fruit-1695981613Oti.jpg")
        ]
       
        return localProducts
    }
    
    func add(_ product: Product) {
        products.append(product)
    }
    
    func update(_ product: Product) {
        guard let index = products.firstIndex(where: {$0.id == product.id}) else { return }
        
        products[index] = product
    }
    
    func delete(_ product: Product) {
        guard let index = products.firstIndex(where: {$0.id == product.id}) else { return }
        
        products.remove(at: index)
    }
    
    
}



