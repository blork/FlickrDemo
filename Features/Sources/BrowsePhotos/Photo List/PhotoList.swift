import Design
import Network
import SwiftUI

public struct PhotoList: View {
    
    public let viewModel: PhotoListModel
    
    public init(viewModel: PhotoListModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.photos.value ?? .preview) { photo in
                NavigationLink(photo.title, value: photo)
            }
        }
        .animation(.bouncy, value: viewModel.photos.value)
        .listStyle(.plain)
        .loading(resource: viewModel.photos)
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load(refreshing: true)
        }
        .navigationTitle("Recent Photos")
    }
}

#Preview {
    PhotoList(viewModel: .init(client: StubClient(photos: .preview)))
}
