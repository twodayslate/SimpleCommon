import UIKit

var additionalUIColorNameMap: [UIColor: String] = [:]

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
