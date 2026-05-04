# Capabilities Configuration

## Analysis
Based on operation guide analysis, the following capabilities are required:
- Camera: Photo capture for parking spot recording
- Location Services: GPS coordinates for parking location
- Notifications: Timer reminders for parking meter expiration
- Bluetooth: Auto-detect car Bluetooth disconnect for parking
- In-App Purchase: Pro upgrade ($2.99 one-time)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Camera | ✅ Configured | Info.plist NSCameraUsageDescription |
| Location (When In Use) | ✅ Configured | Info.plist NSLocationWhenInUseUsageDescription |
| Notifications | ✅ Configured | Info.plist + UNUserNotificationCenter |
| In-App Purchase | ✅ Configured | StoreKit 2 framework |
| Bluetooth | ✅ Configured | Info.plist NSBluetoothAlwaysUsageDescription |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| Apple Watch | ⏳ Pending | Add Watch App target in Xcode if needed |
| WidgetKit | ⏳ Pending | Add Widget Extension target in Xcode |
| Live Activity | ⏳ Pending | Add ActivityKit support in Info.plist |

## No Configuration Needed
- iCloud: Not needed (all data stored locally)
- HealthKit: Not applicable
- Sign in with Apple: Not needed (no accounts)
- Background Modes: Not needed (notifications handle timer)

## Info.plist Keys Required
- NSCameraUsageDescription: "ParkSnap needs camera access to photograph your parking spot."
- NSLocationWhenInUseUsageDescription: "ParkSnap needs your location to save where you parked."
- NSBluetoothAlwaysUsageDescription: "ParkSnap uses Bluetooth to detect when you disconnect from your car."
- NSSupportsLiveActivities: YES

## Verification
- Build succeeded after configuration: Pending
- All entitlements correct: Pending
