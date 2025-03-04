import PassKit

class PaymentDelegate: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    // Ödeme işlemi tamamlandığında yapılacak işlemler
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            print("Ödeme tamamlandı.")
        }
    }
    
    // Ödeme başarılı olduğunda yapılacak işlemler
  private func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment) {
        print("Ödeme başarılı.")
    }
    
    // Kullanıcı ödeme yöntemini seçtiğinde yapılacak işlemler
  private func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectPaymentMethod paymentMethod: PKPaymentMethod) {
        print("Ödeme yöntemi seçildi: \(paymentMethod.displayName ?? "bilinmiyor")")
    }
    
    // Ödeme sırasında hata meydana geldiğinde yapılacak işlemler
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didFailWithError error: Error) {
        print("Ödeme hatası: \(error.localizedDescription)")
    }
}
