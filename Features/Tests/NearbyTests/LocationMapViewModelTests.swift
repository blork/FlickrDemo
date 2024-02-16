import Base
@testable import Nearby
import XCTest

final class LocationMapViewModelTests: XCTestCase {

    func test_photosInitialValueIsLoading() async throws {
        let repo = StubLocationRepository()
        let vm = LocationMapViewModel(locationRepository: repo)
                
        XCTAssertTrue(vm.photos.isLoading)
    }

    func test_repoThrowsError_load_photosContainsError() async throws {
        let repo = StubLocationRepository(error: PreviewError.whoops)
        let vm = LocationMapViewModel(locationRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.photos.isError)
    }
    
    func test_noPhotosReturned_load_photosIsLoadedAndEmpty() async throws {
        let repo = StubLocationRepository(photos: [])
        let vm = LocationMapViewModel(locationRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.photos.isLoaded)
        XCTAssertTrue(vm.photos.value!.isEmpty)
    }
    
    func test_photosReturned_load_photosIsLoadedAndContainsCorrectPhotos() async throws {
        let repo = StubLocationRepository(photos: [
            .init(id: "1", title: "1", description: "1", takenOn: .now, imageURL: URL(string: "example.com")!, owner: .preview, latitude: 0, longitude: 0),
            .init(id: "2", title: "2", description: "2", takenOn: .now, imageURL: URL(string: "example.com")!, owner: .preview, latitude: 0, longitude: 0),
        ])
        let vm = LocationMapViewModel(locationRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.photos.isLoaded)
        let photos = vm.photos.value!
        XCTAssertEqual(photos.count, 2)
        
        XCTAssertTrue(photos.contains { $0.id == "1" })
        XCTAssertTrue(photos.contains { $0.id == "2" })
    }
}
