import UIKit

public extension UIViewController {
    /// Notifies this object that it has been asked to relinquish its status as first responder in its window and causes the view (or one of its embedded text fields) to resign the first responder status.
    ///
    /// - returns: `true` if the view resigned the first responder status or `false` if it did not.
    @objc func dismissKeyboard() -> Bool {
        guard resignFirstResponder() else {
            return false
        }
        return view.endEditing(false)
    }
}
