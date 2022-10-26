import Foundation

public enum SimplePanelStyle: Int, Codable, CaseIterable, Identifiable {
    /// A simple trailing close button
    case close
    /// A trailing save button
    case save
    /// A trailing cancel button
    case cancel
    /// A leading cancel and trailing save button
    case saveAndCancel

    public var id: Int {
        self.rawValue
    }
}
