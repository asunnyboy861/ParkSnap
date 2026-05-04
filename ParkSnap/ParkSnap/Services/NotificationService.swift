import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleParkingReminder(endTime: Date, spotId: UUID) {
        let content = UNMutableNotificationContent()
        content.title = "ParkSnap"
        content.body = "Your parking time is almost up!"
        content.sound = .default
        content.userInfo = ["spotId": spotId.uuidString]

        let fiveMinBefore = endTime.addingTimeInterval(-300)
        let tenMinBefore = endTime.addingTimeInterval(-600)

        let trigger5 = UNTimeIntervalNotificationTrigger(
            timeInterval: max(fiveMinBefore.timeIntervalSinceNow, 1),
            repeats: false
        )
        let trigger10 = UNTimeIntervalNotificationTrigger(
            timeInterval: max(tenMinBefore.timeIntervalSinceNow, 1),
            repeats: false
        )

        let request5 = UNNotificationRequest(
            identifier: "\(spotId.uuidString)-5min",
            content: content,
            trigger: trigger5
        )
        let content10 = content
        content10.body = "10 minutes left on your parking!"
        let request10 = UNNotificationRequest(
            identifier: "\(spotId.uuidString)-10min",
            content: content10,
            trigger: trigger10
        )

        UNUserNotificationCenter.current().add(request5)
        UNUserNotificationCenter.current().add(request10)
    }

    func cancelReminder(spotId: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [
                "\(spotId.uuidString)-5min",
                "\(spotId.uuidString)-10min"
            ])
    }
}
