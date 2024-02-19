@testable import Design
import Model
import SnapshotTesting
import XCTest

final class DesignTests: XCTestCase {
    
    func testSnapshotPhotoViewCompact() throws {
        let view = PhotoView(photo: .preview).photoViewStyle(.compact).fixedSize(horizontal: true, vertical: true)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .sizeThatFits))
    }
    
    func testSnapshotPhotoViewRegular() throws {
        let view = PhotoView(photo: .preview).photoViewStyle(.regular).fixedSize(horizontal: true, vertical: true)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .sizeThatFits))

    }

    func testSnapshotPhotoViewFull() throws {
        let view = PhotoView(photo: .preview).photoViewStyle(.full).fixedSize(horizontal: true, vertical: true)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .sizeThatFits))
    }
}
