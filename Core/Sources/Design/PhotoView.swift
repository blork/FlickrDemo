import Model
import SwiftUI

/// A PhotoView shows information about a `Model.Photo`, including its title, description, and image, depending on the style.
///
/// You create a product view by providing a Photo value you previously loaded.
/// You can customize the photo view’s appearance using the standard styles, including `regular`, `compact`, and `full`. Apply the style using the `photoViewStyle(_:)` view modifier.
public struct PhotoView: View {
    
    let photo: Photo
    
    @ScaledMetric(relativeTo: .title) private var imageSizeLarge = 88
    @ScaledMetric(relativeTo: .title) private var imageSizeSmall = 64

    @Environment(\.photoViewStyle) var photoViewStyle

    public init(photo: Photo) {
        self.photo = photo
    }
    
    public var body: some View {
        switch photoViewStyle {
        case .regular:
            HStack(alignment: .center) {
                AsyncImage(url: photo.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: imageSizeLarge, height: imageSizeSmall)
                .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
                
                VStack(alignment: .leading) {
                    Text(photo.title.isEmpty ? "Untitled" : photo.title)
                        .font(.headline)
                    Text(photo.owner.username)
                        .font(.caption)
                }
                .lineLimit(2)
            }
        case .compact:
            AsyncImage(url: photo.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: imageSizeSmall, height: imageSizeSmall)
            .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadius(.regular))
                    .stroke(Color.white, lineWidth: 4)
            )
            .shadow(radius: 2)
        case .full:
            Section {
                AsyncImage(
                    url: photo.imageURL
                ) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
                    default:
                        Color.gray
                            .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
                    }
                }
            }
            .listRowSeparator(.hidden)

            Section("Title") {
                Text(photo.title)
            }
            
            if !photo.description.isEmpty {
                Section("Description") {
                    Text(photo.description)
                }
            }
            
            Section("Details") {
                LabeledContent("User", value: photo.owner.username)
                LabeledContent("Taken on", value: photo.takenOn.formatted(.dateTime.day().month().year()))
            }
        }
    }
}

#Preview("Regular") {
    PhotoView(photo: .preview)
}

#Preview("Compact") {
    PhotoView(photo: .preview)
        .photoViewStyle(.compact)
}

#Preview("Full") {
    PhotoView(photo: .preview)
        .photoViewStyle(.full)
}

public enum PhotoViewStyle {
    case regular
    case compact
    case full
}

struct PhotoViewStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: PhotoViewStyle = .regular
}

extension EnvironmentValues {
    var photoViewStyle: PhotoViewStyle {
        get { self[PhotoViewStyleEnvironmentKey.self] }
        set { self[PhotoViewStyleEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func photoViewStyle(_ style: PhotoViewStyle) -> some View {
        environment(\.photoViewStyle, style)
    }
}
