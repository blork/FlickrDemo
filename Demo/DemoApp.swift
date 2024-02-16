import API
import Base
import BrowsePhotos
import Model
import SwiftUI

@main
struct DemoApp: App {
    
    let client: Client
    
    var photoRepository: PhotoRepository
    
    @State var path: NavigationPath = .init()
    
    init() {
        client = FlickrClient(session: URLSession.shared, apiKey: Configuration.flickrKey)
        photoRepository = RemotePhotoRepository(client: client)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                PhotoList(viewModel: .init(photoRepository: photoRepository))
                    .navigationDestination(for: Model.Photo.self) { photo in
                        PhotoDetailView(photo: photo)
                            .navigationBarTitleDisplayMode(.inline)
                    }
            }
        }
    }
}
