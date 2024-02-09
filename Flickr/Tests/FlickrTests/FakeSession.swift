import Flickr
import Foundation

class FakeSession: Session {
    
    var response: (Data, Int)?
    var error: Error?
    
    init(response: (Data, Int)? = nil, error: Error? = nil) {
        self.response = response
        self.error = error
    }

    func data(for _: URLRequest) async throws -> (Data, URLResponse) {
        if let response {
            return (response.0, HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: response.1, httpVersion: nil, headerFields: nil)!)
        } else if let error {
            throw error
        }
        throw FakeSessionError.notSetUp
    }
    
    enum FakeSessionError: Error {
        case notSetUp
    }
}
