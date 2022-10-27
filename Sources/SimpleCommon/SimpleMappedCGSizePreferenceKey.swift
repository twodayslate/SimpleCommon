import SwiftUI

import Foundation

public struct SimpleMappedCGSizePreferenceKey: PreferenceKey {
    public typealias Value = [String: CGSize]

    public static var defaultValue: [String: CGSize] = [:]

    public static func reduce(value: inout [String: CGSize], nextValue: () -> [String: CGSize]) {
        value.merge(nextValue()) { $1 }
    }
}
