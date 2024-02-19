@testable import API
import XCTest

final class SearchTests: XCTestCase {
    
    func test_anyRequestIsPerformed_invalidStatusCode_errorIsThrown() async throws {
        let session = StubSession()
        session.response = (Data(), 404)
        
        let client = FlickrClient(session: session, apiKey: "TEST_KEY")
        
        do {
            let _: String = try await client.perform(URLRequest(url: URL(string: "http://example.com")!))
        } catch ClientError.unexpected(let response) {
            XCTAssertEqual(response.statusCode, 404)
        } catch {
            XCTFail()
        }
    }
    
    func test_anyRequestIsPerformed_invalidResponseObject_errorIsThrown() async throws {
        let session = StubSession()
        session.response = (Data(), 200)
        
        let client = FlickrClient(session: session, apiKey: "TEST_KEY")
        
        do {
            let _: String = try await client.perform(URLRequest(url: URL(string: "http://example.com")!))
        } catch ClientError.unknown(let error) {
            XCTAssertTrue(error is DecodingError)
        } catch {
            XCTFail()
        }
    }

    
    func test_photoRecent_whenCreated_hasCorrectQueryItems() async throws {
        let client = FlickrClient(session: StubSession(), apiKey: "TEST_KEY")
        let request = try client.request(.GET, Photo.recent)

        let url = request.url!.absoluteString
        
        XCTAssertEqual(url, "https://api.flickr.com/services/rest?api_key=TEST_KEY&format=json&nojsoncallback=1&method=flickr.photos.getRecent&safe_search=1&per_page=50")
    }
    
    func test_photoInfo_whenCreated_hasCorrectQueryItems() async throws {
        let client = FlickrClient(session: StubSession(), apiKey: "TEST_KEY")
        let request = try client.request(.GET, Photo.info(id: "1"))

        let url = request.url!.absoluteString
        
        XCTAssertEqual(url, "https://api.flickr.com/services/rest?api_key=TEST_KEY&format=json&nojsoncallback=1&method=flickr.photos.getInfo&photo_id=1")
    }
    
    func test_searchRequest_withTextSearch_hasCorrectQueryItems() async throws {
        let client = FlickrClient(session: StubSession(), apiKey: "TEST_KEY")
        let request = try client.request(.GET, Search.Query(text: "Hello"))

        let url = request.url!.absoluteString
        
        XCTAssertEqual(url, "https://api.flickr.com/services/rest?api_key=TEST_KEY&format=json&nojsoncallback=1&method=flickr.photos.search&text=Hello&safe_search=1&per_page=25")
    }
    
    func test_searchRequest_withLocationSearch_hasCorrectQueryItems() async throws {
        let client = FlickrClient(session: StubSession(), apiKey: "TEST_KEY")
        let request = try client.request(.GET, Search.Query(boundingBox: .init(minimumLongitude: 1, minimumLatitude: 2, maximumLongitude: 2, maximumLatitude: 4)))

        let url = request.url!.absoluteString
        
        XCTAssertEqual(url, "https://api.flickr.com/services/rest?api_key=TEST_KEY&format=json&nojsoncallback=1&method=flickr.photos.search&text&safe_search=1&per_page=25&extras=geo&has_geo=1&accuracy=11&bbox=1.0,2.0,2.0,4.0")
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
    
    func test_recentIsPerformed_successful_photosAreReturned() async throws {
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
        
        let photos = try await client.recent()

        XCTAssertEqual(photos.count, 2)
        XCTAssertEqual(photos[0].title, "Test 1")
        XCTAssertEqual(photos[1].title, "Test 2")
    }

    func test_infoIsPerformed_successful_photosAreReturned() async throws {
        let session = StubSession()
        
        session.response = ("""
        {
          "photo": {
            "id": "53517142775",
            "secret": "00eaa0df09",
            "server": "65535",
            "farm": 66,
            "dateuploaded": "1707406357",
            "isfavorite": 0,
            "license": "0",
            "safety_level": "0",
            "rotation": 0,
            "originalsecret": "9d77622277",
            "originalformat": "png",
            "owner": {
              "nsid": "199603930@N03",
              "username": "Elsa_Markova",
              "realname": "Rocca Medievale Italia",
              "location": "",
              "iconserver": "65535",
              "iconfarm": 66,
              "path_alias": null,
              "gift": {
                "gift_eligible": true,
                "eligible_durations": [
                  "year",
                  "month",
                  "week"
                ],
                "new_flow": true
              }
            },
            "title": {
              "_content": "Example Title"
            },
            "description": {
              "_content": "Example Description"
            },
            "visibility": {
              "ispublic": 1,
              "isfriend": 0,
              "isfamily": 0
            },
            "dates": {
              "posted": "1707406357",
              "taken": "2024-02-08 07:22:41",
              "takengranularity": 0,
              "takenunknown": "1",
              "lastupdate": "1707501569"
            },
            "views": "30",
            "editability": {
              "cancomment": 0,
              "canaddmeta": 0
            },
            "publiceditability": {
              "cancomment": 1,
              "canaddmeta": 0
            },
            "usage": {
              "candownload": 1,
              "canblog": 0,
              "canprint": 0,
              "canshare": 1
            },
            "comments": {
              "_content": "0"
            },
            "notes": {
              "note": []
            },
            "people": {
              "haspeople": 0
            },
            "tags": {
              "tag": []
            },
            "urls": {
              "url": [
                {
                  "type": "photopage",
                  "_content": ""
                }
              ]
            },
            "media": "photo"
          },
          "stat": "ok"
        }
        """.data(using: .utf8)!, 200)
        
        let client = FlickrClient(session: session, apiKey: "TEST_KEY")
        
        let photo = try await client.info(for: "53517142775")
        XCTAssertEqual(photo.title, "Example Title")
        XCTAssertEqual(photo.description, "Example Description")
    }
}
