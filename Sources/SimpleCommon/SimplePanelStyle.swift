import Foundation

/// A type that applies standard interaction behavior and a custom appearance to a ``SimplePanel``
public enum SimplePanelStyle: Int, Codable, CaseIterable, Identifiable {
    /// A simple trailing close button
    case close
    /// A trailing save button
    case save
    /// A trailing cancel button
    case cancel
    /// A leading cancel and trailing save button
    case saveAndCancel
    /// A trailing done button
    case done

    public var id: Int {
        self.rawValue
    }
}
