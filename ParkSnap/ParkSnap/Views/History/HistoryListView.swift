import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ParkingSpot.timestamp, order: .reverse) private var allSpots: [ParkingSpot]
    @State private var purchaseManager = PurchaseManager.shared
    @State private var searchText = ""

    private var displayedSpots: [ParkingSpot] {
        if purchaseManager.isPro {
            return allSpots
        } else {
            return Array(allSpots.prefix(1))
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if displayedSpots.isEmpty {
                    ContentUnavailableView(
                        "No Parking History",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Your saved parking spots will appear here.")
                    )
                } else {
                    List {
                        ForEach(displayedSpots) { spot in
                            NavigationLink {
                                SpotDetailView(spot: spot)
                            } label: {
                                SpotRow(spot: spot)
                            }
                        }
                        .onDelete(perform: deleteSpots)
                    }
                    .searchable(text: $searchText, prompt: "Search parking spots")
                }
            }
            .navigationTitle("History")
            .toolbar {
                if !purchaseManager.isPro && allSpots.count > 1 {
                    ToolbarItem {
                        NavigationLink {
                            PaywallView()
                        } label: {
                            Text("Unlock All")
                                .font(.caption.bold())
                        }
                    }
                }
            }
        }
    }

    private func deleteSpots(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(displayedSpots[index])
        }
    }
}

struct SpotRow: View {
    let spot: ParkingSpot

    var body: some View {
        HStack(spacing: 12) {
            if let data = spot.photoData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "parkingsign")
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 50, height: 50)
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(spot.locationDescription)
                    .font(.subheadline.bold())
                Text(spot.timestamp, format: .dateTime.month().day().hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if spot.isActive {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SpotDetailView: View {
    let spot: ParkingSpot

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = spot.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                Group {
                    LabeledContent("Floor", value: spot.floorDisplay)
                    LabeledContent("Zone", value: spot.zone.isEmpty ? "None" : spot.zone)
                    LabeledContent("Spot #", value: spot.spotNumber.isEmpty ? "None" : spot.spotNumber)
                    if !spot.note.isEmpty {
                        LabeledContent("Note", value: spot.note)
                    }
                    LabeledContent("Saved", value: spot.timestamp, format: .dateTime)
                    if spot.hasGPSCoordinates {
                        LabeledContent("GPS", value: "Available")
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Parking Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
