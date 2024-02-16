import MapKit
import Model
import SwiftUI
import BrowsePhotos

public struct Root: View {
    
    let locationRepository: LocationRepository
    
    @State private var path: NavigationPath = .init()
    
    public init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }

    public var body: some View {
        NavigationStack {
            LocationMapScreen(viewModel: .init(locationRepository: locationRepository))
                .navigationDestination(for: Model.Photo.self) { photo in
                    PhotoDetailScreen(photo: photo)
                        .navigationBarTitleDisplayMode(.inline)
                }
        }
    }
}

#Preview {
    Root(locationRepository: StubLocationRepository(photos: .preview))
}
