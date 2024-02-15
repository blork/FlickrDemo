import Foundation
import Network
import Base

@Observable public class PhotoListModel {
    
    var client: Client
    
    var photos: Resource<[Photo.List.Item]> = .loading
    
    public init(client: Client) {
        self.client = client
    }
    
    func load(refreshing: Bool = false) async {
        if !refreshing && !photos.isLoaded {
            photos = .loading
        }
        do {
            photos = try await .loaded(client.recent())
        } catch {
            photos = .error(error)
        }
    }
}
