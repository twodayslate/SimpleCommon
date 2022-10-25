import Foundation

public enum EZPanelStyle: Int, Codable, CaseIterable, Identifiable {
    /// A simple trailing close button
    case close
    /// A trailing save button
    case save
    /// A trailing cancel button
    case cancel
    /// A leadinc cancel and trailing save button
    case saveAndCancel

    public var id: Int {
        self.rawValue
    }
}
