import API
import Model
import SwiftUI

public struct PhotoDetailScreen: View {
    
    public let photo: Model.Photo
        
    public init(photo: Model.Photo) {
        self.photo = photo
    }
    
    public var body: some View {
        List {
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
        .listStyle(.plain)
        .navigationTitle(photo.title)
    }
}

#Preview {
    PhotoDetailScreen(photo: .preview)
}
