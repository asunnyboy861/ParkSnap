import SwiftUI

struct ParkingTimerView: View {
    @State private var selectedDuration: ParkingDuration = .oneHour
    @State private var customMinutes: Int = 60
    @State private var remainingTime: TimeInterval?
    @State private var timer: Timer?
    @State private var isRunning = false

    private let notificationService = NotificationService.shared

    enum ParkingDuration: TimeInterval, CaseIterable {
        case thirtyMin = 1800
        case oneHour = 3600
        case twoHours = 7200
        case threeHours = 10800
        case custom = 0

        var label: String {
            switch self {
            case .thirtyMin: return "30 min"
            case .oneHour: return "1 hour"
            case .twoHours: return "2 hours"
            case .threeHours: return "3 hours"
            case .custom: return "Custom"
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if isRunning, let remaining = remainingTime {
                    CircularTimerView(remaining: remaining, total: selectedDuration == .custom ? Double(customMinutes * 60) : selectedDuration.rawValue)

                    Text(timeString(from: remaining))
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                        .monospacedDigit()

                    Button("Cancel Timer") {
                        stopTimer()
                    }
                    .foregroundStyle(.red)
                } else {
                    Picker("Duration", selection: $selectedDuration) {
                        ForEach(ParkingDuration.allCases, id: \.self) { duration in
                            Text(duration.label).tag(duration)
                        }
                    }
                    .pickerStyle(.segmented)

                    if selectedDuration == .custom {
                        Stepper("\(customMinutes) minutes", value: $customMinutes, in: 5...480, step: 5)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        startTimer()
                    } label: {
                        Label("Start Timer", systemImage: "timer")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
            .navigationTitle("Parking Timer")
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
    }

    private func startTimer() {
        let duration = selectedDuration == .custom ? Double(customMinutes * 60) : selectedDuration.rawValue
        remainingTime = duration
        isRunning = true

        let endTime = Date().addingTimeInterval(duration)
        notificationService.scheduleParkingReminder(endTime: endTime, spotId: UUID())

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            remainingTime = max(0, endTime.timeIntervalSinceNow)
            if remainingTime! <= 0 {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingTime = nil
    }

    private func timeString(from interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) % 3600 / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct CircularTimerView: View {
    let remaining: TimeInterval
    let total: TimeInterval

    var progress: Double {
        total > 0 ? remaining / total : 0
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.2), lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progress > 0.25 ? Color.blue : Color.red, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
        }
        .frame(width: 200, height: 200)
    }
}
