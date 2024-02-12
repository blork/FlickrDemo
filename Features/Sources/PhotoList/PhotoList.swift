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
            ForEach(viewModel.photos.value ?? []) { photo in
                Text(photo.title)
            }
        }
        .loading(resource: viewModel.photos)
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    PhotoList(viewModel: .init(client: StubClient(photos: .preview)))
}
