@testable import Flickr
import XCTest

final class DateDecoderTests: XCTestCase {
    
    struct TestData: Decodable {
        let date: Date
    }
    
    func test_dateInMySQLFormat_parsedWithLenientStrategy_returnsCorrectDate() async throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .lenient
        let dateString = """
                { "date": "2004-11-29 16:01:26"}
        """
        
        let parsed = try decoder.decode(TestData.self, from: dateString.data(using: .utf8)!)
    
        XCTAssertEqual(parsed.date, Date(timeIntervalSince1970: 1_101_744_086))
    }
    
    func test_dateInUnixFormat_parsedWithLenientStrategy_returnsCorrectDate() async throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .lenient
        let dateString = """
                { "date": "1101744086" }
        """
        
        let parsed = try decoder.decode(TestData.self, from: dateString.data(using: .utf8)!)
    
        XCTAssertEqual(parsed.date, Date(timeIntervalSince1970: 1_101_744_086))
    }

    func test_dateInInvalidFormat_parsedWithLenientStrategy_throwsError() async throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .lenient
        let dateString = """
                { "date": "hello" }
        """
        
        XCTAssertThrowsError(try decoder.decode(TestData.self, from: dateString.data(using: .utf8)!))
    }
}
