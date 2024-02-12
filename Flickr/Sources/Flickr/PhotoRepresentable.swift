import Foundation

public protocol PhotoRepresentable {
    var id: String { get }
    var server: String { get }
    var secret: String { get }
}

public extension PhotoRepresentable {
    var url: URL {
        URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret)_c.jpg")!
    }
}
