import API
import Base
import Foundation

public struct Photo: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let takenOn: Date
    public let imageURL: URL

    public let owner: User
    public let latitude: Double?
    public let longitude: Double?

    public init(_ photo: API.Photo.Detail, latitude: Double? = nil, longitude: Double? = nil) {
        id = photo.id
        title = photo.title
        description = photo.description
        takenOn = photo.dates.taken
        imageURL = photo.url
        owner = .init(photo.owner)
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(id: String, title: String, description: String, takenOn: Date, imageURL: URL, owner: User, latitude: Double, longitude: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.takenOn = takenOn
        self.imageURL = imageURL
        self.owner = owner
        self.latitude = latitude
        self.longitude = longitude
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
            owner: .preview,
            latitude: 38.897675,
            longitude: -77.036530
        )
    }
}

public extension [Photo] {
    static var preview: [Photo] {
        (0 ..< 20).map { _ in Photo.preview }
    }
}
