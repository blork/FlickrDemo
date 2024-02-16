import Base
import Foundation
import API

public struct Photo: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let takenOn: Date
    public let imageURL: URL

    public let owner: User
    
    public init(_ photo: API.Photo.Detail) {
        id = photo.id
        title = photo.title
        description = photo.description
        takenOn = photo.dates.taken
        imageURL = photo.url
        owner = .init(photo.owner)
    }
    
    public init(id: String, title: String, description: String, takenOn: Date, imageURL: URL, owner: User) {
        self.id = id
        self.title = title
        self.description = description
        self.takenOn = takenOn
        self.imageURL = imageURL
        self.owner = owner
    }
}

public extension Photo {
    static var preview: Photo {
        .init(
            id: .randomID,
            title: "An example title",
            description: "An example description",
            takenOn: .distantPast,
            imageURL: URL(string: "https://placehold.co/400")!,
            owner: .preview
        )
    }
}

public extension [Photo] {
    static var preview: [Photo] {
        (0..<20).map { _ in Photo.preview }
    }
}
