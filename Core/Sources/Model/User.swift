import Base
import Foundation
import API

public struct User: Identifiable, Hashable {
    public let id: String
    public let username: String
    public let realName: String
    public let location: String
    
    public init(_ user: API.User) {
        id = user.id
        username = user.username
        realName = user.realName
        location = user.realName
    }
    
    public init(id: String, username: String, realName: String, location: String) {
        self.id = id
        self.username = username
        self.realName = realName
        self.location = location
    }
}

extension User {
    static var preview: User {
        .init(id: .randomID, username: "username", realName: "Real Name", location: "Location")
    }
}
