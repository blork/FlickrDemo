import Network
import SwiftUI

public struct PhotoDetailView: View {
    
    public let viewModel: PhotoDetailModel
        
    public init(viewModel: PhotoDetailModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        let photo = viewModel.photo.value
        ZStack {
            AsyncImage(url: viewModel.photo.value?.url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            VStack(spacing: 0) {
                Spacer()
                Divider()
                VStack(alignment: .leading) {
                    Text(photo?.title ?? .lipsum)
                        .font(.headline)
                    Text(photo?.description ?? .lipsum)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thickMaterial)
            }
        }
        .loading(resource: viewModel.photo)
        .task {
            await viewModel.load()
        }
        .navigationTitle("Details")
    }
}

#Preview {
    PhotoDetailView(viewModel: .init(client: StubClient(detail: .preview), photo: .preview))
}
