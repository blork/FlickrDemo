import Model
import API
import SwiftUI

public struct PhotoDetailView: View {
    
    public let photo: Model.Photo
        
    public init(photo: Model.Photo) {
        self.photo = photo
    }
    
    public var body: some View {
        ZStack {
            AsyncImage(url: photo.imageURL) { image in
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
                    Text(photo.title)
                        .font(.headline)
                    Text(photo.description)
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thickMaterial)
            }
        }
        .navigationTitle(photo.title)
    }
}

#Preview {
    PhotoDetailView(photo: .preview)
}
