import Base
import Design
import Model
import SwiftUI

public struct PhotoListScreen: View {
    
    public let viewModel: PhotoListViewModel
    
    public init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.photos.value ?? placeholders) { photo in
                NavigationLink(value: photo) {
                    PhotoView(photo: photo)
                }
            }
        }
        .listStyle(.plain)
        .loading(resource: viewModel.photos)
        .oneTimeTask {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load(refreshing: true)
        }
        .navigationTitle("Recent Photos")
    }
    
    private var placeholders: [Photo] {
        Array(repeating: Photo.preview, count: 20)
    }
}

#Preview("Loaded") {
    PhotoListScreen(viewModel: .Preview(.loaded(.preview)))
}

#Preview("Loading") {
    PhotoListScreen(viewModel: .Preview(.loading))
}

#Preview("Error") {
    PhotoListScreen(viewModel: .Preview(.error(PreviewError.whoops)))
}
