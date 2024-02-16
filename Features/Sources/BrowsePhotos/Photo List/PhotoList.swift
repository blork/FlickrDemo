import Base
import Design
import Model
import SwiftUI

public struct PhotoList: View {
    
    public let viewModel: PhotoListModel
    
    public init(viewModel: PhotoListModel) {
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
    PhotoList(viewModel: .Preview(.loaded(.preview)))
}

#Preview("Loading") {
    PhotoList(viewModel: .Preview(.loading))
}

#Preview("Error") {
    PhotoList(viewModel: .Preview(.error(PreviewError.whoops)))
}
