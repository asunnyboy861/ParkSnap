import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            QuickSaveView()
                .tabItem {
                    Label("Save", systemImage: "parkingsign.circle.fill")
                }
                .tag(0)

            FindCarView()
                .tabItem {
                    Label("Find", systemImage: "car.fill")
                }
                .tag(1)

            ParkingTimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(2)

            HistoryListView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.blue)
    }
}
