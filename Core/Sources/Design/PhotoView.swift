import Model
import SwiftUI

public struct PhotoView: View {
    
    let photo: Photo
    
    @ScaledMetric(relativeTo: .title) private var imageWidth = 88
    @ScaledMetric(relativeTo: .title) private var imageHeight = 64

    public init(photo: Photo) {
        self.photo = photo
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: photo.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: imageWidth, height: imageHeight)
            .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(photo.title.isEmpty ? "Untitled" : photo.title)
                    .font(.headline)
                Text(photo.owner.username)
                    .font(.caption)
            }
            .lineLimit(2)
        }
    }
}

#Preview {
    PhotoView(photo: .preview)
}
