import API
import Foundation
import Model

public protocol PhotoRepository {
    func recent() async throws -> [Model.Photo]
    func search(_ query: String) async throws -> [Model.Photo]
}

public class RemotePhotoRepository: PhotoRepository {
    
    let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func recent() async throws -> [Model.Photo] {
        let results = try await client.recent()
        return try await fetchDetails(results)
    }
    
    public func search(_ query: String) async throws -> [Model.Photo] {
        let results = try await client.search(.init(text: query))
        return try await fetchDetails(results)
    }
    
    
    /// Requests the full details for a list of photo items.
    ///
    /// This method will perform an API request for each photo in the list of results.
    /// - Parameter results: A list of Photo items to expand
    /// - Returns: The expanded list of photo items mapped into Model.Photos.
    func fetchDetails(_ results: [API.Photo.List.Item]) async throws -> [Model.Photo] {
        return try await withThrowingTaskGroup(of: API.Photo.Detail?.self, returning: [Model.Photo].self) { taskGroup in
            for result in results {
                taskGroup.addTask { try? await self.client.info(for: result.id) }
            }

            return try await taskGroup.reduce(into: [Model.Photo]()) { partialResult, detail in
                if let detail {
                    partialResult.append(.init(detail))
                }
            }
        }
    }
}

public class StubPhotoRepository: PhotoRepository {

    var error: Error?
    
    var photos: [Model.Photo]?
        
    public init(error: Error? = nil, photos: [Model.Photo]? = nil) {
        #if DEBUG
            self.error = error
            self.photos = photos
        #else
            fatalError("StubPhotoRepository should not be used in RELEASE mode!")
        #endif
    }
    
    public func recent() async throws -> [Model.Photo] {
        if let error { throw error }
        if let photos { return photos }
        throw StubPhotoRepositoryError.notSetUp
    }
    
    public func search(_ query: String) async throws -> [Model.Photo] {
        if let error { throw error }
        if let photos { return photos }
        throw StubPhotoRepositoryError.notSetUp
    }
    
    public enum StubPhotoRepositoryError: Error {
        case notSetUp
    }
}
