import Base
@testable import BrowsePhotos
import Model
import SnapshotTesting
import XCTest

final class DesignTests: XCTestCase {
    
    func testSnapshotPhotoListScreen() throws {
        assertSnapshot(of: PhotoListScreen(viewModel: .Preview(.loading)), as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
        assertSnapshot(of: PhotoListScreen(viewModel: .Preview(.loaded(.preview))), as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
        assertSnapshot(of: PhotoListScreen(viewModel: .Preview(.error(PreviewError.whoops))), as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
    }
    
    func testSnapshotPhotoDetailsScreen() throws {
        assertSnapshot(of: PhotoDetailScreen(photo: .preview), as: .image(precision: 0.99, layout: .device(config: .iPhone13)))
    }
}
