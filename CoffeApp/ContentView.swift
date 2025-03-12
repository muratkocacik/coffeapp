import SwiftUI

struct ContentView: View {
    // Kahve seçenekleri
    let coffeeOptions = ["Espresso", "Latte", "Cappuccino", "Americano", "Macchiato"]
    
    @State private var selectedCoffee: String? = nil
    @State private var cart: [String] = []
    @State private var messageText: String = ""
    @State private var showMessage: Bool = false
    
    // Sepeti gruplandırma
    var groupedCart: [(key: String, count: Int)] {
        let groups = Dictionary(grouping: cart, by: { $0 })
        return groups.map { (key: $0.key, count: $0.value.count) }
            .sorted { $0.key < $1.key }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Dinamik Mesaj Alanı
                if showMessage {
                    Text(messageText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(messageText == "Sepetten çıkarıldı!" ? Color.red.opacity(0.9) : Color.green.opacity(0.9))
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut, value: showMessage)
                }
                
                // Başlık
                Text("Favori Kahveni Seç!")
                .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Kahve Seçenekleri Kartları
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(coffeeOptions, id: \.self) { coffee in
                            CoffeeCardView(coffee: coffee, isSelected: coffee == selectedCoffee) {
                                selectCoffee(coffee)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Sepet Görünümü
                if cart.isEmpty {
                    VStack {
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("Sepetiniz boş.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    VStack(alignment: .leading) {
                        Text("Sepetiniz:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        ForEach(groupedCart, id: \.key) { item in
                            CartItemView(item: item, onRemove: removeItem)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Ödeme Ekranına Geçiş Butonu
                if !cart.isEmpty {
                    NavigationLink(destination: PaymentScreen(cart: cart)) {
                        Text("Ödeme Ekranına Geç")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Kahve Seçimi")
        }
    }
    
    // Kahve Seçme İşlevi
    private func selectCoffee(_ coffee: String) {
        selectedCoffee = coffee
        cart.append(coffee)
        
        // Mesajı göster
        withAnimation {
            messageText = "Sepete eklendi!"
            showMessage = true
        }
        
        // Mesajı 2 saniye sonra gizle
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showMessage = false
            }
        }
    }
    
    // Sepetten Ürün Kaldırma İşlevi
    private func removeItem(_ product: String) {
        if let index = cart.firstIndex(of: product) {
            cart.remove(at: index)
            
            withAnimation {
                messageText = "Sepetten çıkarıldı!"
                showMessage = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showMessage = false
                }
            }
        }
    }
}

// Kahve Kart Görünümü
struct CoffeeCardView: View {
    let coffee: String
    let isSelected: Bool
    let onTap: () -> Void
    
    // Kahveye göre uygun ikonu belirleme
    private func coffeeIcon(for coffee: String) -> String {
        switch coffee {
        case "Espresso": return "cup.and.saucer.fill"
        case "Latte": return "mug.fill"
        case "Cappuccino": return "cloud.fill"
        case "Americano": return "drop.fill"
        case "Macchiato": return "leaf.fill"
        default: return "questionmark.circle"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: coffeeIcon(for: coffee))
                .foregroundColor(.brown)
                .font(.title2)
            
            Text(coffee)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        .onTapGesture(perform: onTap)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}
// Sepet Öğesi Görünümü
struct CartItemView: View {
    let item: (key: String, count: Int)
    let onRemove: (String) -> Void
    
    var body: some View {
        HStack {
            Text("\(item.key) x\(item.count)")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                onRemove(item.key)
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .shadow(radius: 3)
        .transition(.slide)
    }
}

// ✅ Ödeme Görünümü (Hatalı olan `CheckoutView` yerine `PaymentScreen` adını kullanıyoruz)
struct PaymentScreen: View {
    let cart: [String]
    
    var body: some View {
        VStack {
            Text("Ödeme Ekranı")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            List(cart, id: \.self) { coffee in
                Text(coffee)
            }
        }
    }
}

// Önizleme
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
