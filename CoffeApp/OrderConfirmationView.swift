import SwiftUI

struct OrderConfirmationView: View {
    var totalAmount: Double
    var orderNumber: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sipariş Başarıyla Alındı!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
            
            Text("Sipariş Numaranız: \(orderNumber)")
                .font(.title2)
                .padding(.top, 20)
            
            Text("Ödemeniz Alındı. Toplam: \(totalAmount, specifier: "%.2f") TL")
                .font(.title2)
                .padding(.top, 10)
            
            Button(action: {
                // Kullanıcıyı ana ekrana yönlendirebilirsin
                goBackToHome()
            }) {
                Text("Ana Ekrana Dön")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sipariş Onayı")
    }
    
    func goBackToHome() {
        // Kullanıcıyı ana ekrana yönlendirme işlemi
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            let homeView = ContentView() // Ana ekran
            let navController = UINavigationController(rootViewController: UIHostingController(rootView: homeView))
            topViewController.present(navController, animated: true, completion: nil)
        }
    }
}

struct OrderConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        OrderConfirmationView(totalAmount: 20.0, orderNumber: "12345")
    }
}
