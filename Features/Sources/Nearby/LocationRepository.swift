import API
import Foundation
import MapKit
import Model

public protocol LocationRepository {
    func nearby(_ region: MKCoordinateRegion) async throws -> [Model.Photo]
}

public class RemoteLocationRepository: LocationRepository {
    
    let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func nearby(_ region: MKCoordinateRegion) async throws -> [Model.Photo] {
        let results = try await client.search(.init(boundingBox: convertToBoundingBox(region: region))).filter { item in
            item.latitude != nil && item.longitude != nil
        }
        
        return try await withThrowingTaskGroup(of: (API.Photo.Detail?, API.Photo.List.Item).self, returning: [Model.Photo].self) { taskGroup in
            for result in results {
                taskGroup.addTask { (try? await self.client.info(for: result.id), result) }
            }

            return try await taskGroup.reduce(into: [Model.Photo]()) { partialResult, result in
                let (info, original) = result
                if let info,
                   let stringLat = original.latitude,
                   let stringLon = original.longitude,
                   let latitude = Double(stringLat),
                   let longitude = Double(stringLon)
                {
                    partialResult.append(.init(info, latitude: latitude, longitude: longitude))
                }
            }
        }
    }
    
    func convertToBoundingBox(region: MKCoordinateRegion, padding: Double = 0.09) -> API.Search.Query.BoundingBox {
        let center = region.center
        let span = region.span
        
        let halfLat = span.latitudeDelta / 2
        let halfLon = span.longitudeDelta / 2
        
        let minLat = center.latitude - halfLat + padding
        let maxLat = center.latitude + halfLat - padding
        let minLon = center.longitude - halfLon + padding
        let maxLon = center.longitude + halfLon - padding

        return .init(minimumLongitude: minLon, minimumLatitude: minLat, maximumLongitude: maxLon, maximumLatitude: maxLat)
    }
}

public class StubLocationRepository: LocationRepository {

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
    
    public func nearby(_: MKCoordinateRegion) async throws -> [Model.Photo] {
        if let error { throw error }
        if let photos { return photos }
        throw StubLocationRepository.notSetUp
    }
    
    public enum StubLocationRepository: Error {
        case notSetUp
    }
}
