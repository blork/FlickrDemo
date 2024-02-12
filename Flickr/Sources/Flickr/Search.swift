import Foundation

public enum Search {
    
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
