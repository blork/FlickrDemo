import Base
import Design
import Model
import SwiftUI

public struct PhotoListScreen: View {

    public let viewModel: PhotoListViewModel
    
    @State private var isSearching = false

    public init(viewModel: PhotoListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            if viewModel.photos.value?.isEmpty == true && isSearching {
                ContentUnavailableView.search
            } else {
                List {
                    ForEach(viewModel.photos.value ?? placeholders) { photo in
                        NavigationLink(value: photo) {
                            PhotoView(photo: photo)
                        }
                    }
                }
                .listStyle(.plain)
                .loading(resource: viewModel.photos)
            }
        }
        .oneTimeTask {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load(refreshing: true)
        }
        .onChange(of: isSearching) {
            if !isSearching {
                Task {
                    await viewModel.load()
                }
            }
        }
        
        .searchable(text: $viewModel.search, isPresented: $isSearching)
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
