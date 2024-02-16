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
    let locationRepository: LocationRepository

    init() {
        client = FlickrClient(session: URLSession.shared, apiKey: Configuration.flickrKey)
        photoRepository = RemotePhotoRepository(client: client)
        locationRepository = RemoteLocationRepository(client: client)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BrowsePhotos.Root(photoRepository: photoRepository)
                    .tabItem {
                        Label("Browse", systemImage: "photo.on.rectangle.angled")
                    }
                
                Nearby.Root(locationRepository: locationRepository)
                    .tabItem {
                        Label("Nearby", systemImage: "map")
                    }
            }
        }
    }
}
