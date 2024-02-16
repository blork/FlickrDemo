import API
import Base
import BrowsePhotos
import Model
import SwiftUI
import MapKit

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
                
                Map()
                    .tabItem {
                        Label("Nearby", systemImage: "map")
                    }
            }
        }
    }
}
