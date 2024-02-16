import XCTest
@testable import BrowsePhotos
import SnapshotTesting

final class PhotoListTests: XCTestCase {
    
    func testSnapshotPhotoView() throws {
        let view = PhotoView(photo: .preview).fixedSize(horizontal: true, vertical: true)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .sizeThatFits))
    }
    
    func testSnapshotPhotoDetailScreen() throws {
        let view = PhotoDetailScreen(photo: .preview)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
    }
}
