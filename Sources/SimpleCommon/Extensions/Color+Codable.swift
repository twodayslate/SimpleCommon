#if canImport(UIKit) || canImport(AppKit)
import SwiftUI

private struct CodableRGBA: Codable {
    let r: Double
    let g: Double
    let b: Double
    let a: Double
}

private enum ColorCodingError: Error {
    case invalidColor
}

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let rgba = try CodableRGBA(from: decoder)
        self = Color(.sRGB, red: rgba.r, green: rgba.g, blue: rgba.b, opacity: rgba.a)
    }

    public func encode(to encoder: Encoder) throws {
        let rgba = try rgbaComponents()
        try rgba.encode(to: encoder)
    }
}

private extension Color {
    func rgbaComponents() throws -> CodableRGBA {
        #if canImport(UIKit)
        let color = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard color.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            throw ColorCodingError.invalidColor
        }
        return CodableRGBA(r: Double(r), g: Double(g), b: Double(b), a: Double(a))
        #elseif canImport(AppKit)
        guard let color = NSColor(self)?.usingColorSpace(.sRGB) else {
            throw ColorCodingError.invalidColor
        }
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return CodableRGBA(r: Double(r), g: Double(g), b: Double(b), a: Double(a))
        #else
        throw ColorCodingError.invalidColor
        #endif
    }
}
#endif
