import Foundation

extension DateFormatter {
    static var takenDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .gmt
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static var lenient: JSONDecoder.DateDecodingStrategy {
        .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let takenDate = DateFormatter.takenDateFormatter.date(from: dateString) {
                return takenDate
            } else if let unixTime = Double(dateString) {
                return Date(timeIntervalSince1970: unixTime)
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
    }
}

