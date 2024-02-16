import XCTest
@testable import BrowsePhotos
import SnapshotTesting

final class PhotoListTests: XCTestCase {
    func testSnapshotPhotoDetailScreen() throws {
        let view = PhotoDetailScreen(photo: .preview)
        assertSnapshot(of: view, as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
    }
}
