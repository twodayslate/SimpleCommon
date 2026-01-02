#if canImport(UIKit) || canImport(AppKit)
import SwiftUI
import XCTest
@testable import SimpleCommon

final class ColorCodableTests: XCTestCase {
    func testColorCodableRoundTrip() throws {
        let original = Color(.sRGB, red: 0.25, green: 0.5, blue: 0.75, opacity: 0.6)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Color.self, from: data)

        #if canImport(UIKit)
        let originalColor = UIColor(original)
        let decodedColor = UIColor(decoded)
        #else
        guard let originalColor = NSColor(original),
              let decodedColor = NSColor(decoded) else {
            XCTFail("Unable to convert Color to NSColor")
            return
        }
        #endif

        assertColorsEqual(originalColor, decodedColor)
    }

    #if canImport(UIKit)
    private func assertColorsEqual(_ lhs: UIColor, _ rhs: UIColor, file: StaticString = #filePath, line: UInt = #line) {
        var lR: CGFloat = 0
        var lG: CGFloat = 0
        var lB: CGFloat = 0
        var lA: CGFloat = 0
        var rR: CGFloat = 0
        var rG: CGFloat = 0
        var rB: CGFloat = 0
        var rA: CGFloat = 0

        XCTAssertTrue(lhs.getRed(&lR, green: &lG, blue: &lB, alpha: &lA), "Unable to read lhs RGBA", file: file, line: line)
        XCTAssertTrue(rhs.getRed(&rR, green: &rG, blue: &rB, alpha: &rA), "Unable to read rhs RGBA", file: file, line: line)

        XCTAssertEqual(lR, rR, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(lG, rG, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(lB, rB, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(lA, rA, accuracy: 0.01, file: file, line: line)
    }
    #elseif canImport(AppKit)
    private func assertColorsEqual(_ lhs: NSColor, _ rhs: NSColor, file: StaticString = #filePath, line: UInt = #line) {
        guard let l = lhs.usingColorSpace(.sRGB),
              let r = rhs.usingColorSpace(.sRGB) else {
            XCTFail("Unable to convert NSColor to sRGB", file: file, line: line)
            return
        }

        var lR: CGFloat = 0
        var lG: CGFloat = 0
        var lB: CGFloat = 0
        var lA: CGFloat = 0
        var rR: CGFloat = 0
        var rG: CGFloat = 0
        var rB: CGFloat = 0
        var rA: CGFloat = 0

        l.getRed(&lR, green: &lG, blue: &lB, alpha: &lA)
        r.getRed(&rR, green: &rG, blue: &rB, alpha: &rA)

        XCTAssertEqual(lR, rR, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(lG, rG, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(lB, rB, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(lA, rA, accuracy: 0.01, file: file, line: line)
    }
    #endif
}
#endif
