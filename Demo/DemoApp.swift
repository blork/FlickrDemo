import Base
import Network
import BrowsePhotos
import SwiftUI

@main
struct DemoApp: App {
    
    var client = FlickrClient(session: URLSession.shared, apiKey: Configuration.flickrKey)
    
    @State var path: NavigationPath = .init()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                PhotoList(viewModel: .init(client: client))
                    .navigationDestination(for: Photo.List.Item.self) { photo in
                        PhotoDetailView(viewModel: .init(client: client, id: photo.id))
                            .navigationBarTitleDisplayMode(.inline)
                    }
            }
        }
    }
}
