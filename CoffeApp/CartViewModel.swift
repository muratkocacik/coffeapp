//
//  CartViewModel.swift
//  CoffeApp
//
//  Created by Murat KOCACIK on 3.03.2025.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [String] = []
    
    func addItem(_ item: String) {
        cartItems.append(item)
    }
    
    func removeItem(at index: Int) {
        cartItems.remove(at: index)
    }
    
    func totalAmount() -> Double {
        // Basit bir fiyat hesaplaması
        return Double(cartItems.count) * 20.0
    }
}
