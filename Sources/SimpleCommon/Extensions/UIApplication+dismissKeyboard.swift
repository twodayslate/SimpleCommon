import UIKit

public extension UIApplication {
    /// - returns: `true` if a responder object handled the `UIResponder.resignFirstResponder` action message, `false` if no object in the responder chain handled the message.
    func dismissKeyboard() -> Bool {
        return sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        // we could also do the following
//        connectedScenes
//                .filter {$0.activationState == .foregroundActive}
//                .map {$0 as? UIWindowScene}
//                .compactMap({$0})
//                .first?.windows
//                .filter {$0.isKeyWindow}
//                .first?.endEditing(true)
    }
}
