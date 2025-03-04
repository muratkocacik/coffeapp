import SwiftUI
import PassKit

struct PaymentView: View {
    var cart: [String]
    
    // Sepetteki öğeleri gruplandırarak her ürünün adedini hesaplayan computed property
    var groupedCart: [(key: String, count: Int)] {
        let groups = Dictionary(grouping: cart, by: { $0 })
        return groups.map { (key: $0.key, count: $0.value.count) }
                     .sorted { $0.key < $1.key }
    }

    var totalAmount: Double {
        // Her kahve için 3 dolar fiyat ekledik, toplam hesaplama
        return Double(cart.count) * 3.0
    }
    
    // Apple Pay ödeme işlemine başlatmak için PKPaymentRequest
    func startApplePayPayment() {
        // Apple Pay'e uygun ödeme talebini oluştur
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "your.merchant.identifier" // Apple Developer hesabınızdan alacağınız merchantIdentifier
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        
        // Apple Pay kartları için desteklenen ödeme türlerini ayarlayın
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Kahve", amount: NSDecimalNumber(value: totalAmount))
        ]
        
        // Apple Pay işlemi başlat
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.visa, .masterCard]) {
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentController?.delegate = PaymentDelegate()
            UIApplication.shared.windows.first?.rootViewController?.present(paymentController!, animated: true, completion: nil)
        } else {
            print("Apple Pay desteklenmiyor.")
        }
    }
    
    var body: some View {
        VStack {
            Text("Ödeme Ekranı")
                .font(.largeTitle)
                .padding()
            
            if cart.isEmpty {
                Text("Sepetiniz boş.")
                    .padding()
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
                            Text("$\(Double(item.count) * 3.0)") // Her kahve için 3 dolar örneği
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Text("Toplam: $\(totalAmount, specifier: "%.2f")")
                        .font(.title2)
                        .padding(.top, 20)
                    
                    // Apple Pay Butonu
                    Button(action: {
                        self.startApplePayPayment() // Apple Pay işlemine başla
                    }) {
                        Text("Apple Pay ile Ödeme Yap")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .navigationBarTitle("Ödeme Ekranı", displayMode: .inline)
    }
}
