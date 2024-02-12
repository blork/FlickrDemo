import Network
import PhotoList
import SwiftUI

@main
struct DemoApp: App {
    
    var client = FlickrClient(session: URLSession.shared, apiKey: Configuration.flickrKey)
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PhotoList(viewModel: .init(client: client))
            }
        }
    }
}
