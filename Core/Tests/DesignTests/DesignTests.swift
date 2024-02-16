@testable import Design
import SnapshotTesting
import XCTest

final class DesignTests: XCTestCase {
    
    func testSnapshotPhotoView() throws {
        let view = PhotoView(photo: .preview).fixedSize(horizontal: true, vertical: true)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .sizeThatFits))
    }
}
