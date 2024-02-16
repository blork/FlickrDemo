import API
import Base
import BrowsePhotos
import Model
import SwiftUI
import Nearby

@main
struct DemoApp: App {
    
    let client: Client
    
    let photoRepository: PhotoRepository
        
    init() {
        client = FlickrClient(session: URLSession.shared, apiKey: Configuration.flickrKey)
        photoRepository = RemotePhotoRepository(client: client)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BrowsePhotos.Root(photoRepository: photoRepository)
                    .tabItem {
                        Label("Browse", systemImage: "photo.on.rectangle.angled")
                    }
                
                Nearby.Root()
                    .tabItem {
                        Label("Nearby", systemImage: "map")
                    }
            }
        }
    }
}
