import SwiftUI
import PassKit

struct CheckoutView: View {
    var coffee: Coffee?
    
    var body: some View {
        VStack(spacing: 20) {
            if let coffee = coffee {
                Text("Seçtiğiniz Kahve: \(coffee.name)")
                    .font(.title)
                Text("Fiyat: \(coffee.price, specifier: "%.2f") TL")
                    .font(.title2)
                    .padding()
            } else {
                Text("Kahve seçilmedi!")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                // Ödeme işlemini başlat
                startApplePayPayment(coffee: coffee)
            }) {
                Text("Ödemeyi Tamamla")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Ödeme")
    }
    
    func startApplePayPayment(coffee: Coffee?) {
        guard let coffee = coffee else {
            print("Kahve seçilmedi!")
            return
        }
        
        // Apple Pay ödeme işlemi için gerekli parametreler
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "YOUR_MERCHANT_ID"
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]  // Desteklenen ödeme ağlarını seç
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "TR"
        paymentRequest.currencyCode = "TRY"
        
        // Ödeme tutarını belirleyelim
        let paymentSummaryItem = PKPaymentSummaryItem(label: coffee.name, amount: NSDecimalNumber(value: coffee.price))
        paymentRequest.paymentSummaryItems = [paymentSummaryItem]
        
        // Apple Pay ödeme ekranını başlat
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentRequest.supportedNetworks) {
            let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentController?.delegate = PaymentDelegate()
            if let controller = paymentController {
                // Bu kısımda ödeme ekranını gösteriyoruz
                UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        } else {
            print("Apple Pay kullanılamaz.")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(coffee: Coffee(name: "Espresso", price: 20.0))
    }
}
