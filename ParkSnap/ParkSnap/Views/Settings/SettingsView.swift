import SwiftUI

struct SettingsView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Pro Features") {
                    if purchaseManager.isPro {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            Text("ParkSnap Pro")
                                .font(.headline)
                            Spacer()
                            Text("Active")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        NavigationLink {
                            PaywallView()
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.yellow)
                                Text("Upgrade to Pro")
                                    .font(.headline)
                            }
                        }
                    }

                    Button("Restore Purchases") {
                        Task {
                            await purchaseManager.restorePurchases()
                        }
                    }
                }

                Section("Preferences") {
                    Toggle("Show Onboarding", isOn: $hasSeenOnboarding)
                }

                Section("Legal") {
                    Link("Support", destination: URL(string: "https://asunnyboy861.github.io/ParkSnap/support.html")!)
                    Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/ParkSnap/privacy.html")!)
                }

                Section {
                    NavigationLink {
                        ContactSupportView()
                    } label: {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }

                Section {
                    HStack {
                        Spacer()
                        Text("ParkSnap v1.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
