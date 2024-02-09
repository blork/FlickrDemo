import Foundation

public struct Photo: Identifiable, Decodable {
    public let id: String
    public let secret: String
    public let server: String
    public let farm: Int
    
    @Wrapped public var title: String
    @Wrapped public var description: String

    public let dates: Dates

    public struct Response: Decodable {
        public let photo: Photo
    }
    
    public struct Query: QueryItemConvertible {
        public let id: Photo.ID
        
        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "method", value: "flickr.photos.getInfo"),
                URLQueryItem(name: "photo_id", value: id)
            ]
        }
    }
    
    public struct Dates: Decodable {
        public let posted: Date
        public let taken: Date
        public let lastUpdated: Date
        
        enum CodingKeys: String, CodingKey {
            case posted
            case taken
            case lastUpdated = "lastupdate"
        }
    }
}

@propertyWrapper
public struct Wrapped<T>: Decodable where T: Decodable {
    public var wrappedValue: T
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try! container.decode(WrappedValue<T>.self).value
    }
}


struct WrappedValue<T>: Decodable where T: Decodable {
    var value: T

    enum CodingKeys: String, CodingKey {
        case value = "_content"
    }
}
