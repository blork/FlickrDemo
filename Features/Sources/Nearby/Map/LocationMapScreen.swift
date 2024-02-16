import Design
import MapKit
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
                                AsyncImage(url: photo.imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 64, height: 64)
                                .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: .cornerRadius(.regular))
                                        .stroke(Color.white, lineWidth: 4)
                                )
                            }
                        } label: {
                            Text(photo.title)
                        }
                    }
                }
            }
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
            }
        }
    }
}

#Preview {
    LocationMapScreen(viewModel: .init(locationRepository: StubLocationRepository(photos: .preview)))
}
