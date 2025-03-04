//
//  CoffeeDetailView.swift
//  CoffeApp
//
//  Created by Murat KOCACIK on 3.03.2025.
//

import SwiftUI

struct CoffeeDetailView: View {
    var coffeeName: String
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack {
            Text(coffeeName)
                .font(.largeTitle)
                .padding()
            
            Text("Fiyat: 20 TL")
                .font(.title2)
                .padding()
            
            Button(action: {
                cartViewModel.addItem(coffeeName)
                print("\(coffeeName) sepete eklendi!")
            }) {
                Text("Sepete Ekle")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle(coffeeName)
    }
}

struct CoffeeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeDetailView(coffeeName: "Latte")
            .environmentObject(CartViewModel()) // Örnek kullanım için
    }
}

