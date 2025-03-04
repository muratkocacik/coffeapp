//
//  CartView.swift
//  CoffeApp
//
//  Created by Murat KOCACIK on 3.03.2025.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack {
            if cartViewModel.cartItems.isEmpty {
                Text("Sepetiniz Boş!")
                    .font(.headline)
                    .padding()
            } else {
                List {
                    ForEach(cartViewModel.cartItems, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Button(action: {
                                if let index = cartViewModel.cartItems.firstIndex(of: item) {
                                    cartViewModel.removeItem(at: index)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                Text("Toplam: \(cartViewModel.totalAmount(), specifier: "%.2f") TL")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    // Ödeme sayfasına yönlendirme işlemi yapılacak
                    print("Ödeme sayfasına yönlendiriliyor.")
                }) {
                    Text("Ödeme Yap")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationTitle("Sepet")
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(cartViewModel: CartViewModel())
    }
}

