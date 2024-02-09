import Foundation

public enum Search {
    
    public struct Response: Decodable {
        public let photos: Photos
    }
    
    public struct Photos: Decodable {
        public let page: Int
        public let pages: Int
        public let perPage: Int
        public let total: Int
        public let photos: [Photo]
        
        enum CodingKeys: String, CodingKey {
            case page
            case pages
            case perPage = "perpage"
            case total
            case photos = "photo"
        }
    }
    
    public struct Photo: Decodable, Identifiable {
        public let id: String
        public let owner: String
        public let secret: String
        public let server: String
        public let farm: Int
        public let title: String
        
        public var url: URL {
            URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")!
        }
    }
    
    public struct Query: QueryItemConvertible {
        public let text: String?
        
        public init(text: String?) {
            self.text = text
        }
        
        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "method", value: "flickr.photos.search"),
                URLQueryItem(name: "text", value: text)
            ]
        }
    }
}
