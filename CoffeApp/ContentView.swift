import SwiftUI

struct ContentView: View {
    // Kahve seçenekleri
    let coffeeOptions = ["Espresso", "Latte", "Cappuccino", "Americano", "Macchiato"]
    
    // Son seçilen kahve (sadece gösterim için)
    @State private var selectedCoffee: String? = nil
    // Sepet: Aynı kahve birden fazla eklenebilir
    @State private var cart: [String] = []
    // Gösterilecek mesaj metni (ekleme veya çıkarma mesajı)
    @State private var messageText: String = ""
    // Mesajın ekranda görünüp görünmeyeceğini kontrol eden state
    @State private var showMessage: Bool = false

    // Sepetteki öğeleri gruplandırarak her ürünün adedini hesaplayan computed property
    var groupedCart: [(key: String, count: Int)] {
        let groups = Dictionary(grouping: cart, by: { $0 })
        return groups.map { (key: $0.key, count: $0.value.count) }
                     .sorted { $0.key < $1.key }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sabit bir mesaj alanı (40 puan yüksekliğinde)
                VStack {
                    if showMessage {
                        Text(messageText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(messageText == "Sepetten çıkarıldı!" ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                            .cornerRadius(8)
                            .frame(maxWidth: 250)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .frame(height: 40)
                .animation(.easeInOut, value: showMessage)
                
                Spacer().frame(height: 10)
                
                // Ana içerik
                Text("Lütfen bir kahve seçin:")
                    .font(.title)
                    .padding(.horizontal)
                
                List(coffeeOptions, id: \.self) { coffee in
                    HStack {
                        Text(coffee)
                            .font(.headline)
                        if selectedCoffee == coffee {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCoffee = coffee
                        // Aynı kahve birden çok kez eklenebilir
                        cart.append(coffee)
                        
                        // Mesajı göster: "Sepete eklendi!"
                        withAnimation {
                            messageText = "Sepete eklendi!"
                            showMessage = true
                        }
                        // 2 saniye sonra mesajı gizle
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showMessage = false
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(PlainListStyle())
                
                if let selectedCoffee = selectedCoffee {
                    Text("Seçilen kahve: \(selectedCoffee)")
                        .padding()
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                if cart.isEmpty {
                    Text("Sepetiniz boş.")
                        .padding()
                        .font(.headline)
                } else {
                    VStack(alignment: .leading) {
                        Text("Sepetinizdeki kahveler:")
                            .font(.title2)
                            .padding(.bottom, 4)
                        ForEach(groupedCart, id: \.key) { item in
                            HStack {
                                Text("\(item.key) x\(item.count)")
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    removeItem(item.key)
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                }
                
                Spacer()

                // Sepete eklenen ürünlerle ödeme ekranına geçiş
                NavigationLink(destination: PaymentView(cart: cart)) {
                    Text("Ödeme Ekranına Geç")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Kahve Seçimi")
        }
    }
    
    // Belirtilen üründen sepetteki ilk öğeyi kaldırır ve "Sepetten çıkarıldı!" mesajını gösterir
    func removeItem(_ product: String) {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
