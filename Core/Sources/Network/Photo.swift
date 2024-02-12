import Foundation

public enum Photo: QueryItemConvertible {
    case query(id: Photo.Detail.ID)
    case recent

    var queryItems: [URLQueryItem] {
        switch self {
        case let .query(id):
            [
                URLQueryItem(name: "method", value: "flickr.photos.getInfo"),
                URLQueryItem(name: "photo_id", value: id),
            ]
        case .recent:
            [
                URLQueryItem(name: "method", value: "flickr.photos.getRecent"),
            ]
        }
    }
    
    public enum List {
        public struct Response: Decodable {
            public let results: Results
            
            enum CodingKeys: String, CodingKey {
                case results = "photos"
            }
        }
        
        public struct Results: Decodable {
            public let page: Int
            public let pages: Int
            public let perPage: Int
            public let total: Int
            public let items: [Item]
            
            enum CodingKeys: String, CodingKey {
                case page
                case pages
                case perPage = "perpage"
                case total
                case items = "photo"
            }
        }
        
        public struct Item: Decodable, Identifiable, PhotoRepresentable {
            public let id: Photo.Detail.ID
            public let owner: String
            public let secret: String
            public let server: String
            public let farm: Int
            public let title: String
        }
    }
    
    public struct Detail: Identifiable, Decodable, PhotoRepresentable {
        public let id: String
        public let secret: String
        public let server: String
        public let farm: Int
        
        @Wrapped public var title: String
        @Wrapped public var description: String
        
        public let dates: Dates
    }

    public struct Response: Decodable {
        public let photo: Photo.Detail
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

public extension [Photo.List.Item] {
    static var preview: [Photo.List.Item] {
        [
            .init(id: "X", owner: "John Appleseed", secret: "X", server: "X", farm: 1, title: "An Example Image"),
            .init(id: "Y", owner: "Brenda Fuller", secret: "Y", server: "Y", farm: 1, title: "Another Example Image"),
            .init(id: "Z", owner: "Otto Mcdaniel", secret: "Z", server: "Z", farm: 1, title: "One More Example Image")
        ]
    }
}
