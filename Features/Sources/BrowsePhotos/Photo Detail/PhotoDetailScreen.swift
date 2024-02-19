import API
import Model
import SwiftUI
import Design

public struct PhotoDetailScreen: View {
    
    public let photo: Model.Photo
        
    public init(photo: Model.Photo) {
        self.photo = photo
    }
    
    public var body: some View {
        List {
            PhotoView(photo: photo)
        }
        .photoViewStyle(.full)
        .listStyle(.plain)
        .navigationTitle(photo.title)
    }
}

#Preview {
    PhotoDetailScreen(photo: .preview)
}
