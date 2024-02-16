import Model
import SwiftUI

public struct Root: View {
    
    let photoRepository: PhotoRepository
    
    @State private var path: NavigationPath = .init()
    
    public init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }

    public var body: some View {
        NavigationStack(path: $path) {
            PhotoListScreen(viewModel: .init(photoRepository: photoRepository))
                .navigationDestination(for: Model.Photo.self) { photo in
                    PhotoDetailScreen(photo: photo)
                        .navigationBarTitleDisplayMode(.inline)
                }
        }
    }
}

#Preview {
    Root(photoRepository: StubPhotoRepository(photos: .preview))
}
