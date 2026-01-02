#if canImport(UIKit)
import UIKit

private var additionalUIColorNameMap: [UIColor: String] = [:]

public extension UIColor {
    static var additionalNameMapping: [UIColor: String] {
        get {
            return additionalUIColorNameMap
        }
        set {
            additionalUIColorNameMap = newValue
        }
    }

    /// Human readable name
    ///
    /// To add additional names use ``additionalNameMapping``
    var name: String? {
        switch self {
        case .systemIndigo:
            return "Indigo"
        case .systemCyan:
            return "Cyan"
        case .systemBrown:
            return "Brown"
        case .systemMint:
            return "Mint"
        case .systemPurple:
            return "Purple"
        case .systemOrange:
            return "Orange"
        case .systemTeal:
            return "Teal"
        case .systemPink:
            return "Pink"
        case .systemBlue:
            return "Blue"
        case .systemRed:
            return "Red"
        case .systemGray:
            return "Gray"
        case .systemGreen:
            return "Green"
        case .systemYellow:
            return "Yellow"
        case .white:
            return "White"
        case .black:
            return "Black"
        case .label:
            return "Primary"
        case .secondaryLabel:
            return "Secondary"
        case .clear:
            return "Clear"
        default:
            return UIColor.additionalNameMapping[self] ?? nil
        }
    }
}
#elseif canImport(AppKit)
import AppKit

private var additionalNSColorNameMap: [NSColor: String] = [:]

public extension NSColor {
    static var additionalNameMapping: [NSColor: String] {
        get {
            return additionalNSColorNameMap
        }
        set {
            additionalNSColorNameMap = newValue
        }
    }

    /// Human readable name
    ///
    /// To add additional names use ``additionalNameMapping``
    var name: String? {
        switch self {
        case .systemIndigo:
            return "Indigo"
        case .systemCyan:
            return "Cyan"
        case .systemBrown:
            return "Brown"
        case .systemMint:
            return "Mint"
        case .systemPurple:
            return "Purple"
        case .systemOrange:
            return "Orange"
        case .systemTeal:
            return "Teal"
        case .systemPink:
            return "Pink"
        case .systemBlue:
            return "Blue"
        case .systemRed:
            return "Red"
        case .systemGray:
            return "Gray"
        case .systemGreen:
            return "Green"
        case .systemYellow:
            return "Yellow"
        case .white:
            return "White"
        case .black:
            return "Black"
        case .labelColor:
            return "Primary"
        case .secondaryLabelColor:
            return "Secondary"
        case .clear:
            return "Clear"
        default:
            return NSColor.additionalNameMapping[self] ?? nil
        }
    }
}
#endif
