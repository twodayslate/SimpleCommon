import SwiftUI

public struct SimpleMappedCGFloatPreferenceKey: PreferenceKey {
    public typealias Value = [String: CGFloat]

    public static var defaultValue: [String: CGFloat] = [:]

    public static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}
