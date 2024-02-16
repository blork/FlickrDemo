@testable import API
import XCTest

final class SearchTests: XCTestCase {
    
    func test_searchRequest_whenCreated_hasCorrectQueryItems() async throws {
        let client = FlickrClient(session: StubSession(), apiKey: "TEST_KEY")
        let request = try client.request(.GET, Search.Query(text: "Hello"))

        let url = request.url!.absoluteString
        
        XCTAssertEqual(url, "https://api.flickr.com/services/rest?api_key=TEST_KEY&format=json&nojsoncallback=1&method=flickr.photos.search&text=Hello")
    }
    
    func test_searchIsPerformed_successful_photosAreReturned() async throws {
        let session = StubSession()
        
        session.response = ("""
        {
          "photos": {
            "page": 1,
            "pages": 1,
            "perpage": 100,
            "total": 2,
            "photo": [
              {
                "id": "53517142775",
                "owner": "199603930@N03",
                "secret": "00eaa0df09",
                "server": "65535",
                "farm": 66,
                "title": "Test 1",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "53516856865",
                "owner": "133693832@N07",
                "secret": "5caf6de6b4",
                "server": "65535",
                "farm": 66,
                "title": "Test 2",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              }
            ]
          },
          "stat": "ok"
        }
        """.data(using: .utf8)!, 200)
        
        let client = FlickrClient(session: session, apiKey: "TEST_KEY")
        
        let photos = try await client.search(.init(text: "Hello"))

        XCTAssertEqual(photos.count, 2)
        XCTAssertEqual(photos[0].title, "Test 1")
        XCTAssertEqual(photos[1].title, "Test 2")
    }
}
