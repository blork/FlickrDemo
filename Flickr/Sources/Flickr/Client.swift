import Foundation

public protocol Client {
    func search(_ query: Search.Query) async throws -> [Search.Item]
    func info(for id: Photo.ID) async throws -> Photo
}

public enum HTTPMethod: String {
    case GET
    case POST
}

enum ClientError: Error {
    case invalidURL
    case unexpected(response: HTTPURLResponse)
    case unknown(underlying: Error)
}

extension FlickrClient: Client {
    
    public func search(_ query: Search.Query) async throws -> [Search.Item] {
        let response: Search.Response = try await perform(request(.GET, query))
        return response.results.items
    }
    
    public func info(for id: Photo.ID) async throws -> Photo {
        let response: Photo.Response = try await perform(request(.GET, Photo.Query(id: id)))
        return response.photo
    }
}

public class FlickrClient {
    
    private static let baseURL = "https://api.flickr.com/services/rest"
    
    let session: Session
    let apiKey: String
    
    let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .lenient
        return decoder
    }()
    
    public init(session: Session, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }

    func request(_ method: HTTPMethod, _ query: QueryItemConvertible) throws -> URLRequest {
        var components = URLComponents(string: FlickrClient.baseURL)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
        ] + query.queryItems
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return request
        } else {
            throw ClientError.invalidURL
        }
    }
    
    func perform<T>(_ request: URLRequest) async throws -> T where T: Decodable {
        let data: Data
        let urlResponse: URLResponse
        do {
            let response = try await session.data(for: request)
            data = response.0
            urlResponse = response.1
        } catch {
            throw ClientError.unknown(underlying: error)
        }
        
        let httpResponse = (urlResponse as! HTTPURLResponse)
            
        if httpResponse.statusCode != 200 {
            throw ClientError.unexpected(response: httpResponse)
        }
        
        // print(String(data: data, encoding: .utf8)!)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ClientError.unknown(underlying: error)
        }
    }
}
