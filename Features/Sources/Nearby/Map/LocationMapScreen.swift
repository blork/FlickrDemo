import Design
import MapKit
import Model
import SwiftUI

struct LocationMapScreen: View {

    let viewModel: LocationMapViewModel
    
    init(viewModel: LocationMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            Map(initialPosition: .userLocation(fallback: .automatic)) {
                ForEach(viewModel.photos.value ?? []) { photo in
                    if let lat = photo.latitude, let lon = photo.longitude {
                        Annotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)) {
                            NavigationLink(value: photo) {
                                PhotoView(photo: photo)
                            }
                        } label: {
                            Text(photo.title)
                        }
                    }
                }
            }
            .photoViewStyle(.compact)
            .mapControlVisibility(.visible)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                viewModel.region = context.region
            }
            .oneTimeTask {
                await viewModel.load()
            }
            .loading(resource: viewModel.photos)
            
            VStack {
                Spacer()
                Button("Search here") {
                    Task {
                        await viewModel.load()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.photos.isLoading)
                .padding()
            }
            
        }
    }
}

#Preview {
    LocationMapScreen(viewModel: .init(locationRepository: StubLocationRepository(photos: .preview)))
}
