import Foundation

public struct User: Identifiable, Decodable, Hashable {
    
    public let id: String
    public let username: String
    public let realName: String
    public let location: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "nsid"
        case username
        case realName = "realname"
        case location
    }
}

public extension User {
    static var preview: User {
        .init(id: "1", username: "johnny526", realName: "John Appleseed", location: "Cupertino, CA")
    }
}
