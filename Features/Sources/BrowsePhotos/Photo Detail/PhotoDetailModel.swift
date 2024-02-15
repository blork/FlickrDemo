import Foundation
import Network
import Base

@Observable public class PhotoDetailModel {
    
    private var client: Client
    
    var photo: Resource<Photo.Detail> = .loading
    
    private var photoID: Photo.Detail.ID
    
    public init(client: Client, photo: Photo.Detail) {
        self.client = client
        self.photo = .loaded(photo)
        self.photoID = photo.id
    }
    
    public init(client: Client, id: Photo.Detail.ID) {
        self.client = client
        self.photoID = id
    }
    
    func load() async {
        if photo.isLoaded { return }
        
        do {
            photo = try await .loaded(client.info(for: photoID))
        } catch {
            photo = .error(error)
        }
    }
}
