#if canImport(UIKit)
import SwiftUI
import UIKit

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let uiColor = try UIColor(from: decoder)
        self = Color(uiColor)
    }

    public func encode(to encoder: Encoder) throws {
        try UIColor(self).encode(to: encoder)
    }
}
#elseif canImport(AppKit)
import SwiftUI
import AppKit

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let nsColor = try NSColor(from: decoder)
        self = Color(nsColor)
    }

    public func encode(to encoder: Encoder) throws {
        guard let nsColor = NSColor(self) else {
            throw EncodingError.invalidValue(
                self,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Unable to convert Color to NSColor"
                )
            )
        }
        try nsColor.encode(to: encoder)
    }
}
#endif
