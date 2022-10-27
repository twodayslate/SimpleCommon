import UIKit

public extension UIViewController {
    /// Notifies this object that it has been asked to relinquish its status as first responder in its window and causes the view (or one of its embedded text fields) to resign the first responder status.
    ///
    /// - parameter force: Specify `true` to force the first responder to resign, regardless of whether it wants to do so.
    /// - returns: `true` if the view resigned the first responder status or `false` if it did not.
    @discardableResult
    @objc func dismissKeyboard(force: Bool = false) -> Bool {
        if !resignFirstResponder(), !force {
            return false
        }
        return view.endEditing(false)
    }
}
