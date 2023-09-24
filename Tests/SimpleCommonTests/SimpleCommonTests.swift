import XCTest
@testable import SimpleCommon

final class SimpleCommonTests: XCTestCase {
    func testMainBundleHasBundleIdentifier() throws {
        XCTAssertNotNil(Bundle.main.bundleIdentifier)
    }
}
