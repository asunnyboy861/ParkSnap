import SwiftUI
import MapKit
import SwiftData

struct FindCarView: View {
    @Query(filter: #Predicate<ParkingSpot> { $0.isActive },
           sort: \ParkingSpot.timestamp,
           order: .reverse)
    private var activeSpots: [ParkingSpot]

    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showPhoto = false
    @State private var selectedSpot: ParkingSpot?
    @State private var purchaseManager = PurchaseManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                if let spot = activeSpots.first {
                    Map(position: $position) {
                        UserAnnotation()
                        Annotation("Your Car", coordinate: spot.coordinate) {
                            Image(systemName: "car.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                                .padding(8)
                                .background(.white, in: Circle())
                                .shadow(radius: 4)
                        }
                    }

                    VStack {
                        Spacer()

                        ParkingInfoCard(spot: spot) {
                            selectedSpot = spot
                            showPhoto = true
                        }

                        if spot.hasGPSCoordinates {
                            HStack(spacing: 12) {
                                NavigationButton(title: "Apple Maps", icon: "map") {
                                    openNavigation(spot: spot, app: .apple)
                                }

                                if purchaseManager.isPro {
                                    NavigationButton(title: "Google Maps", icon: "globe") {
                                        openNavigation(spot: spot, app: .google)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "No Active Parking",
                        systemImage: "parkingsign",
                        description: Text("Save your parking spot first!")
                    )
                }
            }
            .navigationTitle("Find My Car")
            .sheet(isPresented: $showPhoto) {
                if let spot = selectedSpot, let data = spot.photoData, let image = UIImage(data: data) {
                    PhotoDetailView(image: image, spot: spot)
                }
            }
        }
    }

    private func openNavigation(spot: ParkingSpot, app: NavigationApp) {
        let coordinate = spot.coordinate
        switch app {
        case .apple:
            if let url = URL(string: "maps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&dirflg=w") {
                UIApplication.shared.open(url)
            }
        case .google:
            if let url = URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=walking") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else if let webUrl = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(coordinate.latitude),\(coordinate.longitude)&travelmode=walking") {
                    UIApplication.shared.open(webUrl)
                }
            }
        }
    }
}

private enum NavigationApp {
    case apple, google
}

struct NavigationButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.bordered)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
