import Foundation
import Model
import Base

@Observable public class PhotoListViewModel {
    
    private var photoRepository: PhotoRepository
    
    var photos: Resource<[Photo]> = .loading
    
    public init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func load(refreshing: Bool = false) async {
        if !refreshing && !photos.isLoaded {
            photos = .loading
        }
        do {
            photos = try await .loaded(photoRepository.recent())
        } catch {
            photos = .error(error)
        }
    }
}

extension PhotoListViewModel {
    class Preview: PhotoListViewModel {
        init(_ state: Resource<[Photo]>) {
            super.init(photoRepository: StubPhotoRepository())
            photos = state
        }

        override func load(refreshing: Bool = false) async {}
    }
}
