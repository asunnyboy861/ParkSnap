import SwiftUI
import SwiftData

@main
struct ParkSnapApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: ParkingSpot.self)
    }
}
