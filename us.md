# ParkSnap - iOS Development Guide

## Executive Summary

ParkSnap is a photo-first parking spot recorder designed for iPhone and Apple Watch. Unlike all existing parking apps that rely on GPS (which fails in multi-level garages), ParkSnap prioritizes photo capture as the primary way to remember where you parked. Users can save their spot in under 3 seconds: open app, snap a photo, done. The app supports floor/zone/spot tracking, parking timers with Live Activity, home screen widgets, Apple Watch companion, and Siri Shortcuts integration.

**Target Audience**: US drivers who frequently park in multi-level garages, large lots, or unfamiliar areas. Special focus on ADHD users who need zero-thinking workflows.

**Key Differentiators**:
- Photo-first approach (works where GPS fails)
- Floor/zone/spot tracking (no competitor does this well)
- 3-second save workflow (vs 10+ seconds in competitors)
- ADHD-friendly zero-thinking design
- All data stored locally (privacy-first)

## Competitive Analysis

| App | Rating | Price | Strengths | Weaknesses | Our Advantage |
|-----|--------|-------|-----------|------------|---------------|
| Find My Car - Car Parking | 4.7 (1.7K) | $0.99 + IAP | GPS, compass, photo, timer, Apple Watch | GPS fails in garages, no floor tracking, complex UI | Photo-first + floor tracking + 3-sec save |
| Parked Here - Find My Car | 4.4 (2.9K) | Free + IAP | Unlimited saves, multiple vehicles, sharing | No floor/zone tracking, GPS-dependent | Floor/zone/spot combo + photo priority |
| iParkGo | New | Free + $0.99/mo | Simple interface, photo notes | Subscription for basic features, 3 saves/week limit | One-time purchase, no save limits, floor tracking |
| Find Car: Parked Locator | New | Free | GPS, photo, history, sharing | No floor tracking, basic timer, ads/tracking | Privacy-first, no ads, floor/zone/spot |

**Market Gap**: No existing app solves the multi-level garage problem. All competitors are GPS-first, which fundamentally fails in covered parking structures. ParkSnap's photo-first approach is the only reliable solution for indoor parking.

## Apple Design Guidelines Compliance

- **Maps**: Use MapKit with standard emphasis style; make map interactive (zoom, pan); use custom annotations for car location; provide Apple Maps and Google Maps navigation options
- **Navigation**: Tab-based navigation for main features (Save, Find, Timer, History); navigation bars with clear titles; back button for detail views
- **Haptics**: Provide haptic feedback on save action; use notification haptics for timer alerts
- **Dark Mode**: Full dark mode support (critical for dimly lit parking garages); use semantic colors (`.primary`, `.secondary`, `.tint`)
- **Privacy**: All data stored locally via SwiftData; no accounts, no cloud sync, no third-party data sharing; request location and camera permissions with clear explanations
- **Widgets**: Follow WidgetKit guidelines for home screen and lock screen widgets; use `containerBackground` for widget styling
- **Live Activity**: Follow ActivityKit guidelines for lock screen timer display; provide meaningful updates
- **Accessibility**: VoiceOver labels for all interactive elements; Dynamic Type support; sufficient color contrast

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (camera via UIViewControllerRepresentable)
- **Data**: SwiftData with @Model for local persistence
- **Location**: CoreLocation for GPS coordinates
- **Camera**: AVFoundation for photo capture
- **Maps**: MapKit for displaying parking location and navigation
- **Notifications**: UserNotifications for timer reminders
- **Widgets**: WidgetKit for home screen widgets
- **Live Activity**: ActivityKit for lock screen timer
- **Shortcuts**: AppIntents for Siri integration
- **Bluetooth**: CoreBluetooth for auto-detect car disconnect
- **In-App Purchase**: StoreKit 2 for Pro upgrade

## Module Structure

