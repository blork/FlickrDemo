import Base
import Foundation
import Model

@Observable public class PhotoListViewModel {
    
    private let photoRepository: PhotoRepository
    private var debouncer: Debounce<String>!
    
    var photos: Resource<[Photo]> = .loading
    
    var search = "" {
        didSet {
            if !search.isEmpty {
                photos = .loading
                debouncer.emit(value: search)
            }
        }
    }

    public init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
        
        defer {
            debouncer = Debounce<String>(duration: .seconds(2)) { [weak self] _ in
                guard let self else { return }
                await self.load()
            }
        }
    }
    
    func load(refreshing: Bool = false) async {
        if !refreshing {
            photos = .loading
        }
        do {
            if search.isEmpty {
                photos = try await .loaded(photoRepository.search("Nature"))
            } else {
                photos = try await .loaded(photoRepository.search(search))
            }
            
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

        override func load(refreshing _: Bool = false) async {}
    }
}
