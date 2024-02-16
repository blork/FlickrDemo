import Base
@testable import BrowsePhotos
import XCTest

final class PhotoListViewModelTests: XCTestCase {

    func test_photoInitialValueIsLoading() async throws {
        let repo = StubPhotoRepository()
        let vm = PhotoListViewModel(photoRepository: repo)
                
        XCTAssertTrue(vm.photos.isLoading)
    }

    func test_repoThrowsError_load_photosContainsError() async throws {
        let repo = StubPhotoRepository(error: PreviewError.whoops)
        let vm = PhotoListViewModel(photoRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.photos.isError)
    }
    
    func test_noPhotosReturned_load_photosIsLoadedAndEmpty() async throws {
        let repo = StubPhotoRepository(photos: [])
        let vm = PhotoListViewModel(photoRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.photos.isLoaded)
        XCTAssertTrue(vm.photos.value!.isEmpty)
    }
    
    func test_photosReturned_load_photosIsLoadedAndContainsCorrectPhotos() async throws {
        let repo = StubPhotoRepository(photos: [
            .init(id: "1", title: "1", description: "1", takenOn: .now, imageURL: URL(string: "example.com")!, owner: .preview),
            .init(id: "2", title: "2", description: "2", takenOn: .now, imageURL: URL(string: "example.com")!, owner: .preview),
        ])
        let vm = PhotoListViewModel(photoRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.photos.isLoaded)
        let photos = vm.photos.value!
        XCTAssertEqual(photos.count, 2)
        
        XCTAssertTrue(photos.contains { $0.id == "1" })
        XCTAssertTrue(photos.contains { $0.id == "2" })
    }
}
