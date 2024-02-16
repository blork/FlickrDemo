import Foundation

public struct FlickrError: Decodable, LocalizedError {
    public let code: Int
    public let message: String
    
    public var errorDescription: String? {
        message
    }
}
