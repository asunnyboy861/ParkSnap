import SwiftUI

struct ParkingInfoCard: View {
    let spot: ParkingSpot
    let onTapPhoto: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "car.fill")
                    .foregroundStyle(.blue)
                    .font(.title3)
                Text(spot.locationDescription)
                    .font(.headline)
                Spacer()
                if spot.hasGPSCoordinates {
                    Image(systemName: "location.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                }
            }

            if !spot.note.isEmpty {
                Text(spot.note)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text(spot.timestamp, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if spot.photoData != nil {
                    Button("View Photo") {
                        onTapPhoto()
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct PhotoDetailView: View {
    let image: UIImage
    let spot: ParkingSpot

    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()

                Text(spot.locationDescription)
                    .font(.headline)
                    .padding(.bottom)
            }
            .navigationTitle("Parking Photo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
