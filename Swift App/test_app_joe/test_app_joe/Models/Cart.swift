//
//  Cart.swift
//  test_app_joe
//
//  Created by Traveen Kaushalya on 2024-03-25.
//

import Foundation

struct Cart: Codable {
    let id: String
}

struct CartItem: Identifiable, Codable {
    let id: UUID
    let product: Product
    var quantity: Int
    let color: String
    let size: String
    var isSelected: Bool
    var cartID: String?  // Add cartID property

    init(product:Product, quantity: Int, color: String, size: String, isSelected: Bool = false, cartID: String? = nil) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
        self.color = color
        self.size = size
        self.isSelected = isSelected
        self.cartID = cartID // Initialize cartID
    }
}
