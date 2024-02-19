import Foundation

public enum Search {
    
    public struct Query: QueryItemConvertible {
        public let text: String?
        
        public let boundingBox: BoundingBox?
        
        public init(text: String? = nil, boundingBox: BoundingBox? = nil) {
            self.text = text
            self.boundingBox = boundingBox
        }
        
        var queryItems: [URLQueryItem] {
            var items = [
                URLQueryItem(name: "method", value: "flickr.photos.search"),
                URLQueryItem(name: "text", value: text),
                URLQueryItem(name: "safe_search", value: "1"),
                URLQueryItem(name: "per_page", value: "25"),
            ]
            
            if let boundingBox {
                items += [
                    URLQueryItem(name: "extras", value: "geo"),
                    URLQueryItem(name: "has_geo", value: "1"),
                    URLQueryItem(name: "accuracy", value: "11"),
                    URLQueryItem(name: "bbox", value: boundingBox.value),
                ]
            }
            return items
        }
        
        public struct BoundingBox {
            let minimumLongitude: Double
            let minimumLatitude: Double
            let maximumLongitude: Double
            let maximumLatitude: Double
            
            public init(minimumLongitude: Double, minimumLatitude: Double, maximumLongitude: Double, maximumLatitude: Double) {
                self.minimumLongitude = minimumLongitude
                self.minimumLatitude = minimumLatitude
                self.maximumLongitude = maximumLongitude
                self.maximumLatitude = maximumLatitude
            }
            
            var value: String {
                "\(minimumLongitude),\(minimumLatitude),\(maximumLongitude),\(maximumLatitude)"
            }
        }
    }
}