```
ParkSnap/
├── App/
│   ├── ParkSnapApp.swift
│   └── AppDelegate.swift
├── Models/
│   ├── ParkingSpot.swift
│   └── ParkingTimer.swift
├── ViewModels/
│   ├── ParkingViewModel.swift
│   ├── TimerViewModel.swift
│   └── HistoryViewModel.swift
├── Views/
│   ├── Main/
│   │   ├── MainTabView.swift
│   │   └── QuickSaveView.swift
│   ├── Save/
│   │   ├── PhotoCaptureView.swift
│   │   ├── FloorZonePicker.swift
│   │   └── NoteInputView.swift
│   ├── Find/
│   │   ├── FindCarView.swift
│   │   └── PhotoReferenceView.swift
│   ├── Timer/
│   │   ├── ParkingTimerView.swift
│   │   └── TimerSetupView.swift
│   ├── History/
│   │   └── HistoryListView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Components/
│       ├── ParkingInfoCard.swift
│       ├── PhotoPlaceholderView.swift
│       ├── CircularTimerView.swift
│       └── NavigationButton.swift
├── Services/
│   ├── LocationService.swift
│   ├── PhotoService.swift
│   ├── NotificationService.swift
│   ├── BluetoothService.swift
│   └── PurchaseManager.swift
├── Widgets/
│   ├── ParkSnapWidget.swift
│   └── ParkSnapLiveActivity.swift
├── Watch/
│   └── ParkSnapWatchApp.swift
├── Intents/
│   ├── SaveParkingSpotIntent.swift
│   └── FindMyCarIntent.swift
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

## Implementation Flow

1. Configure Xcode project: Bundle ID `com.zzoutuo.ParkSnap`, iOS 17.0+, capabilities
2. Create data model: `ParkingSpot` with SwiftData @Model
3. Implement services: LocationService, PhotoService, NotificationService
4. Build QuickSaveView: photo capture + floor/zone picker + save button
5. Build FindCarView: map with car annotation + photo reference + navigation buttons
6. Build ParkingTimerView: duration picker + circular countdown + notifications
7. Build HistoryListView: list of past parking spots with search
8. Build SettingsView: preferences + Pro upgrade + policy links + contact support
9. Implement WidgetKit: home screen widget showing active parking info
10. Implement ActivityKit: Live Activity for lock screen timer
11. Implement AppIntents: Siri Shortcuts for save and find
12. Implement StoreKit 2: PurchaseManager for Pro upgrade
13. Add Apple Watch companion app
14. Add Bluetooth auto-detect for car disconnect
15. Polish UI: animations, dark mode, iPad layout

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: #007AFF (iOS Blue) - trust, navigation, tech
  - Success: #34C759 (Green) - save confirmation, timer normal
  - Warning: #FF3B30 (Red) - timer expiring
  - Background Light: #F2F2F7 (iOS System Grouped Background)
  - Background Dark: #1C1C1E (iOS Dark Background)
  - Card Light: #FFFFFF
  - Card Dark: #2C2C2E

- **Typography**:
  - Navigation Title: Large Title (34pt bold)
  - Section Headers: Headline (17pt semibold)
  - Body: Body (17pt regular)
  - Timer Display: System Rounded Thin 48pt
  - Captions: Caption1 (12pt regular)

- **Layout**:
  - Tab-based navigation: Save, Find, Timer, History
  - Cards with .ultraThinMaterial background
  - Rounded corners: 16pt for cards, 12pt for buttons
  - Content max width on iPad: 720pt centered
  - Safe area padding: 20pt horizontal, 16pt vertical

- **Animations**:
  - Save success: scale bounce + haptic feedback
  - Timer countdown: smooth circular progress animation
  - Tab transitions: default iOS tab transition
  - Photo capture: fade-in with scale effect

## Code Generation Rules

- Use SwiftUI for all views
- Use SwiftData with @Model for data persistence
- Use @Observable for ViewModels (iOS 17+)
- Use MVVM pattern throughout
- No code comments unless explicitly requested
- All data stored locally (no cloud, no accounts)
- Privacy-first: minimal permissions, clear explanations
- iPad: content max width 720pt, centered
- Support Dynamic Type and VoiceOver
- Use semantic colors for dark mode support

## Build & Deployment Checklist

- [ ] Xcode project configured with Bundle ID com.zzoutuo.ParkSnap
- [ ] iOS 17.0+ deployment target set
- [ ] All capabilities enabled (Camera, Location, Notifications, Bluetooth)
- [ ] App Icon generated and configured
- [ ] Build succeeds on iPhone simulator
- [ ] Build succeeds on iPad simulator
- [ ] All core features tested on simulator
- [ ] No hardcoded secrets in source code
- [ ] Policy pages created and deployed
- [ ] App Store metadata prepared
- [ ] Screenshots captured for App Store
