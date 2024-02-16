import Base
import Foundation
import MapKit
import Model
import SwiftUI

@Observable public class LocationMapViewModel {
    
    private var locationRepository: LocationRepository
    
    var photos: Resource<[Model.Photo]> = .loading
    
    private var task: Task<Void, Never>?
    
    var region: MKCoordinateRegion = .init()
    
    func load() async {
        photos = .loading
        do {
            photos = try .loaded(await locationRepository.nearby(region))
        } catch {
            photos = .error(error)
        }
    }
    
    public init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
}
