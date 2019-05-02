import Foundation

/// common properties for all events
struct Common: Codable {
    let deviceID, eventID: String
    let platform: String
    let schemaVersion, timestamp, userID, version: String

    enum CodingKeys: String, CodingKey {
        case deviceID = "device_id"
        case eventID = "event_id"
        case platform
        case schemaVersion = "schema_version"
        case timestamp
        case userID = "user_id"
        case version
    }
}

public struct CommonProxy {
    var deviceID: () -> (String)
    var eventID: () -> (String)
    var timestamp: () -> (String)
    var userID: () -> (String)
    var version: () -> (String)
    var snapshot: Common {
        return Common(
            deviceID: deviceID(),
            eventID: eventID(),
            platform: "iOS",
            schemaVersion: "91a597915349050c03aa37bebd1b9ee701c5ecd8",
            timestamp: timestamp(),
            userID: userID(),
            version: version())
    }
}
