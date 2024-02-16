import API
import Nearby
import SwiftUI

@main
struct NearbyMiniApp: App {
    
    let client: Client
    
    let locationRepository: LocationRepository
        
    init() {
        client = FlickrClient(session: URLSession.shared, apiKey: "a8b93698853b49ef5c08d9ca6c6122ba")
        locationRepository = RemoteLocationRepository(client: client)
    }

    var body: some Scene {
        WindowGroup {
            Nearby.Root(locationRepository: locationRepository)
        }
    }
}
