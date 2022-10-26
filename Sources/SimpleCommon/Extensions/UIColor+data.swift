import UIKit

public extension UIColor {
    var data: Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }

    func from(data: Data) -> UIColor? {
        guard let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: Self.self, from: data) else {
            return nil
        }
        return color
    }
}
