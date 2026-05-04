import Foundation
import SwiftData
import CoreLocation

@Model
final class ParkingSpot {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var hasGPSCoordinates: Bool
    var floor: Int
    var zone: String
    var spotNumber: String
    var note: String
    var photoData: Data?
    var secondPhotoData: Data?
    var timerDuration: TimeInterval
    var timerEndTime: Date?
    var isTimerActive: Bool
    var venueName: String?
    var address: String?

    init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        latitude: Double = 0,
        longitude: Double = 0,
        hasGPSCoordinates: Bool = false,
        floor: Int = 1,
        zone: String = "",
        spotNumber: String = "",
        note: String = "",
        photoData: Data? = nil,
        secondPhotoData: Data? = nil,
        timerDuration: TimeInterval = 0,
        timerEndTime: Date? = nil,
        isTimerActive: Bool = false,
        venueName: String? = nil,
        address: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.hasGPSCoordinates = hasGPSCoordinates
        self.floor = floor
        self.zone = zone
        self.spotNumber = spotNumber
        self.note = note
        self.photoData = photoData
        self.secondPhotoData = secondPhotoData
        self.timerDuration = timerDuration
        self.timerEndTime = timerEndTime
        self.isTimerActive = isTimerActive
        self.venueName = venueName
        self.address = address
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var isActive: Bool {
        Calendar.current.dateComponents([.minute], from: timestamp, to: .now).minute ?? 0 < 1440
    }

    var floorDisplay: String {
        if floor == 0 { return "G" }
        if floor < 0 { return "B\(abs(floor))" }
        return "\(floor)"
    }

    var locationDescription: String {
        var parts: [String] = []
        parts.append("Floor \(floorDisplay)")
        if !zone.isEmpty { parts.append("Zone \(zone)") }
        if !spotNumber.isEmpty { parts.append("#\(spotNumber)") }
        return parts.joined(separator: ", ")
    }
}
