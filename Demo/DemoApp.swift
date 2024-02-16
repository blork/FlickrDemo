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
                PhotoListScreen(viewModel: .init(photoRepository: photoRepository))
                    .navigationDestination(for: Model.Photo.self) { photo in
                        PhotoDetailScreen(photo: photo)
                            .navigationBarTitleDisplayMode(.inline)
                    }
            }
        }
    }
}
