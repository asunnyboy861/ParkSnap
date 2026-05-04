import SwiftUI

struct PaywallView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)

                Text("ParkSnap Pro")
                    .font(.largeTitle.bold())

                Text("Unlock all premium features")
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "clock.arrow.circlepath", title: "Unlimited History", description: "Save unlimited parking records")
                    FeatureRow(icon: "square.grid.2x2", title: "Home Screen Widget", description: "Quick access from your home screen")
                    FeatureRow(icon: "lock.rectangle", title: "Live Activity", description: "Lock screen timer countdown")
                    FeatureRow(icon: "watch.apple", title: "Apple Watch", description: "Find your car from your wrist")
                    FeatureRow(icon: "wave.3.forward", title: "Bluetooth Auto-Park", description: "Auto-detect when you park")
                    FeatureRow(icon: "siri", title: "Siri Shortcuts", description: "Voice control parking")
                    FeatureRow(icon: "map", title: "Google Maps & Waze", description: "Choose your navigation app")
                    FeatureRow(icon: "photo.on.rectangle.angled", title: "Multiple Photos", description: "Save 2 photos per spot")
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))

                Button {
                    Task {
                        if await purchaseManager.purchase() {
                            dismiss()
                        }
                    }
                } label: {
                    if purchaseManager.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    } else {
                        Text("Unlock Pro — $2.99")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button("Restore Purchases") {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
