//
//  CoffeeSelectionView.swift
//  CoffeApp
//
//  Created by Murat KOCACIK on 3.03.2025.
//

import SwiftUI

struct Coffee: Identifiable {
    var id = UUID()
    var name: String
    var price: Double
}

struct CoffeeSelectionView: View {
    @State private var selectedCoffee: Coffee? = nil
    @State private var coffeeList = [
        Coffee(name: "Espresso", price: 20.0),
        Coffee(name: "Latte", price: 25.0),
        Coffee(name: "Cappuccino", price: 22.0),
        Coffee(name: "Americano", price: 18.0)
    ]
    
    var body: some View {
        NavigationView {
            List(coffeeList) { coffee in
                HStack {
                    Text(coffee.name)
                        .font(.title2)
                    Spacer()
                    Text("\(coffee.price, specifier: "%.2f") TL")
                        .font(.title3)
                }
                .padding()
                .onTapGesture {
                    selectedCoffee = coffee
                }
            }
            .navigationTitle("Kahve Seçimi")
            .navigationBarItems(trailing: NavigationLink(
                destination: CheckoutView(coffee: selectedCoffee),
                label: {
                    Text("Sipariş Ver")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            ))
        }
    }
}

struct CoffeeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeSelectionView()
    }
}

